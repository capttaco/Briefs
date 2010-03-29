//
//  BFBrowseBriefsViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/12/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBrowseBriefcastsViewController.h"
#import "BFColor.h"
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
    self.title = @"My Briefcasts";
    self.navigationController.navigationBar.tintColor = [BFColor tintColorForNavigationBar];
    self.tableView.backgroundColor = [BFColor backgroundForTableView];
    self.tableView.separatorColor = [UIColor colorWithRed:0.7667f green:0.7784f blue:0.7902f alpha:1.0f];
    
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
    NSMutableArray *allControllers = [NSMutableArray array];
    
    NSArray *knownBriefcasts = [[BFDataManager sharedBFDataManager] allBriefcastsSortedAs:BFDataManagerSortByDateOpened];
    for (BriefcastRef *ref in knownBriefcasts) {

        // add briefcast cell
        //BFBriefcast *briefcast = [[[BFBriefcast alloc] initWithRef:ref] autorelease]; 
        BFBriefcastCellController *controller = [[[BFBriefcastCellController alloc] initWithBriefcast:ref] autorelease];
        [allControllers addObject:controller];
    }
    
    BFAddBriefcastCellController *addController = [[BFAddBriefcastCellController alloc] initWithButtonLabel:@"Add Briefcast"];
    addController.delegate = self;
    NSArray *buttonControllers = [NSArray arrayWithObjects:[addController autorelease], nil];
    
    self.tableGroups = [NSArray arrayWithObjects:allControllers, buttonControllers, nil];
}

- (IBAction)editBriefcasts
{
    if (self.tableView.editing == YES) {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
        [self.navigationItem setHidesBackButton:NO animated:YES];        
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        [self.navigationItem setHidesBackButton:YES animated:YES];
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


@end
