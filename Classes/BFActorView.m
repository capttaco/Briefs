//
//  BFActorView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActorView.h"
#import "BFPresentationDispatch.h"
#import "BFUtilityParser.h"


@implementation BFActorView

@synthesize actor;

- (id) initWithActor:(BFActor *)source 
{
	NSString *pathToImage = [[NSBundle mainBundle] pathForResource:[source background] ofType:nil];
	if (self = [super initWithImage:[UIImage imageWithContentsOfFile:pathToImage]]) {
		// enable user interaction, per documentation
		[self setUserInteractionEnabled:YES];
		
		// initialize the view
		self.frame = [source size];
		self.actor = source;
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
	
	// multiple taps are forwareded
	if (numTaps > 1) {
		[self.nextResponder touchesBegan:touches withEvent:event];
	
	// single tap launches the actor's action
	} else {
		// FIXME: stubbed, look at Actor action and do that instead
		[self executeAction:[self.actor action]];
	}
}

- (void)executeAction:(NSString *)action
{
  NSString *typeOfAction = [BFUtilityParser parseActionCommand:action];
  NSArray *actionArguments = [BFUtilityParser parseActionArgsIntoArray:action withPrefix:typeOfAction];
  
  if (typeOfAction == kBFACTOR_GOTO_ACTION) {

    // GOTO action contains one argument: the index of the scene to goto
    //   scene is not zero-based, so convert.
    
    NSString *arg1 = [actionArguments objectAtIndex:0];
    [[BFPresentationDispatch sharedBFPresentationDispatch] gotoScene:[arg1 intValue]-1];
  }
  
  else if (typeOfAction == kBFACTOR_MOVE_ACTION) {
    // TODO: execute move action
  }
}


@end
