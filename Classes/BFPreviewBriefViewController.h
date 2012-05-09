//
//  BFPreviewBriefViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefView.h"
#import "BFBriefInfoView.h"
#import "BFBriefDataSource.h"
#import "BriefRef.h"
#import "BFBriefViewDelegate.h"
#import "BFLoadingViewController.h"


@interface BFPreviewBriefViewController : UIViewController <BFBriefViewDelegate, UIActionSheetDelegate, BFLoadingViewDelegate>
{
    IBOutlet BFPreviewBriefView     *previewView;
    IBOutlet BFBriefInfoView        *infoView;
    
    NSInteger                       pageIndex;
    id<BFBriefDataSource>           dataSource;
    BriefRef                        *briefBeingPreviewed;
    
    UINavigationController          *parentNavigationController;

}

@property (retain)  id<BFBriefDataSource>   dataSource;
@property (nonatomic, readwrite, assign)  NSInteger               pageIndex;
@property (assign)  UINavigationController  *parentNavigationController;

- (void)shouldShowBriefDetails;
- (void)briefShouldStartPlaying;
- (void)shouldReturnToPreview;

@end
