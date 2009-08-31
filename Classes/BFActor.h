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
	
	NSString	*bg;
	NSString	*name;
	CGRect		size;
	NSString	*action;
	bool			isActive;
	
	// Optional behavior states
	NSString *touchedBg;
	NSString *releasedBg;
	NSString *disabledBg;
	
}

@property (nonatomic, retain)	NSString	*bg;
@property (nonatomic, retain)	NSString	*name;
@property (nonatomic)					CGRect		size;
@property (nonatomic, retain)	NSString	*action;

@property (nonatomic, retain)	NSString *touchedBg;
@property (nonatomic, retain) NSString *releasedBg;
@property (nonatomic, retain) NSString *disabledBg;


// initialization
- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict;

// state management
- (void) activate;
- (void) deactivate;
- (NSString *) background;

// Actions
+ (NSArray *)copyOfAvailableActions;



@end

