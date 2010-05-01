//
//  BFBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFCellController.h"
#import "FeedParser.h"
#import "BFBriefcastEventDelegate.h"

typedef enum {
    /** Brief already exists, but a newer version exists */
    BFBriefCellInstallTypeUpdate = -123,
    
    /** Brief is not installed */
    BFBriefCellInstallTypeNewInstall = -122,
    
    /** Brief is installed with the newest version */
    BFBriefCellInstallTypeAlreadyInstalled = -133
    
} BFBriefCellInstallType;


@interface BFBriefCellController : NSObject<BFCellController> 
{
    id<BFBriefcastEventDelegate>  delegate;
    BFBriefCellInstallType          installType;
    FPItem                          *brief;
    
    // UI State
    BOOL    isSelected;
    BOOL    isInstallButtonExpanded;
    
    
    // Text
    IBOutlet UILabel    *indexLabel;
    IBOutlet UILabel    *titleLabel;
    IBOutlet UILabel    *descLabel;
    
    // Layout
    IBOutlet UIView     *leftAccessoryView;
    IBOutlet UIView     *contentView;
    IBOutlet UIView     *rightAccessoryView;
    
    // Controls
    IBOutlet UIView     *indexView;
    IBOutlet UIView     *remotePlayView;
    IBOutlet UIButton   *remotePlayButton;
    IBOutlet UIButton   *installButton;
    UIImageView         *installButtonBg;
}

@property (nonatomic, retain) FPItem                            *brief;
@property (nonatomic, assign) id<BFBriefcastEventDelegate>    delegate;

- (id)initWithEnclosure:(FPItem *)item;

- (IBAction)shouldBeginRemotePlay;
- (IBAction)shouldStartDownloadingBrief;

@end
