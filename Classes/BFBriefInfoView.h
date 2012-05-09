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
    IBOutlet UIButton                  *refreshButton;
}

@property   IBOutlet UILabel    *titleLabel;
@property   IBOutlet UILabel    *authorLabel;
@property   IBOutlet UILabel    *fromLabel;
@property   IBOutlet UILabel    *numberOfScenesLabel;
@property   IBOutlet UILabel    *infoLabel;
@property   IBOutlet UILabel    *dateLabel;
@property   IBOutlet UILabel    *timeLabel;
@property   IBOutlet UIButton   *refreshButton;



// Button Actions
- (IBAction)returnToPreview;
- (IBAction)deleteTheBrief;
- (IBAction)refreshTheBrief;


@end
