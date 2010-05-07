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
    return [[[BFBriefInfo alloc] initWithDictionary:dictionary atPath:path] autorelease];
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
        
        pathToBrieflist = path;
        author  = [dictionary objectForKey:@"author" orDefaultValue:@"None provided."];
        desc    = [dictionary objectForKey:@"desc" orDefaultValue:@"None provided."];
        
        NSString *defaultTitle = [path stringByReplacingOccurrencesOfString:@".brieflist" withString:@""];
        
        // test for ($0)$1 file name
        NSArray *fileNameComponents = [defaultTitle componentsSeparatedByString:@")"];
        if ([fileNameComponents count] > 1)
            defaultTitle = [fileNameComponents objectAtIndex:1];
        else {
            defaultTitle = [fileNameComponents objectAtIndex:0];
        }
        title = [dictionary objectForKey:@"title" orDefaultValue:defaultTitle];
    }
    return self;
}

- (BriefRef *)insertIntoManagedContext:(NSManagedObjectContext *)context
{
    BriefRef *ref = (BriefRef *) [NSEntityDescription insertNewObjectForEntityForName:@"BriefRef"                                                                     inManagedObjectContext:context];
    
    return [self mergeInfoIntoBrief:ref];
}

- (BriefRef *)mergeInfoIntoBrief:(BriefRef *)ref
{
    [ref setFilePath:pathToBrieflist];
    [ref setTitle:title];
    [ref setTotalNumberOfScenes:[NSNumber numberWithInt:numberOfScenes]];
    
    // TODO: add author, desc information
    [ref setAuthor:author];
    [ref setDesc:desc];
    
    return ref;
}

@end
