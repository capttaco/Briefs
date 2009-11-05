//
//  BFHeaderCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 11/3/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFHeaderCellController.h"


@implementation BFHeaderCellController
@synthesize headerText;

- (id)initWithHeader:(NSString *)header
{
    self = [super init];
    if (self != nil) {
        self.headerText = header;
    }
    return self;
}

- (void)dealloc 
{
    [self.headerText release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"HeaderCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell"] autorelease];

        //UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small-gradient.png"]];
        //bg.frame = CGRectMake(0, 0, 320.0f - 2.0*cell.indentationWidth, 33.0f);
        //[cell.contentView addSubview:bg];
        cell.backgroundColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0];
        
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.headerText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 21.0f;
}

///////////////////////////////////////////////////////////////////////////////

@end
