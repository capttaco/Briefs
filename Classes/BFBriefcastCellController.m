//
//  BFBriefcastCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastCellController.h"
#import "BFBriefcastViewController.h"
#import "BFBriefcast.h"


@implementation BFBriefcastCellController

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject methods

- (id)initWithBriefcast:(BFBriefcast *)bcast
{
  self = [super init];
  if (self != nil) {
    briefcast = bcast;
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefcastCell"];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BriefcastCell"] autorelease];
  }
  cell.text = briefcast.title;
  return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] init];
  controller.locationOfBriefcast = briefcast.url;
  if ([[tv delegate] isKindOfClass:[UITableViewController class]]) {
    UITableViewController *tvc = (UITableViewController *) [tv delegate];
    [tvc.navigationController pushViewController:controller animated:YES];
  }
  
  [controller release];
}

///////////////////////////////////////////////////////////////////////////////

@end