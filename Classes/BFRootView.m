//
//  BFRootView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFRootView.h"


@implementation BFRootView

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject life-cycle

- (id)initWithFrame:(CGRect)frame andViewController:(UIViewController *)controller
{
    if (self = [super initWithFrame:frame]) {
        // enable user interaction, per documentation
        [self setUserInteractionEnabled:YES];
        viewController = controller;
        self.backgroundColor = [UIColor blackColor];
        timer = nil;

    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)cancelGestureTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;    
    }
}

///////////////////////////////////////////////////////////////////////////////

@end
