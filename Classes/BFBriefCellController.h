//
//  BFBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"


@interface BFBriefCellController : NSObject<BFCellController> 
{
    NSString *brief;
}

@property (nonatomic, retain) NSString *brief;

- (id)initWithNameOfBrief:(NSString *)name;

@end
