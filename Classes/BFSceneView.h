//
//  BFSceneView.h
//  Briefs
//
//  Created by Rob Rhyne on 8/18/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//


#import <UIKit/UIKit.h>
#import "BFScene.h"

@interface BFSceneView : UIImageView 
{
    BFScene *scene;
    NSArray *actor_views;
}

@property (nonatomic, retain) BFScene *scene;
@property (nonatomic, retain) NSArray *actor_views;

// initialization
- (id)initWithScene:(BFScene *)source;

@end
