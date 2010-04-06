//
//  BFColor.m
//  Briefs
//
//  Created by Rob Rhyne on 1/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFColor.h"


@implementation BFColor

+ (UIColor *)tintColorForNavigationBar
{
    return [UIColor colorWithRed:0.5098f green:0.5412f blue:0.6f alpha:1.0f];
//    return [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
}

+ (UIColor *)tintColorForNavigationButton
{
    return [UIColor colorWithRed:0.5098f green:0.5412f blue:0.6f alpha:1.0f];
}

+ (UIColor *)backgroundForTableView
{
    return [UIColor colorWithRed:0.8667f green:0.8784f blue:0.8902f alpha:1.0f];
}

@end
