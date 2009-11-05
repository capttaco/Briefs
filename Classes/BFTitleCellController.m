//
//  BFTitleCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 10/4/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTitleCellController.h"


@implementation BFTitleCellController

- (id)initWithTitle:(NSString *)titleText
{
    BFCellConfiguration *cellConfig = [BFCellConfiguration newDefaultConfiguration];
    cellConfig.font = [UIFont boldSystemFontOfSize:19.0];
    self = [super initWithLabel:titleText andConfiguration:cellConfig];
    return self;
}

- (id)initWithTitle:(NSString *)titleText andLabel:(NSString *)label
{
    self = [self initWithTitle:titleText];
    if (self != nil) {
        self.detailsText = label;
        self.config.style = UITableViewCellStyleSubtitle;
    }
    return self;
}

@end
