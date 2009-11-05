//
//  BFTitleCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 10/2/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFLabelCellController.h"
#import "BFCellConfiguration.h"

@implementation BFLabelCellController

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject methods

@synthesize labelText, detailsText, config;

- (id)initWithLabel:(NSString *)label
{
    self = [super init];
    if (self != nil) {
        self.labelText = label;
        self.config = [BFCellConfiguration newDefaultConfiguration];
    }
    return self;
}

- (id)initWithLabel:(NSString *)label andConfiguration:(BFCellConfiguration *)configuration
{
    self = [self initWithLabel:label];
    if (self != nil) {
        self.config = configuration;
    }
    return self;
}


- (void)dealloc 
{
    [self.labelText release];
    [self.detailsText release];
    [self.config release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:[config reuseIdentifier]];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:[config style] reuseIdentifier:[config reuseIdentifier]] autorelease];
        [cell.textLabel setFont:[config font]];
        cell.textLabel.textAlignment = config.alignment;
        cell.textLabel.textColor = [config color];
        
        // allow unlimited number of lines for 
        // text, ensuring text wrapping
        cell.textLabel.numberOfLines = 0;
        
        if (![config isSelectable]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *accessory = [config accessory];
        if (accessory != nil)
            cell.imageView.image = accessory.image;
    }
    cell.textLabel.text = self.labelText;
    if (self.detailsText != nil)
        cell.detailTextLabel.text = detailsText;
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////////

@end
