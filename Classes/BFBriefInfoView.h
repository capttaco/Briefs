//
//  BFBriefInfoView.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefViewDelegate.h"

@interface BFBriefInfoView : UIView 
{
    IBOutlet id<BFBriefViewDelegate>   controller;
    IBOutlet UILabel                   *titleLabel;
    IBOutlet UILabel                   *authorLabel;
    IBOutlet UILabel                   *fromLabel;
    IBOutlet UILabel                   *numberOfScenesLabel;
    IBOutlet UILabel                   *infoLabel;
    IBOutlet UILabel                   *dateLabel;
    IBOutlet UILabel                   *timeLabel;
}

@property (retain)  IBOutlet UILabel *titleLabel;
@property (retain)  IBOutlet UILabel *authorLabel;
@property (retain)  IBOutlet UILabel *fromLabel;
@property (retain)  IBOutlet UILabel *numberOfScenesLabel;
@property (retain)  IBOutlet UILabel *infoLabel;
@property (retain)  IBOutlet UILabel *dateLabel;
@property (retain)  IBOutlet UILabel *timeLabel;



// Button Actions
- (IBAction)returnToPreview;
- (IBAction)deleteTheBrief;
- (IBAction)refreshTheBrief;


@end
