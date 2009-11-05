//
//  BFTitleCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 10/2/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"
#import "BFCellConfiguration.h"

@interface BFLabelCellController : NSObject<BFCellController> 
{
    NSString *labelText;
    NSString *detailsText;
    BFCellConfiguration *config;
}

@property (nonatomic, retain) NSString *labelText;
@property (nonatomic, retain) NSString *detailsText;
@property (nonatomic, retain) BFCellConfiguration *config;


- (id)initWithLabel:(NSString *)label;
- (id)initWithLabel:(NSString *)label andConfiguration:(BFCellConfiguration *)configuration;


@end
