//
//  BFSceneView.h
//  Briefs
//
//  Created by Rob Rhyne on 8/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFScene.h"

@interface BFSceneView : UIImageView 
{
	BFScene *scene;
}

@property (nonatomic, retain) BFScene *scene;

// initialization
- (id)initWithScene:(BFScene *)source;

@end
