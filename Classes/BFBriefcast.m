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

- (id)initWithDictionary:(NSDictionary *)dict
{
  self = [self initWithName:[dict valueForKey:@"title"] andURL:[dict valueForKey:@"url"]];
  if (self != nil) {
    self.description = [dict valueForKey:@"description"];
  }
  return self;
}

- (NSDictionary *)dictionary
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.title, @"title", 
          self.url, @"url",
          self.description, @"description", 
          nil];
}

- (void)dealloc
{
  [title release];
  [url release];
  [description release];
  [super dealloc];
}

@end
