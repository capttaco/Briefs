//
//  BFMainViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 1/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewController.h"
#import "BFBrowseBriefcastsViewController.h"
#import "BFMainViewDefaultController.h"
#import "BFBriefcastViewController.h"
#import "BFDataManager.h"
#import "BriefcastRef+BFBriefDataSource.h"
#import "BFPagedBrowseViewController.h"
#import "BFArrayBriefDataSource.h"
#import "BFConfig.h"

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
    self.navigationController.navigationBar.tintColor = [BFConfig tintColorForNavigationBar];
    self.title = @"Welcome";
}

- (void)viewDidAppear:(BOOL)animated
{
    switch (stateUponLaunch) {
        case BFMainViewOpenedByURL:
            
            if ([[urlLaunchWith scheme] isEqualToString:@"brief"]) {
                NSString *modifiedRequestString = [[urlLaunchWith absoluteString] stringByReplacingOccurrencesOfString:@"brief://" withString:@"http://"];
                [self shouldLaunchBrief:self atURL:modifiedRequestString];
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
            BFMainViewDefaultController *defaultController = [[BFMainViewDefaultController alloc] init];
            defaultController.view.frame = CGRectOffset(defaultController.view.frame, 0, 0.0f);
            [self.view addSubview:defaultController.view];
            
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
#pragma mark BFRemoteBriefViewDelegate Methods

- (void)remoteView:(BFRemoteBriefViewController *)view shouldDismissView:(BriefRef *)savedBrief
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [savedBrief setBriefcast:[[BFDataManager sharedBFDataManager] localBriefcastRefMarker]];
    [[BFDataManager sharedBFDataManager] save];
    
    [self dismissModalViewControllerAnimated:YES];
    [self showMenuWithAnimation];
}

- (void)shouldLaunchBrief:(id)sender atURL:(NSString *)url
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    BFRemoteBriefViewController *remote = [[BFRemoteBriefViewController alloc] initWithLocationOfBrief:url];
    [remote setDelegate:self];
    [remote setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:remote animated:YES];
    
    self.modalViewController.view.frame = CGRectMake(0.0, 0.0, 320.0f, 480.0f);
    [remote release];
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
    
//    CGSize bgSize = backgroundView.frame.size;
//    backgroundView.frame = CGRectMake(0.0f, 0.0f, bgSize.width, bgSize.height);
    
    [UIView commitAnimations];
}

- (void)showMenuWithAnimation 
{
    // push up the menu view
    [UIView beginAnimations:@"MenuSlideUpTransition" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 290.0f, size.width, size.height);
    
//    CGSize bgSize = backgroundView.frame.size;
//    backgroundView.frame = CGRectMake(0, -126.0f, bgSize.width, bgSize.height);
    
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
    
    BFArrayBriefDataSource *knownBriefs = [[BFDataManager sharedBFDataManager] allBriefsSortedAs:BFDataManagerSortByDateOpened];
    [self.navigationController pushViewController:[[[BFPagedBrowseViewController alloc] initWithDataSource:knownBriefs] autorelease] animated:YES];

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
