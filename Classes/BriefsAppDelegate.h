//
//  BriefsAppDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>

@interface BriefsAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> 
{
	UINavigationController	*navigationController;
  UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;


- (void)navigationController:(UINavigationController *)nav willShowViewController:(UIViewController *)view animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)nav didShowViewController:(UIViewController *)view animated:(BOOL)animated;

@end

