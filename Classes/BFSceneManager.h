//
//  BFSceneManager.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFSceneManager : NSObject 
{
	NSDictionary	*source;
	NSArray				*scene_graph;
}

@property (nonatomic, readonly) NSArray *scene_graph;


- (id) initWithPathToDictionary:(NSString*)path;


/** Scene Management */
- (int) totalNumberOfScenes;
- (BFScene*) openingScene;
- (BFScene*) sceneByNumber:(int)index;




@end
