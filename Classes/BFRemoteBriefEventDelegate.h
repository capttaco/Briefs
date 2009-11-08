//
//  BFRemoteBriefEventDelegate.h
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

@protocol BFRemoteBriefEventDelegate

@optional
- (void)shouldDownloadBrief:(id)sender atURL:(NSString *)url;
- (void)shouldLaunchBrief:(id)sender atURL:(NSString *)url;

@end
