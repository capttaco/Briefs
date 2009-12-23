//
//  BFPresentationController.m
//  Briefs
//
//  Created by Rob Rhyne on 8/4/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFPresentationDispatch.h"
#import "SynthesizeSingleton.h"

@implementation BFPresentationDispatch

@synthesize viewController;

SYNTHESIZE_SINGLETON_FOR_CLASS(BFPresentationDispatch);


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Singleton Accessor Methods

+ (id<BFLocalActionDispatch>)sharedLocalDispatch
{
    return (id<BFLocalActionDispatch>) [BFPresentationDispatch sharedBFPresentationDispatch];
}

+ (id<BFGlobalActionDispatch>)sharedGlobalDispatch
{
    return (id<BFGlobalActionDispatch>) [BFPresentationDispatch sharedBFPresentationDispatch];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Local Dispatch Methods

- (void)gotoScene:(int)indexOfScene
{
    if (self.viewController != nil) {
        if ([self.viewController willLoadSceneWithIndex:indexOfScene] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because the scene did not load!");
        else {
            NSLog(@"Scene %d was just loaded", indexOfScene);
        }
    }
}

- (void)gotoScene:(int)indexOfScene usingTransition:(NSString *)transition
{
    if (self.viewController != nil) {
        if ([self.viewController willLoadSceneWithIndex:indexOfScene usingTransition:transition] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because the scene did not load!");
        else {
            NSLog(@"Scene %d was just loaded using the transition %@", indexOfScene, transition);
        }
    }
}

- (void)toggleActor:(int)indexOfActor
{ 
    if (self.viewController != nil) {
        if ([self.viewController willToggleActorWithIndex:indexOfActor] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because the actor was not toggled!");
        else {
            NSLog(@"Actor %d was just toggled", indexOfActor);
        }
    }
}

- (void)show:(int)indexOfActor
{
    if (self.viewController != nil) {
        if ([self.viewController willShowActorWithIndex:indexOfActor] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because the actor was not shown!");
        else {
            NSLog(@"Actor %d is now showing.", indexOfActor);
        }
    }
}

- (void)hide:(int)indexOfActor
{
    if (self.viewController != nil) {
        if ([self.viewController willHideActorWithIndex:indexOfActor] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because the actor was not hidden!");
        else {
            NSLog(@"Actor %d was just hidden", indexOfActor);
        }
    }
}


- (void)resize:(int)indexOfActor withSize:(CGSize)size
{
    if (self.viewController != nil) {
        if ([self.viewController willResizeActorWithIndex:indexOfActor toSize:size] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because I was not able to resize the actor!");
        else {
            NSLog(@"Resized Actor %d, to the size %@", indexOfActor, NSStringFromCGSize(size));
        }
    }
}

- (void)move:(int)indexOfActor toPoint:(CGPoint)point
{
    if (self.viewController != nil) {
        if ([self.viewController willMoveActorWithIndex:indexOfActor toPoint:point] == false)
            // TODO: throw exception
            NSLog(@"Throw an exception, because I was not able to move the actor");
        else {
            NSLog(@"Moved Actor %d, to the point %@", indexOfActor, NSStringFromCGPoint(point));
        }
    }
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Global Dispatch Methods

- (void)toggleKeyboard:(NSString *)type {
    // TODO: toggle keyboard in current view
}

///////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [super dealloc];
}

@end
