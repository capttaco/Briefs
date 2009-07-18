//
//  SceneViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface BFSceneViewController : UIViewController 
{
	UIImageView			*view;
	BFSceneManager	*dataManager;
}

@property (nonatomic, retain) UIImageView			*view;
@property (nonatomic, retain) BFSceneManager	*dataManager;

- (id) initWithSceneManager:(BFSceneManager*)manager;

@end
