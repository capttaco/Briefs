//
//  BFTableViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/15/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTableViewController.h"
#import "BFCellController.h"


//  Adapted from code seen on http://cocoawithlove.com/2008/12/heterogeneous-cells-in.html
// 
//  Originally created by Matt Gallagher on 27/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

@implementation BFTableViewController


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Data Management

- (void)constructTableGroups
{
	tableGroups = [[NSArray arrayWithObject:[NSArray array]] retain];
}

- (void)clearTableGroups
{
	[tableGroups release];
	tableGroups = nil;
}

- (void)updateAndReload
{
	[self clearTableGroups];
	[self constructTableGroups];
	[self.tableView reloadData];
}



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (!tableGroups)
		[self constructTableGroups];
	
	return [tableGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!tableGroups)
		[self constructTableGroups];
	return [[tableGroups objectAtIndex:section] count];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Selection and moving

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!tableGroups) {
		[self constructTableGroups];
	}
	
	return [[[tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] tableView:(UITableView *)tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!tableGroups)	{
		[self constructTableGroups];
	}
	
	NSObject<BFCellController> *cellData = [[tableGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	if ([cellData respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
		[cellData tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];	
	[self clearTableGroups];
}

- (void)dealloc
{
	[self clearTableGroups];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////

@end


