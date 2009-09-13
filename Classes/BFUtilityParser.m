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
#pragma mark General Parsing Methods

+ (UIImage *)parseImageFromRepresentation:(id)representation
{
  UIImage *image;
  
  // U N C O M P A C T E D
  // Image is specified as a path to a local file
  if ([representation isKindOfClass:[NSString class]]) {    
    NSString *pathToImage = [[NSBundle mainBundle] pathForResource:representation ofType:nil];
    image = [UIImage imageWithContentsOfFile:pathToImage];
  }
  
  // C O M P A C T E D
  // Image is specified as an embedded data blob
  else {
    NSData *imageData = representation;
    image = [UIImage imageWithData:imageData];
  }
  
  return image;
}

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

@end
