//
//  BFBriefInfo.h
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BriefRef.h"

@interface BFBriefInfo : NSObject 
{
    NSString    *title;
    NSString    *desc;
    NSString    *author;
    NSString    *pathToBrieflist;
    int         numberOfScenes;
}

+ (id)infoForBriefData:(NSDictionary *)dictionary atPath:(NSString *)path;
+ (id)infoForBriefAtPath:(NSString *)pathToData;

- (id)initWithDictionary:(NSDictionary *)dictionary atPath:(NSString *)path;
- (BriefRef *)insertIntoManagedContext:(NSManagedObjectContext *)context;
- (BriefRef *)mergeInfoIntoBrief:(BriefRef *)ref;

@end
