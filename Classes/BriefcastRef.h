//
//  BriefcastRef.h
//  Briefs
//
//  Created by Rob Rhyne on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BriefRef;

@interface BriefcastRef :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * totalNumberOfBriefcasts;
@property (nonatomic, retain) NSDate * dateLastOpened;
@property (nonatomic, retain) NSDate * dateLastRefresh;
@property (nonatomic, retain) NSString * fromURL;
@property (nonatomic, retain) NSSet* briefs;

@end


@interface BriefcastRef (CoreDataGeneratedAccessors)
- (void)addBriefsObject:(BriefRef *)value;
- (void)removeBriefsObject:(BriefRef *)value;
- (void)addBriefs:(NSSet *)value;
- (void)removeBriefs:(NSSet *)value;

@end

