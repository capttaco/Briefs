//
//  BFBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefCellController.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFPresentationDispatch.h"


@implementation BFBriefCellController


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithNameOfBrief:(NSString *)name
{
    self = [super init];
    if (self != nil) {
        brief = name;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefsCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BriefsCell"] autorelease];
    }
    cell.textLabel.text = brief;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pathToDictionary = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@", brief];
    
    // setup scene view controller
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
    
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
    
    if ([[tv delegate] isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tvc = (UITableViewController *) [tv delegate];
        [tvc.navigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:YES];
    }
    
    [controller release];
    [manager release];
}

///////////////////////////////////////////////////////////////////////////////

@end
