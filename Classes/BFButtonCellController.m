//
//  BFButtonCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFButtonCellController.h"
#import "BFCellConfiguration.h"

@implementation BFButtonCellController

- (id)initWithButtonLabel:(NSString *)label
{
    BFCellConfiguration *cellConfig = [BFCellConfiguration newDefaultSelectableConfiguration];
    cellConfig.font = [UIFont boldSystemFontOfSize:14.0];
    cellConfig.color = [UIColor colorWithRed:0.1016f green:0.2969f blue:0.5391f alpha:1.0];
    cellConfig.alignment = UITextAlignmentCenter;
    cellConfig.accessoryType = UITableViewCellAccessoryNone;
    self = [super initWithLabel:label andConfiguration:cellConfig];
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    // TODO: Need to support calling a selector here!
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end
