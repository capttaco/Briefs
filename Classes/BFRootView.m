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
        self.backgroundColor = [UIColor blackColor];

    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    
    if (numTaps > 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to close the Brief?" 
                                                           delegate:self
                                                  cancelButtonTitle:@"Nevermind"
                                             destructiveButtonTitle:@"Stop the Brief" 
                                                  otherButtonTitles:nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self];
            
    } 
    
    else {
        // single taps are forwareded
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [[viewController navigationController] popViewControllerAnimated:YES];
}

@end
