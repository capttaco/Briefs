//
//  BFActor.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActor.h"



@implementation BFActor

@synthesize bg, name, size, action, touchedBg, disabledBg, releasedBg;

+ (NSArray *)availableActions {
	// TODO: return available actions (as NSStrings) for actors
	return nil;
}


- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict
{
	// TODO: do something interesting with actors
	if (self = [super init]) {
	
	}
	return self;
}

- (void)dealloc 
{
	[bg release];
	[name release];
	[super dealloc];
}
@end
