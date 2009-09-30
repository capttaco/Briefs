//
//  BFRootView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFRootView.h"


@implementation BFRootView


- (id)initWithFrame:(CGRect)frame andViewController:(UIViewController *)controller
{
    if (self = [super initWithFrame:frame]) {
        // enable user interaction, per documentation
        [self setUserInteractionEnabled:YES];
        viewController = controller;

    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    
    if (numTaps > 1) {
        // show navigation controller
        if ([viewController navigationController].navigationBarHidden == YES) {
            [[viewController navigationController] setNavigationBarHidden:NO animated:YES];
        }
        else {
            [[viewController navigationController] setNavigationBarHidden:YES animated:YES];
        }
            
    } 
    
    else {
        // single taps are forwareded
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

@end
