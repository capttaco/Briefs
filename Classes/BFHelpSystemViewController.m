//
//  BFHelpSystemViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFHelpSystemViewController.h"
#import "BFConfig.h"


@interface BFHelpSystemViewController (PrivateMethods)

- (NSString *)starterKitEmailMessageBody;
- (NSString *)fullyReferencedHelpFile:(NSString *)ref;

@end



@implementation BFHelpSystemViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self changePage];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)changePage
{
    NSURL *loadURL = nil;
    switch ([pageControl selectedSegmentIndex]) {
            
        case BFHelpSystemAboutSelection:
            loadURL = [NSURL URLWithString:[self fullyReferencedHelpFile:kBFHelpSystemAboutPath]];
            break;
        
        case BFHelpSystemBuildSelection:
            loadURL = [NSURL URLWithString:[self fullyReferencedHelpFile:kBFHelpSystemBuildPath]];
            break;
            
        case BFHelpSystemShareSelection:
            loadURL = [NSURL URLWithString:[self fullyReferencedHelpFile:kBFHelpSystemSharePath]];
            break;
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:loadURL];
    [contentView loadRequest:urlRequest];
}

- (IBAction)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)emailStarterKit
{
    UIActionSheet *confirmSheet = [[UIActionSheet alloc] initWithTitle:@"Prepare an email to help get you started?" delegate:self cancelButtonTitle:@"No, thank you." destructiveButtonTitle:nil otherButtonTitles:@"Yes, that would rock!", nil];
    
    [confirmSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    if ([actionSheet cancelButtonIndex] != buttonIndex && [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        [mail setMailComposeDelegate:self];
        [mail setSubject:@"Briefs Starter Kit"];
        
        // add starter kit zip file
        [mail setMessageBody:[self starterKitEmailMessageBody] isHTML:NO];
        
        mail.navigationBar.tintColor = [BFConfig tintColorForNavigationBar];
        
        [self presentModalViewController:mail animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // TODO: handle that the email was sent
    //       ... or err, not sent.
    
    [controller dismissModalViewControllerAnimated:YES];
}


- (NSString *)starterKitEmailMessageBody
{
    return [NSString stringWithFormat:@"Start authoring briefs today. Download the starter kit below, then use the documentation to get started.\n\n%@\n\nDocumentation\n%@", kBFHelpSystemStarterKitPath, kBFHelpSystemDocumentationBasePath];
}

- (NSString *)fullyReferencedHelpFile:(NSString *)ref
{
    return [NSString stringWithFormat:@"%@%@", kBFHelpSystemDocumentationBasePath, ref]; 
}

@end
