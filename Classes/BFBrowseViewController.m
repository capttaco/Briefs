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


@implementation BFBrowseViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"My Briefs";
}

- (void)constructTableGroups
{
  tableGroups = [[NSArray arrayWithObjects:[self localBriefLocations], [self storedBriefcastLocations], nil] retain];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
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
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  return (section == 0 ? @"Local Briefs" : @"Briefcasts");
}


@end
