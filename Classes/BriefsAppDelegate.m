//
//  BriefsAppDelegate.m
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BriefsAppDelegate.h"

@implementation BriefsAppDelegate

@synthesize window;


- (void) applicationDidFinishLaunching:(UIApplication *)application 
{    
	NSString *pathToDictionary = [[NSBundle mainBundle] pathForResource:@"sample-brief" ofType:@"plist"];
	BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
	BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
	self.sceneController = controller;
	
	//NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: pathToDictionary];
	//NSLog(@"Is the dictionary getting loaded? %@", dict);
	//NSArray *scene_graph = [dict valueForKey:@"scenes"];
	
	//NSString *path = [[scene_graph objectAtIndex:0] valueForKey:@"img"];
	//NSString *pathToImage = [[NSBundle mainBundle] pathForResource:path ofType:nil];
	//NSLog(@"The path I got from the plist was: %@", pathToImage);
	
	//UIImage *image = [UIImage imageWithContentsOfFile:pathToImage];
	//UIImageView *view = [[UIImageView alloc] initWithImage:image];
	
	[manager release];
	[controller release];
	
	[window addSubview:view];
	[window makeKeyAndVisible];
}


- (void) dealloc 
{
	[window release];
	[super dealloc];
}


@end
