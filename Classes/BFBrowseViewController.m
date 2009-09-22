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
  tableGroups = [[NSArray arrayWithObjects:[self localBriefLocations], [self storedBriefcastLocations], nil] retain];
}

- (NSArray *)localBriefLocations
{
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[[NSBundle mainBundle] resourcePath]];
  NSMutableArray *arrayOfLocals = [NSMutableArray array];
  
  NSString *next;
  while (next = [enumerator nextObject])
  {
    if ([[next pathExtension] isEqualToString:@"brieflist"]) {
      BFBriefCellController *controller = [[BFBriefCellController alloc] initWithNameOfBrief:next];
      [arrayOfLocals addObject:controller];
      [controller release];
    }
  }
  return arrayOfLocals;
}

- (NSArray *)storedBriefcastLocations
{
  BFBriefcast *sample = [[BFBriefcast alloc] initWithName:@"Sample Briefcast" 
                                                   andURL:@"http://digitalarch.net/briefcast/briefcast.xml"];
  BFBriefcast *killer = [[BFBriefcast alloc] initWithName:@"Killer Briefcast" 
                                                   andURL:@"http://digitalarch.net/briefcast/briefcast.xml"];
  
  BFBriefcastCellController *sample_cast = [[BFBriefcastCellController alloc] initWithBriefcast:sample];
  BFBriefcastCellController *killer_cast = [[BFBriefcastCellController alloc] initWithBriefcast:killer];
  
  NSArray *array = [NSArray arrayWithObjects:sample_cast, killer_cast, nil];
  
  [sample_cast release];
  [killer_cast release];
  
  return array;
  
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
}

- (void)addViewController:(BFAddBriefcastViewController *)controller didFinishWithSave:(BOOL)save
{
  // TODO: Save the briefcast definitions locally
  [self dismissModalViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return (section == 0 ? @"Local Briefs" : @"Briefcasts");
}


@end
