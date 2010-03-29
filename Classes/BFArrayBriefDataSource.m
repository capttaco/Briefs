//
//  BFArrayBriefDataSource.m
//  Briefs
//
//  Created by Rob Rhyne on 3/28/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFArrayBriefDataSource.h"


@implementation BFArrayBriefDataSource

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (id)initWithArray:(NSArray *)backing
{
    if (self = [super init]) {
        backingArray = [backing retain];
    }
    
    return self;
}

- (void)dealloc
{
    [backingArray release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFBriefDataSource Compliance

- (int)numberOfRecords
{
    return [backingArray count];
}

- (BriefRef *)dataForIndex:(NSInteger)index
{
    return [backingArray objectAtIndex:index];
}

///////////////////////////////////////////////////////////////////////////////

@end
