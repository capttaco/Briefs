//
//  BFUtilityParser.m
//  Briefs
//
//  Created by Rob Rhyne on 8/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//


#import "BFUtilityParser.h"


@implementation BFUtilityParser


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Parse Methods

+ (NSString *)parseActionCommand:(NSString *)action
{
  NSString *lowered = [action lowercaseString];
  
  if ([lowered hasPrefix:kBFACTOR_GOTO_ACTION]) {
    return kBFACTOR_GOTO_ACTION;
    
  } else if ([lowered hasPrefix:kBFACTOR_TOGGLE_ACTION]) {
    return kBFACTOR_TOGGLE_ACTION;
    
  } else if ([lowered hasPrefix:kBFACTOR_RESIZE_ACTION]) {
    return kBFACTOR_RESIZE_ACTION;
    
  } else if ([lowered hasPrefix:kBFACTOR_MOVE_ACTION]) {
    return kBFACTOR_MOVE_ACTION;
  }
  
  // TODO: throw exception?
  return nil;
}

+ (NSArray *)parseActionArgsIntoArray:(NSString *)action withPrefix:(NSString *)prefix
{
  NSString *lowered = [action lowercaseString]; 
}

///////////////////////////////////////////////////////////////////////////////

@end
