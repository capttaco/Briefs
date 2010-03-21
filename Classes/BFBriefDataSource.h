//
//  BFBriefDataSource.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BriefRef.h"

@protocol BFBriefDataSource

- (int)numberOfRecords;
- (BriefRef *)dataForIndex:(NSInteger)index;

@end
