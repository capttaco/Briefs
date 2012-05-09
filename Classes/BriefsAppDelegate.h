//
//  BriefsAppDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 6/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#define kBFHasLaunchedBefore        @"App has Launched"

@interface BriefsAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> 
{
    UINavigationController          *navigationController;
    UIWindow                        *window;
}

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
@property (nonatomic) IBOutlet UIWindow *window;


@end

