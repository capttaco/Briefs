//
//  BFUtilityParser.h
//  Briefs
//
//  Created by Rob Rhyne on 8/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>

@interface BFUtilityParser : NSObject {}

// Actor Actions
+ (NSString *)parseActionCommand:(NSString *)action;
+ (NSArray  *)parseActionArgsIntoArray:(NSString *)action withPrefix:(NSString *)prefix;

// Scene Transitions
+ (NSString *)parseSceneTransitionCommand:(NSString *)transition;
+ (NSArray  *)parseSceneTransitionOptionsIntoArray:(NSString *)transition withPrefix:(NSString *)prefix;

@end
