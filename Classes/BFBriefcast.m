//
//  BFBriefcast.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcast.h"


@implementation BFBriefcast

@synthesize url, title, description;

- (id)initWithName:(NSString *)name andURL:(NSString *)address
{
  self = [super init];
  if (self != nil) {
    self.title = name;
    self.url = address;
  }
  return self;
}

@end
