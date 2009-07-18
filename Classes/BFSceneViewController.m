//
//  SceneViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFSceneViewController.h"


@implementation BFSceneViewController

@synthesize dataManager;

- (id) initWithSceneManager:(BFSceneManager*)manager
{
	if (self = [super init]) {
		self.dataManager = manager;
		UIImageView *image_view = [[UIImageView alloc] initWithImage:[[self.dataManager openingScene] bg]];
		self.view = image_view;
		
		[image_view release];
	}
	return self;
}

// TODO do stuff after view is loaded.
- (void)loadView 
{
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[self.view release];
	[dataManager release];
	[super dealloc];
}


@end
