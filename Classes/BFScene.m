//
//  BFScene.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFScene.h"
#import "BFActor.h"


@implementation BFScene

@synthesize bg, actors, name;

- (id)init:(NSString*)nameOfScene withDictionary:(NSDictionary*)dict
{
	if (self = [super init]) {
		//NSString *path = [dict valueForKey:@"img"];
		//NSString *pathToImage = [[NSBundle mainBundle] pathForResource:path ofType:nil];
		
		//UIImage *image = [UIImage imageWithContentsOfFile:pathToImage];
		//self.bg = image;
		self.bg = [dict valueForKey:@"img"];
		self.name = nameOfScene;
		
		// Load actors
		NSArray *actor_dicts = [dict valueForKey:@"actors"];
		NSMutableArray *actors_tree = [NSMutableArray arrayWithCapacity:[actor_dicts count]];
		for (NSDictionary *dictionary in actor_dicts) {
			[actors_tree addObject:[[BFActor alloc] init:[dictionary valueForKey:@"name"] withDictionary:dictionary]];
		}
		self.actors = actors_tree;
		
	}
  return self;	
}

- (void)dealloc 
{
	[name release];
	[actors release];
	[bg release];
	[super dealloc];
}

@end
