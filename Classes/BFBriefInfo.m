//
//  BFBriefInfo.m
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefInfo.h"
#import "NSDictionary+BFAdditions.h"


@implementation BFBriefInfo

+ (id)infoForBriefData:(NSDictionary *)dictionary atPath:(NSString *)path
{
    return [[BFBriefInfo alloc] initWithDictionary:dictionary atPath:path];
}

+ (id)infoForBriefAtPath:(NSString *)pathToData
{
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:pathToData];
    return [BFBriefInfo infoForBriefData:data atPath:pathToData];
}

- (id)initWithDictionary:(NSDictionary *)dictionary atPath:(NSString *)path
{
    self = [super init];
    if (self != nil) {
        NSArray *scenes = [dictionary objectForKey:@"scenes"];
        numberOfScenes = (scenes != nil) ? [scenes count] : 0;
        [scenes release];
        
        pathToBrieflist = path;
        author  = [dictionary objectForKey:@"author" orDefaultValue:@"None"];
        desc    = [dictionary objectForKey:@"desc" orDefaultValue:@"None"];
        
        NSString *defaultTitle = [path stringByReplacingOccurrencesOfString:@".brieflist" withString:@""];
        title = [dictionary objectForKey:@"title" orDefaultValue:defaultTitle];
    }
    return self;
}

- (BriefRef *)insertIntoManagedContext:(NSManagedObjectContext *)context
{
    BriefRef *ref = (BriefRef *) [NSEntityDescription insertNewObjectForEntityForName:@"BriefRef"                                                                     inManagedObjectContext:context];
    
    [ref setFilePath:pathToBrieflist];
    [ref setTitle:title];
    [ref setTotalNumberOfScenes:[NSNumber numberWithInt:numberOfScenes]];
    
    // TODO: add author, desc information
    
    return ref;
}

@end
