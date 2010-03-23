//
//  BFBriefInfoView.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

@class BFPreviewBriefViewController;

@interface BFBriefInfoView : UIView 
{
    IBOutlet BFPreviewBriefViewController *controller;
}

- (IBAction)returnToPreview;

@end
