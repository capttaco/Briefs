//
//  BFHelpSystemViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/2/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFHelpSystemViewController.h"
#import "BFConfig.h"


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


- (void)dealloc 
{
    [super dealloc];
}

- (IBAction)changePage
{
    NSURL *loadURL = nil;
    switch ([pageControl selectedSegmentIndex]) {
            
        case BFHelpSystemGettingStartedSelection:
//            loadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kBFHelpSystemGettingStarted ofType:@"html"]];
            loadURL = [NSURL URLWithString:kBFHelpSystemGettingStarted];
            break;
        
        case BFHelpSystemShareSelection:
//            loadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kBFHelpSystemShare ofType:@"html"]];
            loadURL = [NSURL URLWithString:kBFHelpSystemShare];
            break;
            
        case BFHelpSystemFAQSelection:
//            loadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kBFHelpSystemFAQ ofType:@"html"]];
            loadURL = [NSURL URLWithString:kBFHelpSystemFAQ];
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
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        [mail setMailComposeDelegate:self];
        [mail setSubject:@"Attached: Briefs Starter Kit"];
        
        // add starter kit zip file
        NSString *pathToKit = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"starter-kit.zip"];
        NSData *kitBlob = [NSData dataWithContentsOfFile:pathToKit];
        [mail addAttachmentData:kitBlob mimeType:@"zip" fileName:@"starter-kit.zip"];
        
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

@end
