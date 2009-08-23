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
#import "BFPresentationDispatch.h"

@implementation BriefsAppDelegate

@synthesize window;


- (void) applicationDidFinishLaunching:(UIApplication *)application 
{	
	// setup scene view controller
	NSString *pathToDictionary = [[NSBundle mainBundle] pathForResource:@"sample-brief" ofType:@"plist"];
	BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
	BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
	
	// wire dispatch
	[[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
		
	// launch view
	[window addSubview:[[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] view]];
	[window makeKeyAndVisible];
	
	// cleanup memory
	[manager release];
	[controller release];
}


- (void) dealloc 
{
	[window release];
	[super dealloc];
}


@end
