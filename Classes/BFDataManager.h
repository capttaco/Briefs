//
//  BFDataManager.h
//  Briefs
//
//  Created by Rob Rhyne on 9/23/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFBriefcast.h"

#define kBFLocallyStoredBriefURLString  @"LOCALLY_STORED_BF"


@interface BFDataManager : NSObject
{
    NSMutableDictionary             *data_store;
    NSManagedObjectModel			*managedObjectModel;
    NSManagedObjectContext			*managedObjectContext;	    
    NSPersistentStoreCoordinator	*persistentStoreCoordinator;
    
    NSArray                         *knownBriefs;
    NSArray                         *knownBriefcasts;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel			*managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext			*managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;

@property (retain)                      NSMutableDictionary             *data_store;
@property (retain)                      NSArray                         *knownBriefs;
@property (retain)                      NSArray                         *knownBriefcasts;

// Access & Initialization
+ (BFDataManager *)sharedBFDataManager;
- (NSString *)documentDirectory;

- (void)load;
- (void)save;

// Briefs
- (NSArray *)listOfLocalBriefsWithExtension:(NSString *)extension;

// Briefcasts
- (NSArray *)listOfKnownBriefcasts;
- (void)addBriefcastInformation:(BFBriefcast *)briefcast;

@end
