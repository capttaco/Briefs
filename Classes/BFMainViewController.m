//
//  BFMainViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 1/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewController.h"
#import "BFBrowseViewController.h"
#import "BFBrowseBriefcastsViewController.h"
#import "BFBriefcastViewController.h"
#import "BFDataManager.h"
#import "BFColor.h"
#import "BriefcastRef+BFBriefDataSource.h"
#import "BFPagedBrowseViewController.h"
#import "BFArrayBriefDataSource.h"

@interface BFMainViewController (PrivateMethods)

- (void)hideMenuWithAnimation;
- (void)showMenuWithAnimation;
- (void)dismissLoadingViewAnimation:(UIView *)loadingView;

@end


@implementation BFMainViewController

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject Methods

- (id)initWithState:(BFMainViewState)state 
{
    self = [super initWithNibName:@"BFMainViewController" bundle:nil];
    if (self != nil) {
        stateUponLaunch = state;
    }
    return self;
}

- (id)initWithExternalURL:(NSURL *)url 
{
    self = [self initWithState:BFMainViewOpenedByURL];
    if (self != nil) {
        urlLaunchWith = url;
    }
    
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSViewController Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [BFColor tintColorForNavigationBar];
    self.title = @"Welcome";
}

- (void)viewDidAppear:(BOOL)animated
{
    switch (stateUponLaunch) {
        case BFMainViewOpenedByURL:
            
            if ([[urlLaunchWith scheme] isEqualToString:@"brief"]) {
                NSString *modifiedRequestString = [[urlLaunchWith absoluteString] stringByReplacingOccurrencesOfString:@"brief://" withString:@"http://"]; 
                BFLoadingViewController *loading = [[BFLoadingViewController alloc] init];
                [loading view].frame = CGRectOffset([loading view].frame, 40, 30);
                [loading setDelegate:self];
                
                [UIView beginAnimations:@"load loader animation" context:nil];
                    [loading view].alpha = 0.0f;
                    [self.view addSubview:[loading view]];
                    [loading view].alpha = 1.0f;
                [UIView commitAnimations];
                
                [loading load:modifiedRequestString withInitialStatus:@"Locating the Brief..." animated:YES];
            }
            
            else if ([[urlLaunchWith scheme] isEqualToString:@"briefcast"]) {
                NSString *modifiedRequestString = [[urlLaunchWith absoluteString] stringByReplacingOccurrencesOfString:@"briefcast://" withString:@"http://"];                
                BFBriefcastViewController *viewer = [[BFBriefcastViewController alloc] initWithNibName:@"BFBriefcastViewController" bundle:nil];
                viewer.locationOfBriefcast = modifiedRequestString;
                
                // launch briefcast view
                [self.navigationController pushViewController:viewer animated:YES];
                
                [viewer release];
            }
            
            stateUponLaunch = BFMainViewDefaultState;
            break;
            
        case BFMainViewClosedWhilePlayingBrief:
            
            // TODO: Offer to re-open brief that was disrupted
            
            stateUponLaunch = BFMainViewDefaultState;
            break;
        
        case BFMainViewNoDataToDisplay:
            
            // TODO: Explain how to find a briefcast
            break;
        
        case BFMainViewFirstTimeOpened:
            
            // TODO: Display the welcome screens
            break;
            
        case BFMainViewDefaultState:
            if (menuView.frame.origin.y <= 480.0f)
                [self showMenuWithAnimation];
            
            // TODO: Display recent briefs/briefcasts
            
            break;
    }
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFLoadingViewDelegate Methods

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data
{
    NSString *remoteNameOfBrief = [[controller locationOfRequest] lastPathComponent];
    BriefRef *ref = [[BFDataManager sharedBFDataManager] addBriefAtPath:remoteNameOfBrief usingData:data fromURL:[controller locationOfRequest]];
    [ref setBriefcast:[[BFDataManager sharedBFDataManager] localBriefcastRefMarker]];
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
    
    // TODO: do something, like view the brief and stuff
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
    
    [self showMenuWithAnimation];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Main Menu Actions

- (void)hideMenuWithAnimation
{
    // push down the menu view
    [UIView beginAnimations:@"MenuSlideDownTransition" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 480.0f, size.width, size.height);
    
    [UIView commitAnimations];
}

- (void)showMenuWithAnimation 
{
    // push up the menu view
    [UIView beginAnimations:@"MenuSlideUpTransition" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 280.0f, size.width, size.height);
    
    [UIView commitAnimations];
}

- (IBAction)browseYourBriefs
{
    [self hideMenuWithAnimation];
    [self performSelector:@selector(_loadBriefsBrowser) withObject:nil afterDelay:0.1f];
}

- (void)_loadBriefsBrowser
{
    // TODO: Eventually replace this with a means to select
    //       briefs and drill-down based upon briefcast 
    //       (or other folder level organization)
    
    NSArray *knownBriefs = [[BFDataManager sharedBFDataManager] allBriefsSortedAs:BFDataManagerSortByDateOpened];
    BFArrayBriefDataSource *dataSource = [[BFArrayBriefDataSource alloc] initWithArray:knownBriefs];
    [self.navigationController pushViewController:[[[BFPagedBrowseViewController alloc] initWithDataSource:dataSource] autorelease] animated:YES];

    [dataSource release];
}

- (IBAction)browseYourBriefcasts
{
    [self hideMenuWithAnimation];
    [self performSelector:@selector(_loadBriefcastBrowser) withObject:nil afterDelay:0.2f];
}

- (void)_loadBriefcastBrowser
{
    [self.navigationController pushViewController:[[[BFBrowseBriefcastsViewController alloc] init] autorelease] animated:YES];
}

///////////////////////////////////////////////////////////////////////////////

@end
