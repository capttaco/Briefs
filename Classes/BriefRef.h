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

@property (nonatomic, retain) NSDate * dateLastOpened;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * lastSceneOpened;
@property (nonatomic, retain) NSNumber * totalNumberOfScenes;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * dateLastDownloaded;
@property (nonatomic, retain) NSString * fromURL;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) BriefcastRef * briefcast;

@end



