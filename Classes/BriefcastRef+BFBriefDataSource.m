//
//  BriefcastRef+BFBriefDataSource.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BriefcastRef+BFBriefDataSource.h"


@implementation BriefcastRef (BriefDataSource)

- (int)numberOfRecords
{
    return [self.briefs count];
}

- (BriefRef *)dataForIndex:(NSInteger)index
{
    return [[self.briefs allObjects] objectAtIndex:index];
}


@end
