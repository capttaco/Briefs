//
//  BFRemoteBriefSaver.m
//  Briefs
//
//  Created by Rob Rhyne on 4/10/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFRemoteBriefSaver.h"


@implementation BFRemoteBriefSaver
@synthesize delegate;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSView & NSObject Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (nibNameOrNil != nil) 
        return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    else
        return [super initWithNibName:@"BFRemoteBriefSaver" bundle:nibBundleOrNil];
}

- (id)init 
{
    return [self initWithNibName:nil bundle:nil];
}


- (void)setPromptLabelText:(NSString *)prompt
{
    promptLabel.text = prompt;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark IBActions

- (IBAction)didFinishWithSave
{
    if (self.delegate)
        [self.delegate view:self shouldDismissAndSave:YES];
}

- (IBAction)didFinishWithCancel
{
    if (self.delegate)
        [self.delegate view:self shouldDismissAndCancel:YES];
}

///////////////////////////////////////////////////////////////////////////////

@end
