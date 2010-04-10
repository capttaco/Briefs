//
//  BFRemoteBriefViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 4/7/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFLoadingViewController.h"
#import "BFSceneViewController.h"
#import "BFRemoteBriefSaver.h"

@protocol BFRemoteBriefViewDelegate;
@interface BFRemoteBriefViewController : UIViewController <BFLoadingViewDelegate, BFSceneViewDelegate, BFRemoteBriefSaverDelegate>
{
    BFLoadingViewController  *loadingController;
    BFRemoteBriefSaver       *remoteSaver;
    NSString                 *locationOfBrief;
    BOOL                     alreadyLoaded;
    
    NSData                  *briefData;
    id<BFRemoteBriefViewDelegate> delegate;
}

@property (nonatomic, retain) id<BFRemoteBriefViewDelegate> delegate;

- (id)initWithLocationOfBrief:(NSString *)location;

@end

@protocol BFRemoteBriefViewDelegate

- (void)remoteView:(BFRemoteBriefViewController *)view shouldDismissView:(BOOL)reload;

@end
