//
//  BFBriefcastViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastViewController.h"
#import "FeedParser.h"
//#import "BFTitleCellController.h"
//#import "BFLabelCellController.h"
//#import "BFParagraphCellController.h"
//#import "BFHeaderCellController.h"
#import "BFBriefCellController.h"
#import "BFRemoteBriefCellController.h"
#import "BFDataManager.h"
#import "BFColor.h"


@implementation BFBriefcastViewController

@synthesize channelTitle, channelLink, channelDescription, locationOfBriefcast, enclosedBriefs, recievedData, briefcast;

- (id)init
{
    return [super initWithNibName:@"BFBriefcastViewController" bundle:nil];
}

- (IBAction)reloadBriefcast
{
    // TODO: implement reloading of the briefcast
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFRemoteBriefEventDelegate Methods

- (void)shouldDownloadBrief:(id)sender atURL:(NSString *)url
{
//    BFLoadingViewController *loader = [[BFLoadingViewController alloc] init];
//    [loader setDelegate:self];
//    
//    loader.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentModalViewController:loader animated:YES];
//    [loader load:url withInitialStatus:@"Downloading the Brief..." animated:YES];
    
    BFLoadingViewController *loading = [[BFLoadingViewController alloc] init];
    [loading view].frame = CGRectOffset([loading view].frame, 40, 30);
    [loading setDelegate:self];
    
    [UIView beginAnimations:@"load loader animation" context:nil];
        [loading view].alpha = 0.0f;
        [self.view addSubview:[loading view]];
        [loading view].alpha = 1.0f;
    [UIView commitAnimations];
    
    [loading load:url withInitialStatus:@"Locating the Brief..." animated:YES];
    
}

- (void)shouldLaunchBrief:(id)sender atURL:(NSString *)url
{
    
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
}

- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)loadingView:(BFLoadingViewController *)controller shouldDismissView:(BOOL)animate
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)loadingView:(BFLoadingViewController *)controller shouldDismissViewWithAction:(BOOL)animate
{
    [self dismissLoadingViewAnimation:[controller view]];
}

- (void)fadeLoadingViewDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    UIView *view = context;
    [view removeFromSuperview];
}

- (void)dismissLoadingViewAnimation:(UIView *)loadingView
{
    [UIView beginAnimations:@"dismiss loader animation" context:loadingView];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeLoadingViewDidStop:finished:context:)];
    loadingView.alpha = 0.0f;
    [UIView commitAnimations];
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
            BFBriefCellController *controller = [[BFBriefCellController alloc] initWithEnclosure:item installType:BFBriefCellInstallTypeNewInstall];
            controller.delegate = self;
            [groups addObject:controller];
            [controller release];
        }
        
        self.tableGroups = [NSArray arrayWithObjects:groups, nil];
    }
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [BFColor tintColorForNavigationBar];
    
    if (briefcast) 
        self.locationOfBriefcast = [briefcast fromURL];
    
    if (self.locationOfBriefcast != nil) {
        
        // Display "loading..." message and a spinner
        // TODO: move the loading message & spinner 
        //       to the header view.
        
        self.title = @"Loading...";
        spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        spinner.hidesWhenStopped = YES;
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease];
        
        self.recievedData = [[NSMutableData alloc] initWithLength:0];
        
        // Load Briefcast url
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self locationOfBriefcast]]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    }
}


- (void)dealloc 
{
    [self.channelLink release];
    [self.channelTitle release];
    [self.channelDescription release];
    [self.enclosedBriefs release];
    [self.locationOfBriefcast release];
    [self.briefcast release];
    [super dealloc];
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
    NSError *error = [[[NSError alloc] init] autorelease];
    FPFeed *feed = [FPParser parsedFeedWithData:self.recievedData error:&error];
    
    self.channelTitle = [feed title];
    self.channelLink = [[feed link] href];
    self.channelDescription = [feed feedDescription];    
    self.enclosedBriefs = [feed items];
    
    // Update the UI
    self.title = [NSString stringWithFormat:@"%i Briefs", [[feed items] count]];
    
    titleLabel.text = self.channelTitle;
    locationLabel.text = self.channelLink;
    
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
