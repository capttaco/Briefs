//
//  BFConfig.m
//  Briefs
//
//  Created by Rob Rhyne on 1/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFConfig.h"


@implementation BFConfig

+ (UIColor *)tintColorForNavigationBar
{
    return [UIColor colorWithHue:0.58889 saturation:0.10f brightness:0.56f alpha:0.1];
}

+ (UIColor *)tintColorForNavigationButton
{
    return [UIColor colorWithRed:0.5098f green:0.5412f blue:0.6f alpha:1.0f];
}

+ (UIColor *)backgroundForTableView
{
    return [UIColor colorWithRed:0.8667f green:0.8784f blue:0.8902f alpha:1.0f];
}

+ (UIColor *)separatorColorForTableView
{
    return [UIColor colorWithHue:0.58333f saturation:0.19f brightness:0.12f alpha:1.0f];
}


+ (NSString *)shortDateStringFromDate:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)shortTimeStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [[dateFormatter stringFromDate:date] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
