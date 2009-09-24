//
//  BFBrowseViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 8/31/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBrowseViewController.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFPresentationDispatch.h"
#import "BFBriefcastViewController.h"
#import "BFBriefcast.h"
#import "BFBriefcastCellController.h"
#import "BFBriefCellController.h"
#import "BFAddBriefcastViewController.h"
#import "BFDataManager.h"


@implementation BFBrowseViewController


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject Methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"My Briefs";
  
  // Configure the add button.
  UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                             target:self 
                                                                             action:@selector(addBriefcast)] autorelease];
  self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController methods

- (void)constructTableGroups
{
  self.tableGroups = [NSArray arrayWithObjects:[self localBriefLocations], [self storedBriefcastLocations], nil];
}

- (NSArray *)localBriefLocations
{
  return [[BFDataManager sharedBFDataManager] listOfLocalBriefsWithExtension:@"brieflist"];
}

- (NSArray *)storedBriefcastLocations
{
  return [[BFDataManager sharedBFDataManager] listOfKnownBriefcasts];
}                                   

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Adding New Briefcasts

- (IBAction)addBriefcast
{
  BFAddBriefcastViewController *controller = [[BFAddBriefcastViewController alloc] init];
  controller.delegate = self;
  UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
  [self.navigationController presentModalViewController:navigation animated:YES];

  [controller release];
  [navigation release];
}

- (void)addViewController:(BFAddBriefcastViewController *)controller didFinishWithSave:(BOOL)save
{
  if (save) {
    BFBriefcast *briefcast = [controller briefcastFromExistingValues];
    [[BFDataManager sharedBFDataManager] addBriefcastInformation:briefcast];
  }
  [self dismissModalViewControllerAnimated:YES];
  [super updateAndReload];
  //NSLog(@"%@", tableGroups);
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return (section == 0 ? @"Local Briefs" : @"Briefcasts");
}


@end
