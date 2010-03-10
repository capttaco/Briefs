//
//  BriefRef.h
//  Briefs
//
//  Created by Rob Rhyne on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BriefcastRef;

@interface BriefRef :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * fromURL;
@property (nonatomic, retain) NSNumber * lastSceneOpened;
@property (nonatomic, retain) NSNumber * totalNumberOfScenes;
@property (nonatomic, retain) NSDate * dateLastDownloaded;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSDate * dateLastOpened;
@property (nonatomic, retain) BriefcastRef * briefcast;

@end



