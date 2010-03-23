//
//  BFPagedContainerView.m
//  Briefs
//
//  Created by Rob Rhyne on 3/21/10.
//  Copyright 2010 Digital Arch Design. All rights reserved.
//

#import "BFPagedContainerView.h"


@implementation BFPagedContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
    if ([self pointInside:point withEvent:event]) {
        return scrollView;
    }
    return nil;
}

@end
