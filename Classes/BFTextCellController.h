//
//  BFTextCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"

@interface BFTextCellController : NSObject<BFCellController> 
{
    NSString *savedValue;
    NSString *labelText;
}

@property (nonatomic) NSString *savedValue;
@property (nonatomic) NSString *labelText;

- (id)initWithLabel:(NSString *)label;


@end
