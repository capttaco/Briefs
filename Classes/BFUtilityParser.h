//
//  BFUtilityParser.h
//  Briefs
//
//  Created by Rob Rhyne on 8/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


#define	kBFACTOR_GOTO_ACTION    @"goto"
#define	kBFACTOR_TOGGLE_ACTION  @"toggle"
#define	kBFACTOR_RESIZE_ACTION  @"resize"
#define	kBFACTOR_MOVE_ACTION    @"move"


@interface BFUtilityParser : NSObject {}

+ (NSString *)parseActionCommand:(NSString *)action;
+ (NSArray  *)parseActionArgsIntoArray:(NSString *)action withPrefix:(NSString *)prefix;

@end
