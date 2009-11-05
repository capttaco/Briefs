//
//  BFTitleCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 10/4/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFLabelCellController.h"

@interface BFTitleCellController : BFLabelCellController 
{
}

- (id)initWithTitle:(NSString *)titleText;
- (id)initWithTitle:(NSString *)titleText andLabel:(NSString *)label;

@end
