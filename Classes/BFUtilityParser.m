//
//  BFUtilityParser.m
//  Briefs
//
//  Created by Rob Rhyne on 8/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//


#import "BFUtilityParser.h"
#import "BFConstants.h"


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
  
  NSRange start = [lowered rangeOfString:@"("];
  NSRange end = [lowered rangeOfString:@")"];
  
  NSString *argumentsAsString = [[lowered substringToIndex:end.location] substringFromIndex:start.location+1];
  NSArray *argumentsAsArray = [argumentsAsString componentsSeparatedByString:@","];
  
  return argumentsAsArray;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scene Transition Parse Methods

+ (NSString *)parseSceneTransitionCommand:(NSString *)transition
{
  // TODO: Do something here.
  return nil;
}

+ (NSArray  *)parseSceneTransitionOptionsIntoArray:(NSString *)transition withPrefix:(NSString *)prefix
{
  // TODO: Do something here.
  return nil;
}

///////////////////////////////////////////////////////////////////////////////



@end
