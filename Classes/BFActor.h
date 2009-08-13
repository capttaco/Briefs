//
//  BFActor.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFActor : NSObject 
{
	
	UIImage		*bg;
	NSString	*name;
	CGRect		size;
	NSString	*action;
	
	// Optional behavior states
	UIImage *touchedBg;
	UIImage *releasedBg;
	UIImage *disabledBg;
	
}

@property (nonatomic, retain)		UIImage		*bg;
@property (nonatomic, readonly) NSString	*name;
@property (nonatomic, readonly) CGRect		size;
@property (nonatomic, retain)		NSString	*action;

@property (nonatomic, retain)	UIImage *touchedBg;
@property (nonatomic, retain) UIImage *releasedBg;
@property (nonatomic, retain) UIImage *disabledBg;


+ (NSArray *)availableActions;

// initialization
- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict;


@end

