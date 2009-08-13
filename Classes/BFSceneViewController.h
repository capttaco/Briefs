//
//  SceneViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFSceneManager.h"

@interface BFSceneViewController : UIViewController 
{
	BFSceneManager	*dataManager;
}

@property (nonatomic, retain) BFSceneManager	*dataManager;

- (id) initWithSceneManager:(BFSceneManager*)manager;

// Local Dispatch Methods
- (BOOL) willLoadSceneWithIndex:(int)index;
- (BOOL) willToggleActorWithIndex:(int)index;
- (BOOL) willResizeActorWithIndex:(int)index toSize:(CGRect)size;
- (BOOL) willMoveActorWithIndex:(int)index toPoint:(CGPoint)point;

// Global Dispatch Methods
- (BOOL) willShowKeyboard:(NSString *)type;

@end
