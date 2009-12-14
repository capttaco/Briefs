//
//  BFRootView.h
//  Briefs
//
//  Created by Rob Rhyne on 8/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface BFRootView : UIView <UIActionSheetDelegate>
{
    UIViewController    *viewController;
    NSTimer             *timer;
}

- (id)initWithFrame:(CGRect)frame andViewController:(UIViewController *)controller;
- (void)handleTapHoldGesture;
- (void)cancelGestureTimer;


@end
