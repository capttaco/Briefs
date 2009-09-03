//
//  BriefsAppDelegate.m
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BriefsAppDelegate.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFBrowseViewController.h"
#import "BFPresentationDispatch.h"

@implementation BriefsAppDelegate

@synthesize navigationController, window;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
  [window addSubview:[self.navigationController view]];
  [window makeKeyAndVisible];
}


- (void)dealloc 
{
  [navigationController release];
	[window release];
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)nav willShowViewController:(UIViewController *)view 
                    animated:(BOOL)animated
{
  if ([view isKindOfClass:[BFSceneViewController class]]) {
    [[nav navigationBar] setBarStyle:UIBarStyleBlack];
    [[nav navigationBar] setTranslucent:YES];
    [nav setNavigationBarHidden:YES animated:animated];
  } 
  else {
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [[nav navigationBar] setBarStyle:UIBarStyleDefault];
    [[nav navigationBar] setTranslucent:NO];
    [[nav navigationBar].backItem setTitle:@"My Briefs"];
  }
}

- (void)navigationController:(UINavigationController *)nav didShowViewController:(UIViewController *)view 
                    animated:(BOOL)animated
{
  if ([view isKindOfClass:[BFSceneViewController class]]) {
    [[nav navigationBar].backItem setTitle:@"Exit"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
  }
}

///////////////////////////////////////////////////////////////////////////////


@end
