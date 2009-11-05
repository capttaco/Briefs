//
//  BFHeaderCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 11/3/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"


@interface BFHeaderCellController : NSObject<BFCellController>
{
    NSString *headerText;
}

@property (nonatomic, retain) NSString *headerText;


- (id)initWithHeader:(NSString *)header;

@end
