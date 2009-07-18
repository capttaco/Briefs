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

@implementation BriefsAppDelegate

@synthesize window, sceneController, dataManager;


- (void) applicationDidFinishLaunching:(UIApplication *)application 
{	
	NSString *pathToDictionary = [[NSBundle mainBundle] pathForResource:@"sample-brief" ofType:@"plist"];
	BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
	self.dataManager = manager;
	
	BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:self.dataManager];
	self.sceneController = controller;
	
	[manager release];
	[controller release];
	
	[window addSubview:sceneController.imageView];
	[window makeKeyAndVisible];
}


- (void) dealloc 
{
	[sceneController release];
	[window release];
	[super dealloc];
}


@end
