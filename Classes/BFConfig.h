//
//  BFConfig.h
//  Briefs
//
//  Created by Rob Rhyne on 1/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFConfig : NSObject {}

// tint colors
+ (UIColor *)tintColorForNavigationBar;
+ (UIColor *)tintColorForNavigationButton;

// table colors
+ (UIColor *)backgroundForTableView;
+ (UIColor *)separatorColorForTableView;

// dates
+ (NSString *)shortDateStringFromDate:(NSDate *)date;
+ (NSString *)shortTimeStringFromDate:(NSDate *)date;

@end
