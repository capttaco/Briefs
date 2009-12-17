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


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView Event Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self cancelGestureTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.8f 
                                             target:self
                                           selector:@selector(handleTapHoldGesture)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // check to see how much the touches moved
    UITouch *touch = (UITouch *) [touches anyObject];
    CGPoint now = [touch locationInView:self];
    CGPoint then = [touch previousLocationInView:self];
    
    if (abs(now.x - then.x) > 5.0f || abs(now.y - then.y) > 5.0f) {
        [self cancelGestureTimer];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self cancelGestureTimer];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Exiting a Brief

- (void)handleTapHoldGesture 
{
    if (timer != nil) {
        [self cancelGestureTimer];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to close the Brief?" 
                                                           delegate:self
                                                  cancelButtonTitle:@"Nevermind"
                                             destructiveButtonTitle:@"Stop the Brief" 
                                                  otherButtonTitles:nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self];
        

    }
}

- (void)cancelGestureTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;    
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [[viewController navigationController] popViewControllerAnimated:YES];
}


///////////////////////////////////////////////////////////////////////////////

@end
