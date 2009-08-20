//
//  BFActorView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActorView.h"
#import "BFPresentationDispatch.h"


@implementation BFActorView

@synthesize actor;

- (id) initWithActor:(BFActor *)source 
{
	if (self = [super initWithImage:[source background]]) {
		// enable user interaction, per documentation
		[self setUserInteractionEnabled:YES];
		
		// initialize the view
		self.frame = [source size];
	}

	return self;
}

- (void) dealloc {
	[actor release];
	[super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];
	if (numTaps > 1) {
		[self.nextResponder touchesBegan:touches withEvent:event];
	} else {
		// FIXME: stubbed, look at Actor action and do that instead
		[[BFPresentationDispatch sharedBFPresentationDispatch] gotoScene:1];
	}
}

@end
