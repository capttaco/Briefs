//
//  BFDispatch.h
//  Briefs
//
//  Created by Rob Rhyne on 8/9/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//


@protocol BFLocalActionDispatch

// Acts upon Scenes
- (void)gotoScene:(int)indexOfScene;
- (void)gotoScene:(int)indexOfScene usingTransition:(NSString *)transition;

// Acts upon Actors
- (void)toggleActor:(int)indexOfActor;
- (void)resize:(int)indexOfActor withSize:(CGSize)size;
- (void)move:(int)indexOfActor toPoint:(CGPoint)point;
- (void)show:(int)indexOfActor;
- (void)hide:(int)indexOfActor;

@end 

@protocol BFGlobalActionDispatch

- (void)toggleKeyboard:(NSString *)type;

@end


