//
//  BFPreviewBriefView.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefView.h"


@implementation BFPreviewBriefView
@synthesize titleLabel, sceneView;

- (void)_runShouldShowBriefDetails
{
    [delegate shouldShowBriefDetails];
}
- (IBAction)shouldShowBriefInfo
{
    [self performSelectorOnMainThread:@selector(_runShouldShowBriefDetails) withObject:nil waitUntilDone:NO];
}

- (void)_runShouldLaunchBrief
{
    [delegate briefShouldStartPlaying];
}

- (IBAction)shouldLaunchBrief
{
    [self performSelectorOnMainThread:@selector(_runShouldLaunchBrief) withObject:nil waitUntilDone:NO];
}


@end
