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

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithPathToDictionary:(NSString*)path
{
	if (self = [super init]) {
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
		NSLog(@"Is the dictionary getting loaded? %@", dict);
		NSArray *scenes = [dict valueForKey:@"scenes"];
		
		self.source = dict;
		self.scene_desc = scenes;
		currentIndex = 0;
		
		[dict release];
		[scenes release];
		
		// TODO: Figure out how scenes will be loaded.
		self.scene_graph = [NSMutableArray arrayWithCapacity:[scene_desc count]];
		int index = 0;
		for (NSDictionary *dictionary in self.scene_desc) {
			BFScene *scene = [[BFScene alloc] init:[dictionary valueForKey:@"name"] withDictionary:dictionary];
			[self.scene_graph insertObject:scene atIndex:index];
			index++;
			[scene release];
		}
		
		
	}
	return self;
}

- (void)dealloc 
{	
	[scene_graph release];
	[scene_desc release];
	[source release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scene Management

- (int)totalNumberOfScenes 
{
	return [self.scene_desc count];
}

- (BFScene *)openingScene
{
	return [self sceneByNumber:0];
}

- (BFScene *)currentScene
{
	return [self sceneByNumber:currentIndex];
}

- (BFScene *)sceneByNumber:(int)index
{
	currentIndex = index;
	if ([self.scene_graph count] >= index || [self.scene_graph objectAtIndex:index] != nil) {
		return [self.scene_graph objectAtIndex:index];
	}
	return nil;
}




@end
