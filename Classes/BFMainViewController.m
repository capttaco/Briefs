//
//  BFMainViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 1/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewController.h"
#import "BFBrowseViewController.h"
#import "BFColor.h"

@implementation BFMainViewController


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [BFColor tintColorForNavigationBar];
    self.title = @"Welcome";
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Main Menu Actions

- (IBAction)browseYourBriefs
{
    NSLog(@"Go to my Briefs!");
    [self.navigationController pushViewController:[[BFBrowseViewController alloc] initWithNibName:@"BFBrowseViewController" bundle:nil] animated:YES];
}

- (IBAction)browseYourBriefcasts
{
    NSLog(@"Go to my Briefcasts!");
}

///////////////////////////////////////////////////////////////////////////////

@end
