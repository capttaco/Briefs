//
//  SceneViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFSceneManager.h"

@interface BFSceneViewController : UIViewController 
{
	BFSceneManager	*dataManager;
	UIImageView			*imageView;
}

@property (nonatomic, retain) BFSceneManager	*dataManager;
@property (nonatomic, retain) UIImageView			*imageView;

- (id) initWithSceneManager:(BFSceneManager*)manager;

@end
