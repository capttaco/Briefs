//
//  BFHelpSystemViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 5/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


#define kBFHelpSystemGettingStarted         @"gettingstarted"
#define kBFHelpSystemShare                  @"share"
#define kBFHelpSystemFAQ                    @"faq"

typedef enum {
    BFHelpSystemGettingStartedSelection = 0,
    BFHelpSystemShareSelection = 1,
    BFHelpSystemFAQSelection = 2,
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
