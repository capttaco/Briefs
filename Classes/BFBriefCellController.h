//
//  BFBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"
#import "BriefRef.h"


@interface BFBriefCellController : NSObject<BFCellController> 
{
//    NSString *brief;
    BriefRef *brief;
}

//@property (nonatomic, retain) NSString *brief;
@property (nonatomic, retain) BriefRef *brief;

- (id)initWithNameOfBrief:(BriefRef *)name;

@end
