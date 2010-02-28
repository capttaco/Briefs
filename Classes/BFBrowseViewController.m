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
#import "BFColor.h"


@implementation BFBrowseViewController


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Briefs";
    self.navigationController.navigationBar.tintColor = [BFColor tintColorForNavigationBar];
    self.tableView.backgroundColor = [BFColor backgroundForTableView];
    self.tableView.separatorColor = [UIColor colorWithRed:0.7667f green:0.7784f blue:0.7902f alpha:1.0f];
    
    
    // Configure the add button.
//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
//                                        target:self 
//                                        action:@selector(addBriefcast)] autorelease];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    // Configure the edit button.
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" 
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self 
                                                                   action:@selector(editBriefs)] autorelease];
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
    if (self.tableView.editing == YES)
        self.tableGroups = [NSArray arrayWithObjects:[self localBriefLocations], nil];
    else
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    if (self.tableView.editing == YES)
        return 1;
    else return 2;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Adding New Briefcasts

//- (IBAction)addBriefcast
//{
//    BFAddBriefcastViewController *controller = [[BFAddBriefcastViewController alloc] init];
//    controller.delegate = self;
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self.navigationController presentModalViewController:navigation animated:YES];
//
//    [controller release];
//    [navigation release];
//}

//- (void)addViewController:(BFAddBriefcastViewController *)controller didFinishWithSave:(BOOL)save
//{
//    if (save) {
//        BFBriefcast *briefcast = [controller briefcastFromExistingValues];
//        [[BFDataManager sharedBFDataManager] addBriefcastInformation:briefcast];
//    }
//    [self dismissModalViewControllerAnimated:YES];
//    [super updateAndReload];
//}

- (IBAction)editBriefs
{
    //NSLog(@"Edit the briefs listing.");
    BOOL editMode;
    if (self.tableView.editing == YES) {
        editMode = NO;
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
        [self.navigationItem setHidesBackButton:NO animated:YES];        
        
        [self.tableView setEditing:editMode animated:YES];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else {
        editMode = YES;
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        
        [self.tableView setEditing:editMode animated:YES];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    }
    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section 
{
    if (self.tableView.editing == YES) 
        return @"";
    else
        return (section == 0 ? @"Local Briefs" : @"Briefcasts");
}


@end
