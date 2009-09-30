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
        NSArray *scenes = [dict valueForKey:@"scenes"];
        
        openingScene = [[dict valueForKey:@"start_scene"] intValue];
        
        self.source = dict;
        self.scene_desc = scenes;
        currentIndex = openingScene;
        
        NSMutableArray *graph = [NSMutableArray arrayWithCapacity:[self.scene_desc count]];
        for (NSDictionary *dictionary in scenes) {
            BFScene *scene = [[BFScene alloc] init:[dictionary valueForKey:@"name"] withDictionary:dictionary];
            [graph addObject:scene];
            [scene release];
        }
        self.scene_graph = graph;
        
        // memory cleanup
        [scenes release];
    }
    return self;
}

- (void)dealloc 
{ 
    [scene_graph release];
    [scene_desc release];
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
    return [self sceneByNumber:openingScene];
}

- (BFScene *)currentScene
{
    return [self sceneByNumber:currentIndex];
}

- (BFScene *)sceneByNumber:(int)index
{
    currentIndex = index;
    BFScene *scene = [self.scene_graph objectAtIndex:index];
    if ([self.scene_graph count] >= index || scene != nil) {
        return scene;
    }
    return nil;
}




@end
