//
//  BFBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFCellController.h"
#import "FeedParser.h"

typedef enum {
    /** Brief already exists, but a newer version exists */
    BFBriefCellInstallTypeUpdate = -123,
    
    /** Brief is not installed */
    BFBriefCellInstallTypeNewInstall = -122,
    
    /** Brief is installed with the newest version */
    BFBriefCellInstallTypeAlreadyInstalled = -123
    
} BFBriefCellInstallType;


@interface BFBriefCellController : NSObject<BFCellController> 
{
    FPItem                  *brief;
    BFBriefCellInstallType  installType;
    BOOL                    isSelected;
    BOOL                    isInstallButtonExpanded;
    
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
}

@property (nonatomic, retain) FPItem *brief;

- (id)initWithEnclosure:(FPItem *)item installType:(BFBriefCellInstallType)install;

- (IBAction)shouldBeginRemotePlay;
- (IBAction)shouldStartDownloadingBrief;

@end
