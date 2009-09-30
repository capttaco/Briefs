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
    id          bg;
    NSString    *name;
    CGRect      size;
    NSString    *action;
    bool        isActive;
    
    // Optional behavior states
    id touchedBg;
    id releasedBg;
    id disabledBg;   
}

@property (nonatomic, retain)   id          bg;
@property (nonatomic, retain)   NSString    *name;
@property (nonatomic)           CGRect      size;
@property (nonatomic, retain)   NSString    *action;

@property (nonatomic, retain)   id touchedBg;
@property (nonatomic, retain)   id releasedBg;
@property (nonatomic, retain)   id disabledBg;


// initialization
- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict;
- (NSDictionary *)copyAsDictionary;

// state management
- (void) activate;
- (void) deactivate;
- (NSString *) background;

// Actions
+ (NSArray *)copyOfAvailableActions;

@end

