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


- (void) applicationDidFinishLaunching:(UIApplication *)application 
{	  
  [window addSubview:[self.navigationController view]];
  [window makeKeyAndVisible];
}


- (void) dealloc 
{
  [navigationController release];
	[window release];
	[super dealloc];
}


@end
