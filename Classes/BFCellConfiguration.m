//
//  BFLabelConfiguration.m
//  Briefs
//
//  Created by Rob Rhyne on 10/4/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFCellConfiguration.h"


@implementation BFCellConfiguration

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Access Methods

@synthesize color, font, detailsColor, detailsFont, style, alignment, isSelectable, accessoryType;

- (NSString *)reuseIdentifier
{
    return identifier;
}

- (void)setIdentifier:(NSString *)iden
{
    identifier = iden;
}

- (BOOL)isSelectable
{
    return isSelectable;
}

- (UITableViewCellStyle)style
{
    return style;
}

- (void)addAcessoryImage:(NSString *)path
{
    accessory = [UIImage imageNamed:path];
}

- (UIImageView *)accessory
{
    if (accessory != nil)
        return [[UIImageView alloc] initWithImage:accessory];
    else return nil;
}

- (void)dealloc 
{
    [self.color release];
    [self.font release];
    [self.detailsColor release];
    [self.detailsFont release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Default Initializers

- (id)initWithColor:(UIColor *)col withFont:(UIFont *)face andStyle:(UITableViewCellStyle)tableStyle
{
    self = [super init];
    if (self != nil) {
        self.color = col;
        self.font = face;
        self.style = tableStyle;
        isSelectable = NO;
        
        self.detailsFont = nil;
        self.detailsColor = nil;
        self.alignment = UITextAlignmentLeft;
        accessory = nil;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (id)initSelectableWithColor:(UIColor *)col withFont:(UIFont *)face andStyle:(UITableViewCellStyle)tableStyle
{
    self = [self initWithColor:col withFont:face andStyle:tableStyle];
    if (self != nil) {
        isSelectable = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Default Configurations

+ (id)newDefaultConfiguration
{
    return [[BFCellConfiguration alloc] initWithColor:[UIColor blackColor] 
                                             withFont:[UIFont systemFontOfSize:17.0] 
                                             andStyle:UITableViewCellStyleDefault];
}

+ (id)newDefaultSelectableConfiguration
{
    return [[BFCellConfiguration alloc] initSelectableWithColor:[UIColor blackColor] 
                                                       withFont:[UIFont systemFontOfSize:17.0] 
                                                       andStyle:UITableViewCellStyleDefault]; 
}

+ (id)newConfigWithSize:(CGFloat)size andColor:(UIColor *)theColor
{
    return [[BFCellConfiguration alloc] initWithColor:theColor 
                                             withFont:[UIFont systemFontOfSize:size] 
                                             andStyle:UITableViewCellStyleDefault];
}

+ (id)newSelectableConfigWithSize:(CGFloat)size andColor:(UIColor *)theColor
{
    return [[BFCellConfiguration alloc] initSelectableWithColor:theColor
                                                       withFont:[UIFont systemFontOfSize:size] 
                                                       andStyle:UITableViewCellStyleDefault];
}

@end
