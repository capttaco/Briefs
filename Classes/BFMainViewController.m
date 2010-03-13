//
//  BFMainViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 1/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewController.h"
#import "BFBrowseViewController.h"
#import "BFBrowseBriefcastsViewController.h"
#import "BFColor.h"


@interface BFMainViewController (private)

- (void)hideMenuWithAnimation;

@end


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

- (void)viewWillAppear:(BOOL)animated
{
    // push down the menu view
    [UIView beginAnimations:@"MenuSlideUpTransition" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.3f];
    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 280.0f, size.width, size.height);
    
    [UIView commitAnimations];
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

- (void)hideMenuWithAnimation
{
    // push down the menu view
    [UIView beginAnimations:@"MenuSlideDownTransition" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    CGSize size = menuView.frame.size;
    menuView.frame = CGRectMake(0.0f, 480.0f, size.width, size.height);
    
    [UIView commitAnimations];
}

- (IBAction)browseYourBriefs
{
    [self hideMenuWithAnimation];
    
    // show browser view
    [self.navigationController pushViewController:[[BFBrowseViewController alloc] init] animated:YES];
}


- (IBAction)browseYourBriefcasts
{
    [self hideMenuWithAnimation];
    [self.navigationController pushViewController:[[BFBrowseBriefcastsViewController alloc] init] animated:YES];
}

///////////////////////////////////////////////////////////////////////////////

@end
