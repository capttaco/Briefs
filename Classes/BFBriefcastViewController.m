//
//  BFBriefcastViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastViewController.h"
#import "FeedParser.h"
#import "BFBriefCellController.h"
#import "BFDataManager.h"
#import "BFConfig.h"



@interface BFBriefcastViewController (PrivateMethods) 

- (void)dismissLoadingViewAnimation:(UIView *)loadingView;

@end



@implementation BFBriefcastViewController

@synthesize channelTitle, channelLink, channelDescription, locationOfBriefcast, enclosedBriefs, recievedData, briefcast;

- (id)init
{
    return [super initWithNibName:@"BFBriefcastViewController" bundle:nil];
}

- (IBAction)reloadBriefcast
{
    if (self.channelTitle != nil) {
        locationLabel.alpha = 0.0f;
        buttonView.alpha = 0.0f;
        self.channelTitle = nil;
        [super updateAndReload];
    }
    
    // Display "loading..." message and a spinner        
    self.title = @"None";
    titleLabel.text = @"Loading...";        
    self.recievedData = [[NSMutableData alloc] initWithLength:0];
    [spinner startAnimating];
    
    // Load Briefcast url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self locationOfBriefcast]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFRemoteBriefEventDelegate Methods

- (void)shouldDownloadBrief:(id)sender atURL:(NSString *)url
{    
    BFLoadingViewController *loading = [[BFLoadingViewController alloc] init];
    [loading view].frame = CGRectOffset([loading view].frame, 0, 72);
    [loading setDelegate:self];
    
    [UIView beginAnimations:@"load loader animation" context:nil];
        [loading view].alpha = 0.0f;
        [self.view addSubview:[loading view]];
        [loading view].alpha = 1.0f;
    [UIView commitAnimations];
    
    [loading load:url withStatus:@"Trying on a new pair..."];
    
}

- (void)shouldLaunchBrief:(id)sender atURL:(NSString *)url
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    BFRemoteBriefViewController *remote = [[BFRemoteBriefViewController alloc] initWithLocationOfBrief:url];
    [remote setDelegate:self];
    [remote setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:remote animated:YES];
    
    self.modalViewController.view.frame = CGRectMake(0.0, 0.0, 320.0f, 480.0f);
    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFRemoteBriefViewDelegate Methods

- (void)remoteView:(BFRemoteBriefViewController *)view shouldDismissView:(BriefRef *)savedBrief;
{
    if (savedBrief != nil) {

        // if the user opts to save the brief,
        // include the briefcast information
        
        [savedBrief setBriefcast:self.briefcast];
        [[BFDataManager sharedBFDataManager] save];
        
        [self updateAndReload];
    }    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self dismissModalViewControllerAnimated:YES];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFLoadingViewDelegate Methods

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data
{
    NSString *remoteNameOfBrief = [[controller locationOfRequest] lastPathComponent];
    BriefRef *ref = [[BFDataManager sharedBFDataManager] addBriefAtPath:remoteNameOfBrief usingData:data fromURL:[controller locationOfRequest]];
    [ref setBriefcast:briefcast];
    [[BFDataManager sharedBFDataManager] save];
    
    [self performSelector:@selector(dismissLoadingViewAnimation:) withObject:[controller view] afterDelay:1.0f];
}

- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)loadingView:(BFLoadingViewController *)controller shouldDismissView:(BOOL)animate
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)loadingView:(BFLoadingViewController *)controller didCancelConnection:(NSString *)url
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)fadeLoadingViewDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    UIView *view = (__bridge UIView*)context;
    [view removeFromSuperview];
}

- (void)dismissLoadingViewAnimation:(UIView *)loadingView
{
    [UIView beginAnimations:@"dismiss loader animation" context:(__bridge void*)loadingView];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeLoadingViewDidStop:finished:context:)];
    loadingView.alpha = 0.0f;
    [UIView commitAnimations];
    
    [self updateAndReload];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController overrides

- (void)constructTableGroups
{
    if (self.channelTitle != nil) {
        NSMutableArray *groups = [NSMutableArray arrayWithCapacity:[self.enclosedBriefs count]];
        
        // TODO: Look at currently stored briefs, offering different states
        //       if the brief is already installed (update if new, no action if not)
        
        for (FPItem *item in self.enclosedBriefs) {
            BFBriefCellController *controller = [[BFBriefCellController alloc] initWithEnclosure:item];
            controller.delegate = self;
            [groups addObject:controller];
        }
        
        self.tableGroups = [NSArray arrayWithObjects:groups, nil];
    }
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [BFConfig tintColorForNavigationBar];
    
    if (briefcast) 
        self.locationOfBriefcast = [briefcast fromURL];
    
    if (self.locationOfBriefcast != nil) {
        [self reloadBriefcast];
    }
}


- (void)dealloc 
{
    self.channelLink;
    self.channelTitle;
    self.channelDescription;
    self.enclosedBriefs;
    self.locationOfBriefcast;
    self.briefcast;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    NSError *error = [[NSError alloc] init];
    FPFeed *feed = [FPParser parsedFeedWithData:self.recievedData error:&error];
    
    self.channelTitle = [feed title];
    self.channelLink = [[feed link] href];
    self.channelDescription = [feed feedDescription];    
    self.enclosedBriefs = [feed items];
    
    // Update the UI
    [UIView beginAnimations:@"Fade-in Info" context:nil];
        self.title = [NSString stringWithFormat:@"%i Briefs", [[feed items] count]];
    
        // alter the UI
        titleLabel.text = self.channelTitle;
        locationLabel.text = self.channelLink;
        
        // fade back in the controls
        titleLabel.alpha = 1.0f;
        locationLabel.alpha = 1.0f;
        buttonView.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    // update the briefcast reference
    self.briefcast.totalNumberOfBriefcasts = [NSNumber numberWithInt:[[feed items] count]];
    self.briefcast.dateLastOpened = [NSDate date];
    [[BFDataManager sharedBFDataManager] save];
    
    [super updateAndReload];
    [spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: do something here.
    // Boom, we failed.
    NSLog(@"Boom, the briefcast load failed.");
}

///////////////////////////////////////////////////////////////////////////////

@end
