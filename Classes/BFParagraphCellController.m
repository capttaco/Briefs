//
//  BFParagraphCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 11/2/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFParagraphCellController.h"


@implementation BFParagraphCellController

- (id)initWithBodyText:(NSString *)bodyText
{
    return [self initWithBodyText:bodyText andImage:nil];
}

- (id)initWithBodyText:(NSString *)bodyText andImage:(NSString *)path
{
    BFCellConfiguration *cellConfig = [BFCellConfiguration newDefaultConfiguration];
    cellConfig.font = [UIFont systemFontOfSize:15.0];
    cellConfig.color = [UIColor darkGrayColor];
    if (path != nil) [cellConfig addAcessoryImage:path];
    self = [super initWithLabel:[NSString stringWithFormat:@"%@\n",bodyText] andConfiguration:cellConfig];
    [cellConfig release];
    return self;
}

@end
