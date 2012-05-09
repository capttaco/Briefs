//
//  BFMainViewDefaultController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFMainViewDefaultController.h"
#import "BFRefreshBriefCellController.h"
#import "BFBriefcastCellController.h"
#import "BFConfig.h"
#import "BFDataManager.h"
#import "BriefRef.h"

@implementation BFMainViewDefaultController

- (id)initWithNavController:(UINavigationController *)controller
{
    if (self = [super initWithNibName:@"BFMainViewDefaultController" bundle:nil]) {
        navigation = controller;
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [BFConfig separatorColorForTableView];
    
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];

    // Unselect the selected row if any
	NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
	if (selection) {
        // [self.tableView deselectRowAtIndexPath:selection animated:YES];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selection];
        [selectedCell setSelected:NO animated:YES];
    }
    
    [self updateAndReload];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController methods

- (void)constructTableGroups
{
    NSMutableArray *briefControllers = [NSMutableArray array];
    NSMutableArray *briefcastController = [NSMutableArray array];
    
    // get most recently viewed briefs
    id<BFBriefDataSource> recentBriefs = [[BFDataManager sharedBFDataManager] briefsSortedAs:BFDataManagerSortByDateOpened limitTo:2];
    if ([recentBriefs numberOfRecords] >= 1) {
        BFRefreshBriefCellController *controller1 = [[BFRefreshBriefCellController alloc] initWithBrief:[recentBriefs dataForIndex:0]];
        controller1.navigation = navigation;
        [briefControllers addObject:controller1];
        
        if ([recentBriefs numberOfRecords] >= 2) {
            BFRefreshBriefCellController *controller2 = [[BFRefreshBriefCellController alloc] initWithBrief:[recentBriefs dataForIndex:1]];
            controller2.navigation = navigation;
            [briefControllers addObject:controller2];
        }
    }
    
    
    // get last opened briefcast
    NSArray *lastOpenedBriefcast = [[BFDataManager sharedBFDataManager] briefcastsSortedAs:BFDataManagerSortByDateOpened limitTo:1];
    if (lastOpenedBriefcast != nil && [lastOpenedBriefcast count] > 0) {
        BFBriefcastCellController *controller = [[BFBriefcastCellController alloc] initWithBriefcast:[lastOpenedBriefcast objectAtIndex:0]];
        controller.delegate = navigation;
        [briefcastController addObject:controller];
    }
    else briefcastController = nil;
    
    self.tableGroups = [NSArray arrayWithObjects:briefControllers, briefcastController, nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? briefHeaderView : briefcastHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? briefHeaderView.frame.size.height : briefcastHeaderView.frame.size.height;
}

///////////////////////////////////////////////////////////////////////////////

@end
