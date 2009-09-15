//
//  FPLink.m
//  FeedParser
//
//  Created by Kevin Ballard on 4/10/09.
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

#import "FPLink.h"
#import "NSString_extensions.h"

@implementation FPLink
@synthesize href, rel, type, title;
+ (id)linkWithHref:(NSString *)href rel:(NSString *)rel type:(NSString *)type title:(NSString *)title {
	return [[[self alloc] initWithHref:href rel:rel type:type title:title] autorelease];
}

- (id)initWithHref:(NSString *)inHref rel:(NSString *)inRel type:(NSString *)inType title:(NSString *)inTitle {
	if (self = [super init]) {
		href = [inHref copy];
		rel = (inRel ? [inRel copy] : @"alternate");
		type = [inType copy];
		title = [inTitle copy];
	}
	return self;
}

- (BOOL)isEqual:(id)anObject {
	if (![anObject isKindOfClass:[FPLink class]]) return NO;
	FPLink *other = (FPLink *)anObject;
	return ((href  == other.href  || [href  isEqualToString:other.href]) &&
			(rel   == other.rel   || [rel   isEqualToString:other.rel])  &&
			(type  == other.type  || [type  isEqualToString:other.type]) &&
			(title == other.title || [title isEqualToString:other.title]));
}

- (NSString *)description {
	NSMutableArray *attributes = [NSMutableArray array];
	for (NSString *key in [NSArray arrayWithObjects:@"rel", @"type", @"title", nil]) {
		NSString *value = [self valueForKey:key];
		if (value != nil) {
			[attributes addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, [value fpEscapedString]]];
		}
	}
	return [NSString stringWithFormat:@"<%@: %@ (%@)>", NSStringFromClass([self class]), self.href, [attributes componentsJoinedByString:@" "]];
}

- (void)dealloc {
	[href release];
	[rel release];
	[type release];
	[title release];
	[super dealloc];
}

@end
