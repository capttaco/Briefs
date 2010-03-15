//
//  BriefsAppDelegate.m
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BriefsAppDelegate.h"
#import "BFSceneViewController.h"
#import "BFMainViewController.h"
#import "BFDataManager.h"

@implementation BriefsAppDelegate

@synthesize navigationController, window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [[BFDataManager sharedBFDataManager] load];
    
    BFMainViewController *controller = [BFMainViewController alloc];
    if (launchOptions) {
        NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        controller = [controller initWithState:BFMainViewOpenedByURL];
    }
    
    else {
        // no url sent, going to default for now
        // TODO: Need to flesh out rest of the launch states.
        controller = [controller initWithState:BFMainViewDefaultState];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.delegate = self;
    [window addSubview:[self.navigationController view]];
    [window makeKeyAndVisible];
    [controller release];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[BFDataManager sharedBFDataManager] save];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
//{
//    if ([[url scheme] isEqualToString:@"brief"]) {
//        NSLog(@"Received the following URL for a brief: %@", url);
//        
//        
//        
//        return YES;
//    }
//    else if ([[url scheme] isEqualToString:@"brieflist"]) {
//        NSLog(@"Received the following URL for a briefcast: %@", url);
//        return YES;
//    }
//    return NO;
//}

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
        [nav setNavigationBarHidden:YES animated:YES];
    } 
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [nav setNavigationBarHidden:NO animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)nav didShowViewController:(UIViewController *)view 
                    animated:(BOOL)animated
{
    if ([view isKindOfClass:[BFSceneViewController class]]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////

@end
