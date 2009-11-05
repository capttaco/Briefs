//
//  BFParagraphCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 11/2/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFLabelCellController.h"

@interface BFParagraphCellController : BFLabelCellController
{
}

- (id)initWithBodyText:(NSString *)bodyText;
- (id)initWithBodyText:(NSString *)bodyText andImage:(NSString *)path;

@end
