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
	bool			isActive;
	
	// Optional behavior states
	UIImage *touchedBg;
	UIImage *releasedBg;
	UIImage *disabledBg;
	
}

@property (nonatomic, retain)	UIImage		*bg;
@property (nonatomic, retain)	NSString	*name;
@property (nonatomic)					CGRect		size;
@property (nonatomic, retain)	NSString	*action;

@property (nonatomic, retain)	UIImage *touchedBg;
@property (nonatomic, retain) UIImage *releasedBg;
@property (nonatomic, retain) UIImage *disabledBg;


// initialization
- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict;

// state management
- (void) activate;
- (void) deactivate;
- (UIImage *) background;

// Actions
+ (NSArray *)availableActions;



@end

