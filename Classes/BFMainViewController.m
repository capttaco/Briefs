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
#import "BFColor.h"

#import "BFLoadingViewController.h"

@interface BFMainViewController (PrivateMethods)

- (void)hideMenuWithAnimation;
- (void)showMenuWithAnimation;

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

- (void)viewWillAppear:(BOOL)animated
{
    switch (stateUponLaunch) {
        case BFMainViewOpenedByURL:
            
            if ([[urlLaunchWith scheme] isEqualToString:@"brief"]) {
                NSString *modifiedRequestString = [[urlLaunchWith absoluteString] stringByReplacingOccurrencesOfString:@"brief://" withString:@"http://"]; 
                BFLoadingViewController *loading = [[BFLoadingViewController alloc] init];
                [loading view].frame = CGRectOffset([loading view].frame, 40, 30);
                [self.view addSubview:[loading view]];
                
                [loading load:modifiedRequestString withInitialStatus:@"Locating the Brief..." animated:YES];
            }
            
            else if ([[urlLaunchWith scheme] isEqualToString:@"briefcast"]) {
                NSString *modifiedRequestString = [[urlLaunchWith absoluteString] stringByReplacingOccurrencesOfString:@"briefcast://" withString:@"http://"];                
                BFBriefcastViewController *viewer = [[BFBriefcastViewController alloc] initWithNibName:@"BFBriefcastViewController" bundle:nil];
                viewer.locationOfBriefcast = modifiedRequestString;
                
                // launch briefcast view
                [self.navigationController pushViewController:viewer animated:YES];
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
#pragma mark Main Menu Actions

- (void)hideMenuWithAnimation
{
    // push down the menu view
    [UIView beginAnimations:@"MenuSlideDownTransition" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 480.0f, size.width, size.height);
    
    [UIView commitAnimations];
}

- (void)showMenuWithAnimation 
{
    // push up the menu view
    [UIView beginAnimations:@"MenuSlideUpTransition" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.3f];
    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 280.0f, size.width, size.height);
    
    [UIView commitAnimations];
}

- (IBAction)browseYourBriefs
{
    [self hideMenuWithAnimation];
    [self.navigationController pushViewController:[[BFBrowseViewController alloc] init] animated:YES];
}

- (IBAction)browseYourBriefcasts
{
    [self hideMenuWithAnimation];
    [self.navigationController pushViewController:[[BFBrowseBriefcastsViewController alloc] init] animated:YES];
}

///////////////////////////////////////////////////////////////////////////////

@end
