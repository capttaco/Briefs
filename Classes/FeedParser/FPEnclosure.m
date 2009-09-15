//
//  FPEncslosure.m
//  mobdub
//
//  Created by Patrick O'Shaughnessey on 8/24/09.
//  Copyright 2009 Patched Reality. All rights reserved.
//

#import "FPEnclosure.h"
#import "NSString_extensions.h"


@implementation FPEnclosure
@synthesize url, type, length;

+ (id)enclosureWithURL:(NSString *)url type:(NSString *)type length:(NSNumber *)length {
	return [[[self alloc] initWithURL:url type:type length:length] autorelease];
}

- (id)initWithURL:(NSString *)inURL type:(NSString *)inType length:(NSNumber *)inLength {
	if (self = [super init]) {
		url = [inURL copy];
		type = [inType copy];
		length = [inLength copy];
	}
	return self;
}
- (BOOL)isEqual:(id)anObject {
	if (![anObject isKindOfClass:[FPEnclosure class]]) return NO;
	FPEnclosure *other = (FPEnclosure *)anObject;
	return ((url   == other.url  ||  [url  isEqualToString:other.url]) &&
			(type  == other.type  || [type  isEqualToString:other.type]) &&
			(length == other.length) || [length isEqualToNumber:other.length]);
}

- (NSString *)description {
	NSMutableArray *attributes = [NSMutableArray array];
	for (NSString *key in [NSArray arrayWithObjects:@"url", @"type", @"length", nil]) {
		NSString *value = [self valueForKey:key];
		if (value != nil) {
			[attributes addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, [value fpEscapedString]]];
		}
	}
	return [NSString stringWithFormat:@"<%@: %@ (%@)>", NSStringFromClass([self class]), self.url, [attributes componentsJoinedByString:@" "]];
}

- (void)dealloc {
	[url release];
	[type release];
	[length release];
	[super dealloc];
}
@end