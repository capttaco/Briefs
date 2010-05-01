//
//  BFAddBriefcastCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFAddBriefcastCellController.h"


@implementation BFAddBriefcastCellController
@synthesize delegate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(addBriefcast)]) {
        [delegate addBriefcast];
    }
}

@end
