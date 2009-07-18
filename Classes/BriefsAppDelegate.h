//
//  BriefsAppDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFSceneViewController.h"

@interface BriefsAppDelegate : NSObject <UIApplicationDelegate> 
{
	IBOutlet UIWindow			*window;
	BFSceneViewController *sceneController;
	BFSceneManager				*dataManager;
}

@property (nonatomic, retain) IBOutlet UIWindow			*window;
@property (nonatomic, retain) BFSceneViewController *sceneController;
@property (nonatomic, retain) BFSceneManager				*dataManager;

@end

