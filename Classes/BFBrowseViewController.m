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


@implementation BFBrowseViewController

@synthesize knownBriefs;

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"My Briefs";
  
  NSArray *values = [NSArray arrayWithObjects:[self localBriefLocations], [self storedBriefcastLocations], nil];
  NSArray *keys = [NSArray arrayWithObjects:@"local", @"briefcast", nil];
  self.knownBriefs = [NSDictionary dictionaryWithObjects:values forKeys:keys];
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



- (NSArray *)localBriefLocations
{
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[[NSBundle mainBundle] resourcePath]];
  NSMutableArray *arrayOfLocals = [NSMutableArray arrayWithCapacity:5];
  
  NSString *next;
  while (next = [enumerator nextObject])
  {
    if ([[next pathExtension] isEqualToString:@"brieflist"]) {
      [arrayOfLocals addObject:next];
    }
  }
  return arrayOfLocals;
}

- (NSArray *)storedBriefcastLocations
{
  return [NSArray arrayWithObjects:@"Sample Briefcast", @"Killer Briefcast", nil];
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
  // Locally stored Briefcasts
  if (section == 0) {
    return [[self.knownBriefs valueForKey:@"local"] count];
  }
  else {
    return [[self.knownBriefs valueForKey:@"briefcast"] count];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefsCell"];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BriefsCell"] autorelease];
  }
  
  // Brief stored locally
  if (indexPath.section == 0) {
    NSArray *locals = [[self knownBriefs] valueForKey:@"local"];
    cell.text = [locals objectAtIndex:indexPath.row];
  }
  
  // Briefcast listing
  else {
    NSArray *briefcasts = [[self knownBriefs] valueForKey:@"briefcast"];
    cell.text = [briefcasts objectAtIndex:indexPath.row];
  }
  
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
  if (indexPath.section == 0) {
    NSString *currentBrief = [[self.knownBriefs valueForKey:@"local"] objectAtIndex:indexPath.row];
    NSString *pathToDictionary = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@", currentBrief];
    
    // setup scene view controller
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
    
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
      [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
    
    [self.navigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:YES];
    
    
    [controller release];
    [manager release];
  }
  
  // Briefcast support stub
  else {
    BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] init];
    controller.locationOfBriefcast = @"http://digitalarch.net/briefcast/briefcast.xml";
    [self.navigationController pushViewController:controller animated:YES];
  }
  
}
 
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
  // The table view should not be re-orderable.
  return NO;
}


@end
