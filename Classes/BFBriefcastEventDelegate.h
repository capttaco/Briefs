//
//  BFBriefcastEventDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

@protocol BFBriefcastEventDelegate

@optional
- (void)shouldDownloadBrief:(id)sender atURL:(NSString *)url;
- (void)shouldLaunchBrief:(id)sender atURL:(NSString *)url;

@end
