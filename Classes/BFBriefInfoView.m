//
//  BFBriefInfoView.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefInfoView.h"


@implementation BFBriefInfoView
@synthesize titleLabel, authorLabel, fromLabel, numberOfScenesLabel, infoLabel, dateLabel, timeLabel;

- (IBAction)returnToPreview
{
    [controller shouldReturnToPreview];
}

- (IBAction)deleteTheBrief
{
    [controller shouldDeleteBrief];
}
- (IBAction)refreshTheBrief
{
    [controller shouldReloadBrief];
}



@end
