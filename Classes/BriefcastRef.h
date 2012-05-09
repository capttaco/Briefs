//
//  BriefcastRef.h
//  Briefs
//
//  Created by Rob Rhyne on 3/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BriefRef;

@interface BriefcastRef :  NSManagedObject  
{
}

@property (nonatomic) NSDate * dateLastRefresh;
@property (nonatomic) NSString * fromURL;
@property (nonatomic) NSString * desc;
@property (nonatomic) NSNumber * totalNumberOfBriefcasts;
@property (nonatomic) NSString * title;
@property (nonatomic) NSDate * dateLastOpened;
@property (nonatomic) NSSet* briefs;

@end


@interface BriefcastRef (CoreDataGeneratedAccessors)
- (void)addBriefsObject:(BriefRef *)value;
- (void)removeBriefsObject:(BriefRef *)value;
- (void)addBriefs:(NSSet *)value;
- (void)removeBriefs:(NSSet *)value;

@end

