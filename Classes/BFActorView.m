//
//  BFActorView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActorView.h"


@implementation BFActorView

@synthesize actor;

- (id) initWithActor:(BFActor *)source 
{
	if (self = [super initWithImage:[source background]]) {
		// enable user interaction, per documentation
		self.userInteractionEnabled = YES;
		
		// initialize the view
		self.bounds = [source size];
	}
	return self;
}

- (void) dealloc {
	[actor release];
	[super dealloc];
}


@end
