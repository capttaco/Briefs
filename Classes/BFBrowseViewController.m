//
//  BFBrowseViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 8/31/09.
//  Copyright 2009 Digital Arch Design Corporation. All rights reserved.
//

#import "BFBrowseViewController.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFPresentationDispatch.h"


@implementation BFBrowseViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"My Briefs";
}
- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  // Two sections: Local Briefs & Briefcasts
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  // TODO: calculate number of available briefcasts and local briefs
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefsCell"];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BriefsCell"] autorelease];
  }
  
  // TODO: need to get name of brief from a directory 
  //       listing or something
	cell.text = @"The Brief Title";
	
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return (section == 0 ? @"Local Briefs" : @"Briefcasts");
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Selection and moving

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  // setup scene view controller
	NSString *pathToDictionary = [[NSBundle mainBundle] pathForResource:@"sample-brief" ofType:@"plist"];
  BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
  BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
   
  // wire dispatch
  if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
    [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
  [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
	
  [self.navigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:YES];
  
  // TODO: making navigation bar disappear, need to figure out a way
  //       to make it re-appear.
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  
	[controller release];
  [manager release];
}
 
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
  // The table view should not be re-orderable.
  return NO;
}


@end
