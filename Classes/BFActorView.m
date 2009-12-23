//
//  BFActorView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActorView.h"
#import "BFRootView.h"
#import "BFPresentationDispatch.h"
#import "BFViewUtilityParser.h"
#import "BFUtilityParser.h"
#import "BFConstants.h"


@implementation BFActorView

@synthesize actor;

- (id)initWithActor:(BFActor *)source 
{
    if (self = [super initWithImage:[BFViewUtilityParser parseImageFromRepresentation:[source background]]]) {
        // enable user interaction, per documentation
        [self setUserInteractionEnabled:YES];
        
        // initialize the view
        self.frame = [source size];
        self.actor = source;
    }

    return self;
}

- (void) dealloc 
{
    [actor release];
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    BFRootView *rootView = (BFRootView *) self.superview.superview;
    [rootView cancelGestureTimer];    

    if (self.actor.isActive == YES) {        
        [self executeAction:[self.actor action]];        
    }
}

- (void)executeAction:(NSString *)action
{
    NSString *typeOfAction = [BFUtilityParser parseActionCommand:action];
    NSArray *actionArguments = [BFUtilityParser parseActionArgsIntoArray:action withPrefix:typeOfAction];
    
    if (typeOfAction == kBFActorActionGoto) {

        // GOTO (index)
        //   action contains one argument: the index of the scene to goto
        //   scene is not zero-based, so convert.
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        
        if ([actionArguments count] <= 1) {
            [[BFPresentationDispatch sharedBFPresentationDispatch] gotoScene:[arg1 intValue]];
        }
        else {
            NSString *arg2 = [[actionArguments objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [[BFPresentationDispatch sharedBFPresentationDispatch] gotoScene:[arg1 intValue] usingTransition:arg2];
        }
    }
    
    else if (typeOfAction == kBFActorActionToggle) {
        
        // TOGGLE (index)
        //   action contains one argument: the index of the actor 
        //   is not zero-based, so convert.
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        [[BFPresentationDispatch sharedBFPresentationDispatch] toggleActor:[arg1 intValue]];
    }
    
    else if (typeOfAction == kBFActorActionHide) {
        
        // HIDE (index)
        //   action contains one argument: the index of the actor 
        //   is not zero-based, so convert.
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        [[BFPresentationDispatch sharedBFPresentationDispatch] hide:[arg1 intValue]];
    }
    
    else if (typeOfAction == kBFActorActionShow) {
        
        // SHOW (index)
        //   action contains one argument: the index of the actor 
        //   is not zero-based, so convert.
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        [[BFPresentationDispatch sharedBFPresentationDispatch] show:[arg1 intValue]];
    }
        
    else if (typeOfAction == kBFActorActionMove) {
        
        // MOVE (index, x, y) 
        //   action contains two arguments, broken over three passed arguments:
        //   actor index is not zero-based, so convert. Convert x, y into CGPoint
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        NSString *arg2 = [actionArguments objectAtIndex:1];
        NSString *arg3 = [actionArguments objectAtIndex:2];
        CGPoint arg2AsPoint = CGPointMake([arg2 floatValue], [arg3 floatValue]);
        [[BFPresentationDispatch sharedBFPresentationDispatch] move:[arg1 intValue] toPoint:arg2AsPoint];
    }
    
    else if (typeOfAction == kBFActorActionResize) {
        
        // RESIZE (index, w, h) 
        //   action contains two arguments, broken over three passed arguments:
        //   actor index is not zero-based, so convert. Convert x, y into CGPoint
        
        NSString *arg1 = [actionArguments objectAtIndex:0];
        NSString *arg2 = [actionArguments objectAtIndex:1];
        NSString *arg3 = [actionArguments objectAtIndex:2];
        CGSize arg2AsSize = CGSizeMake([arg2 floatValue], [arg3 floatValue]);
        [[BFPresentationDispatch sharedBFPresentationDispatch] resize:[arg1 intValue] withSize:arg2AsSize];
    }
    
}


@end
