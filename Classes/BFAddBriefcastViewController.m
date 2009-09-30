//
//  BFAddBriefcastViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/21/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFAddBriefcastViewController.h"
#import "BFTextCellController.h"

@implementation BFAddBriefcastViewController

@synthesize delegate;

- (id)init
{
    if (self = [super initWithNibName:@"BFAddBriefcastViewController" bundle:nil]) {
        self.title = @"Add Briefcast";
        
        // Configure the save button.
        UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
        
        // Configure the cancel button
        UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    return self;
}

- (IBAction)save
{
    [delegate addViewController:self didFinishWithSave:YES];
}

- (IBAction)cancel
{
    [delegate addViewController:self didFinishWithSave:NO];
}


- (void)constructTableGroups
{
    NSArray *briefcastDescriptors = [NSArray arrayWithObjects: [[[BFTextCellController alloc] initWithLabel:@"Name"] autorelease],
            [[[BFTextCellController alloc] initWithLabel:@"URL"] autorelease],
            [[[BFTextCellController alloc] initWithLabel:@"Description"] autorelease], nil];
                                                                        
    self.tableGroups = [NSArray arrayWithObjects:briefcastDescriptors, nil];
}

- (BFBriefcast *)briefcastFromExistingValues
{
    if (self.tableGroups != nil) {
        NSArray *cells = [tableGroups objectAtIndex:0];
        BFBriefcast *briefcast = [[[BFBriefcast alloc] initWithName:[[cells objectAtIndex:0] savedValue] 
            andURL:[[cells objectAtIndex:1] savedValue]] autorelease];
        briefcast.description = [[cells objectAtIndex:2] savedValue];
        return briefcast;
    }
    else return nil;
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    self.delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
