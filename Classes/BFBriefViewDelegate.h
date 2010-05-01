//
//  BFBriefViewDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 3/26/10.
//  Copyright 2010 Digital Arch Design. All rights reserved.
//

@protocol BFBriefViewDelegate

- (void)shouldShowBriefDetails;
- (void)shouldReturnToPreview;
- (void)shouldDeleteBrief;
- (void)shouldReloadBrief;
- (void)briefShouldStartPlaying;

@end
