//
//  BriefsAppDelegate.m
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. All rights reserved.
//

#import "BriefsAppDelegate.h"

@implementation BriefsAppDelegate

@synthesize window;


- (void) applicationDidFinishLaunching:(UIApplication *)application 
{    
	// Override point for customization after application launch
	[window makeKeyAndVisible];
	
	NSString *pathToDictionary = [[NSBundle mainBundle] pathForResource:@"sample-brief" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: pathToDictionary];
	NSLog(@"Is the dictionary getting loaded? %@", dict);
	NSArray *scene_graph = [dict valueForKey:@"scenes"];
	
	NSString *path = [[scene_graph objectAtIndex:0] valueForKey:@"img"];
	NSString *pathToImage = [[NSBundle mainBundle] pathForResource:path ofType:nil];
	NSLog(@"The path I got from the plist was: %@", pathToImage);
	
	UIImage *image = [UIImage imageWithContentsOfFile:pathToImage];
	UIImageView *view = [[UIImageView alloc] initWithImage:image];
	
	[window addSubview:view];
	[window makeKeyAndVisible];
}


- (void) dealloc 
{
	[window release];
	[super dealloc];
}


@end
