//
//  BFSceneView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BFSceneView.h"


@implementation BFSceneView
@synthesize scene;

- (id)initWithScene:(BFScene *)source
{
	self.scene = source;
	if (self = [super initWithImage:[self.scene bg]]) {
		// enable user interaction, per documentation
		self.userInteractionEnabled = YES;
		
		// initialize the view
		self.bounds = CGRectMake(0, 0, [[self.scene bg] size].width, [[self.scene bg] size].height);
	}
	return self;
}

- (void)dealloc 
{
	[scene release];
	[super dealloc];
}


@end
