//
//  BFDataManager.h
//  Briefs
//
//  Created by Rob Rhyne on 9/23/09.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefcast.h"
#import "BriefcastRef.h"
#import "BriefRef.h"
#import "BFBriefDataSource.h"

#define kBFLocallyStoredBriefURLString        @"LOCALLY_STORED_BF"

typedef enum {
    BFDataManagerSortByDateOpened,
    BFDataManagerSortByDateDownloaded,
}  BFDataManagerSortType;



@interface BFDataManager : NSObject
{
    NSManagedObjectModel			*managedObjectModel;
    NSManagedObjectContext			*managedObjectContext;	    
    NSPersistentStoreCoordinator	*persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel			*managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext			*managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;


// Access & Initialization
+ (BFDataManager *)sharedBFDataManager;
- (NSString *)documentDirectory;

- (void)load;
- (void)save;


// Data Access API
- (BriefcastRef *)localBriefcastRefMarker;

// Collection Access
- (NSArray *)allBriefcastsSortedAs:(BFDataManagerSortType)typeOfSort;
- (NSArray *)briefsFromBriefcast:(BriefcastRef *)briefcast sortedAs:(BFDataManagerSortType)typeOfSort;
- (id<BFBriefDataSource>)allBriefsSortedAs:(BFDataManagerSortType)typeOfSort;

// Singleton Access
- (BriefRef *)findBriefUsingURL:(NSString *)url;


// Add & Remove Data API
- (BriefRef *)addBriefAtPath:(NSString *)path usingData:(NSData *)data fromURL:(NSString *)url;
- (void)addBriefcastInformation:(BFBriefcast *)briefcast;

- (void)removeBrief:(BriefRef *)brief;
- (void)removeBriefcast:(BriefcastRef *)briefcast;

@end
