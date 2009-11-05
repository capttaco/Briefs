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
@synthesize briefcast;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject methods

- (id)initWithBriefcast:(BFBriefcast *)bcast
{
    self = [super init];
    if (self != nil) {
        self.briefcast = bcast;
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
    cell.textLabel.text = self.briefcast.title;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.locationOfBriefcast = self.briefcast.url;
    if ([[tv delegate] isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tvc = (UITableViewController *) [tv delegate];
        [tvc.navigationController pushViewController:controller animated:YES];
    }
    
    [controller release];
}

///////////////////////////////////////////////////////////////////////////////

@end