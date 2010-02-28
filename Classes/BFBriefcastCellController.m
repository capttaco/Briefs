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
    //BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] initWithStyle:UITableViewStyleGrouped];
    BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] initWithNibName:@"BFBriefcastViewController" bundle:nil];
    controller.locationOfBriefcast = self.briefcast.url;
    //BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] initWithBriefcast:self.briefcast];
    if ([[tv delegate] isKindOfClass:[UIViewController class]]) {
        UIViewController *tvc = (UIViewController *) [tv delegate];
        [tvc.navigationController pushViewController:controller animated:YES];
    }
    
    [controller release];
}

///////////////////////////////////////////////////////////////////////////////

@end