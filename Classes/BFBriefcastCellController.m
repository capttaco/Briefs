//
//  BFBriefcastCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastCellController.h"
#import "BFBriefcastViewController.h"
#import "BFDataManager.h"
#import "BFConfig.h"


@implementation BFBriefcastCellController
@synthesize briefcast;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject methods

- (id)initWithBriefcast:(BriefcastRef *)bcast
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
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BFBriefcastCell" owner:self options:nil];
        cell = (UITableViewCell *) [nibArray objectAtIndex:0];
    }
    
    titleLabel.text = [self.briefcast title];
    
    if ([self.briefcast.totalNumberOfBriefcasts intValue] > 0)
        descLabel.text = [NSString stringWithFormat:@"%@ Briefs, last opened on %@", 
                      self.briefcast.totalNumberOfBriefcasts, [BFConfig shortDateStringFromDate:self.briefcast.dateLastOpened]];
    
    else descLabel.text = @"No information available.";

    
    // calculate background
    UIImage *bgImage, *selectedBgImage;
    if (indexPath.row == 0) {
        // top
        bgImage = [[UIImage imageNamed:@"cell-top.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-top-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    } 
    
    else if (indexPath.row == [tv numberOfRowsInSection:indexPath.section]-1) {
        // bottom
        bgImage = [[UIImage imageNamed:@"cell-bottom.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-bottom-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    }
    
    else {
        // middle
        bgImage = [[UIImage imageNamed:@"cell-middle.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-middle-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:bgImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBgImage];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFBriefcastViewController *controller = [[BFBriefcastViewController alloc] initWithNibName:@"BFBriefcastViewController" bundle:nil];
    controller.briefcast = self.briefcast;

    if ([[tv delegate] isKindOfClass:[UIViewController class]]) {
        UIViewController *tvc = (UIViewController *) [tv delegate];
        [tvc.navigationController pushViewController:controller animated:YES];
    }
    
    [controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [[BFDataManager sharedBFDataManager] removeBriefcast:self.briefcast];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

///////////////////////////////////////////////////////////////////////////////

@end