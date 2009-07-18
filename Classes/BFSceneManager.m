//
//  BFSceneManager.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFSceneManager.h"



@implementation BFSceneManager

@synthesize source, scene_graph, scene_desc;

- (id) initWithPathToDictionary:(NSString*)path
{
	self = [super init];
	
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	NSLog(@"Is the dictionary getting loaded? %@", dict);
	NSArray *scenes = [dict valueForKey:@"scenes"];
	
	self.source = dict;
	self.scene_desc = scenes;
	
	// TODO: Figure out how scenes will be loaded.
	self.scene_graph = [NSMutableArray arrayWithCapacity:[scene_desc count]];
	
	[dict release];
	[scenes release];
	
	return self;
}


/** Scene Management */
- (int) totalNumberOfScenes 
{
	return [self.scene_desc count];
}

- (BFScene*) openingScene
{
	if ([self.scene_graph count] <= 0 || [self.scene_graph objectAtIndex:0] == nil) {
		NSDictionary *dict = [self.scene_desc objectAtIndex:0];
		BFScene *openingScene = [[BFScene alloc] init:@"Scene 1" withDictionary:dict];
		[self.scene_graph insertObject:openingScene atIndex:0];
		return [self.scene_graph objectAtIndex:0];
	}
	else return nil;
}

- (BFScene*) sceneByNumber:(int)index
{
	// TODO: implement getting scene by number
	return nil;
}

@end
