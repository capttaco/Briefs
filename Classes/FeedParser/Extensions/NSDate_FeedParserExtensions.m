//
//  NSDate_extensions.m
//  FeedParser
//
//  Created by Kevin Ballard on 4/6/09.
//  Copyright 2009 Kevin Ballard. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "NSDate_FeedParserExtensions.h"

static NSArray *kDays;
static NSArray *kMonths;

@implementation NSObject (NSDate_FeedParserExtensions)
+ (void)load {
	kDays = [[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil];
	kMonths = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
}

#define ASSERT(cond) do { if (!(cond)) { [pool release]; return nil; } } while (0)
+ (NSDate *)dateWithRFC822:(NSString *)rfc822 {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	NSScanner *scanner = [NSScanner scannerWithString:rfc822];
	NSCharacterSet *letterSet;
	{
		NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithRange:NSMakeRange((NSUInteger)'a', 26)];
		[cs addCharactersInRange:NSMakeRange((NSUInteger)'A', 26)];
		letterSet = cs;
	}
	NSCharacterSet *digitSet = [NSCharacterSet characterSetWithRange:NSMakeRange((NSUInteger)'0', 10)];
	[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
	NSString *temp;
	if ([scanner scanCharactersFromSet:letterSet intoString:&temp]) {
		ASSERT([kDays containsObject:temp] && [scanner scanString:@"," intoString:NULL]);
	}
	ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && [temp length] >= 1 && [temp length] <= 2);
	[components setDay:[temp integerValue]];
	ASSERT([scanner scanCharactersFromSet:letterSet intoString:&temp]);
	NSUInteger month = [kMonths indexOfObject:temp];
	ASSERT(month != NSNotFound);
	[components setMonth:(month+1)];
	ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && ([temp length] == 2 || [temp length] == 4));
	// Treat 2-digit years as (1969-2000) or (2001-2068)
	NSInteger year = [temp integerValue];
	if ([temp length] == 2) {
		year += (year >= 69 ? 1900 : 2000);
	}
	[components setYear:year];
	ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && [temp length] == 2);
	[components setHour:[temp integerValue]];
	ASSERT([scanner scanString:@":" intoString:NULL]);
	ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && [temp length] == 2);
	[components setMinute:[temp integerValue]];
	if ([scanner scanString:@":" intoString:NULL]) {
		ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && [temp length] == 2);
		[components setSecond:[temp integerValue]];
	}
	NSTimeZone *tz = nil;
	if ([scanner scanCharactersFromSet:letterSet intoString:&temp]) {
		tz = [NSTimeZone timeZoneWithAbbreviation:temp];
		if (tz == nil && [temp length] == 1) {
			unichar c = [temp characterAtIndex:0];
			if (c == 'Z') {
				tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
			} else if (c >= 'A' && c < 'J') {
				// A = -1, I = -9, skip J
				tz = [NSTimeZone timeZoneForSecondsFromGMT:((-1 - (c - 'A')) * 3600)];
			} else if (c > 'J' && c <= 'M') {
				// K = -10, M = -12
				tz = [NSTimeZone timeZoneForSecondsFromGMT:((-10 - (c - 'K')) * 3600)];
			} else if (c >= 'N' && c <= 'Y') {
				// N = 1, Y = 12
				tz = [NSTimeZone timeZoneForSecondsFromGMT:((1 + (c - 'N')) * 3600)];
			}
		}
	} else if ([scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-+"] intoString:&temp]) {
		BOOL neg = [temp isEqualToString:@"-"];
		ASSERT([scanner scanCharactersFromSet:digitSet intoString:&temp] && [temp length] == 4);
		NSInteger offset = [temp integerValue];
		if (neg) offset = -offset;
		tz = [NSTimeZone timeZoneForSecondsFromGMT:offset * 3600];
	}
	ASSERT(tz != nil);
	ASSERT([scanner isAtEnd]);
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	[calendar setTimeZone:tz];
	NSDate *date = [calendar dateFromComponents:components];
	[date retain];
	[pool release];
	[date autorelease];
	return date;
}
#undef ASSERT
@end
