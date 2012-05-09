//
//  BriefRef.h
//  Briefs
//
//  Created by Rob Rhyne on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BriefcastRef;

@interface BriefRef :  NSManagedObject  
{
}

@property (nonatomic) NSDate * dateLastOpened;
@property (nonatomic) NSString * author;
@property (nonatomic) NSNumber * lastSceneOpened;
@property (nonatomic) NSNumber * totalNumberOfScenes;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * desc;
@property (nonatomic) NSDate * dateLastDownloaded;
@property (nonatomic) NSString * fromURL;
@property (nonatomic) NSString * filePath;
@property (nonatomic) BriefcastRef * briefcast;

@end



