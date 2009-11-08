//
//  BFLabelConfiguration.h
//  Briefs
//
//  Created by Rob Rhyne on 10/4/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFCellConfiguration : NSObject 
{
    UIColor     *color;
    UIFont      *font;
    UIColor     *detailsColor;
    UIFont      *detailsFont;
    UIImage     *accessory;
    NSString    *identifier;
    
    BOOL isSelectable;
    UITableViewCellStyle style;
    UITextAlignment alignment;
    UITableViewCellAccessoryType accessoryType;
    
    
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIFont *font;

@property (nonatomic, retain) UIColor *detailsColor;
@property (nonatomic, retain) UIFont *detailsFont;
@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic) UITextAlignment alignment;
@property (nonatomic) BOOL isSelectable;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;

- (NSString *)reuseIdentifier;
- (void)setIdentifier:(NSString *)iden;
- (void)addAcessoryImage:(NSString *)path;
- (UIImageView *)accessory;


// Initializers
- (id)initWithColor:(UIColor *)col withFont:(UIFont *)face andStyle:(UITableViewCellStyle)cellStyle;
- (id)initSelectableWithColor:(UIColor *)col withFont:(UIFont *)face andStyle:(UITableViewCellStyle)cellStyle;

// Default Configurations
+ (id)newDefaultConfiguration;
+ (id)newDefaultSelectableConfiguration;
+ (id)newConfigWithSize:(CGFloat)size andColor:(UIColor *)theColor;
+ (id)newSelectableConfigWithSize:(CGFloat)size andColor:(UIColor *)theColor;

@end
