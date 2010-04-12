//
//  BFBrowseBriefsViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/12/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBrowseBriefcastsViewController.h"
#import "BFConfig.h"
#import "BFDataManager.h"
#import "BriefcastRef.h"
#import "BFBriefcast+CoreDataAdditions.h"
#import "BFBriefcastCellController.h"
#import "BFAddBriefcastCellController.h"


@implementation BFBrowseBriefcastsViewController

- (id)init
{
    self = [super initWithNibName:@"BFBrowseBriefcastViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // style view
    self.title = @"Briefcasts";
    self.navigationController.navigationBar.tintColor = [BFConfig tintColorForNavigationBar];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [BFConfig separatorColorForTableView];
    tableFooterView.alpha = 0.0;
    
    // Edit button
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" 
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self 
                                                                   action:@selector(editBriefcasts)] autorelease];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self updateAndReload];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController methods

- (void)constructTableGroups
{
    NSMutableArray *allControllers = [NSMutableArray array];
    
    NSArray *knownBriefcasts = [[BFDataManager sharedBFDataManager] allBriefcastsSortedAs:BFDataManagerSortByDateOpened];
    for (BriefcastRef *ref in knownBriefcasts) {
        // add briefcast cell
        BFBriefcastCellController *controller = [[[BFBriefcastCellController alloc] initWithBriefcast:ref] autorelease];
        [allControllers addObject:controller];
    }
    
    self.tableGroups = [NSArray arrayWithObjects:allControllers, nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableHeaderView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return tableFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableFooterView.frame.size.height;
}

- (void)animateTableFooterView:(CGFloat)alphaValue
{
    [UIView beginAnimations:@"animate footer" context:nil];
    tableFooterView.alpha = alphaValue;
    [UIView commitAnimations];
}

- (IBAction)editBriefcasts
{
    if (self.tableView.editing == YES) {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self animateTableFooterView:0.0f];
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addBriefcast)] autorelease];
        [self.navigationItem setLeftBarButtonItem:addButton animated:YES];
        [self animateTableFooterView:1.0f];
    }

    [self.tableView setEditing:!self.tableView.editing animated:YES];
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
}

- (IBAction)showBuiltInBriefs
{
    
}

@end
