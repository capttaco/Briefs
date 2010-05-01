//
//  BFRootView+TapHoldGesture.h
//  Briefs
//
//  Created by Rob Rhyne on 2/28/10.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFRootView.h"

@interface BFRootView (TapHoldGesture) <UIActionSheetDelegate>

- (void)handleTapHoldGesture;
- (void)cancelGestureTimer;

@end
