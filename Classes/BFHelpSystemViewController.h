//
//  BFHelpSystemViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 5/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


#define kBFHelpSystemAboutPath              @"index.html"
#define kBFHelpSystemBuildPath              @"build.html"
#define kBFHelpSystemSharePath              @"share.html"
#define kBFHelpSystemStarterKitPath         @"http://giveabrief.com/files/starterkit.zip"
#define kBFHelpSystemDocumentationBasePath  @"http://giveabrief.com/docs/"

typedef enum {
    BFHelpSystemAboutSelection = 0,
    BFHelpSystemBuildSelection = 1,
    BFHelpSystemShareSelection = 2,
} BFHelpSystemSelectionIndex;


@interface BFHelpSystemViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIWebView          *contentView;
    IBOutlet UISegmentedControl *pageControl;
}

- (IBAction)dismiss;
- (IBAction)emailStarterKit;
- (IBAction)changePage;

@end
