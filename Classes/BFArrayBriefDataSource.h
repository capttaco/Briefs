//
//  BFArrayBriefDataSource.h
//  Briefs
//
//  Created by Rob Rhyne on 3/28/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefDataSource.h"

@interface BFArrayBriefDataSource : NSObject <BFBriefDataSource>
{
    NSArray *backingArray;
}

- (id)initWithArray:(NSArray *)backing;

@end
