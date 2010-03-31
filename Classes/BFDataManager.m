//
//  BFDataManager.m
//  Briefs
//
//  Created by Rob Rhyne on 9/23/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFDataManager.h"
#import "SynthesizeSingleton.h"
#import "BFBriefCellController.h"
#import "BFBriefcastCellController.h"
#import "BFBriefcast+CoreDataAdditions.h"
#import "BFBriefInfo.h"
#import "BFArrayBriefDataSource.h"


#define kBFDataManagerStoreLocation    @"Briefs.sqlite"


@interface BFDataManager (PrivateMethods)

- (BriefRef *)addBriefAtPath:(NSString *)path fromURL:(NSString *)url;

@end


@implementation BFDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(BFDataManager);

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)locationOfDataStore
{
    return [[self documentDirectory] stringByAppendingPathComponent:kBFDataManagerStoreLocation];
}

- (void)load
{
    // Manually Installed Briefs
    // =====================================
    // look for manually installed Briefs
    // and copy them into the documents
    // directory with the rest of the briefs
    
    // TODO: Make this run on first load only.
    NSString *bundleDirectory = [[NSBundle mainBundle] resourcePath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:bundleDirectory];
    NSString *next;
    
    while (next = [enumerator nextObject]) {
        // Only move briefs
        if ([[next pathExtension] isEqualToString:@"brieflist"]) {
            NSString *newPath = [[self documentDirectory] stringByAppendingPathComponent:next];
            NSString *oldPath = [bundleDirectory stringByAppendingPathComponent:next];
            NSError *error = [[NSError alloc] init];
            
            // check if already installed,
            // do not add it to the datastore if it already exists.
            if (![[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory:NO]) {

                // copy the brief
                if([[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newPath error:&error]) {
                    
                    // if copy was successful, then add it to the database
                    BriefRef *briefRef = [self addBriefAtPath:next fromURL:kBFLocallyStoredBriefURLString];
                    [briefRef setBriefcast:[self localBriefcastRefMarker]];
                    
                    // Save the context
                    if (![managedObjectContext save:&error]) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    }
                    
                    
                }
                
                else
                    // If not, throw an error, dude.
                    NSLog(@"ERROR! - %@", error);
            }
            
            [error release];
        }
    }
    
}

- (void)save
{
    // TODO: Handle the error appropriately.
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext 
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel 
{	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath:[self locationOfDataStore]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Add / Insert API

- (void)addBriefcastInformation:(BFBriefcast *)briefcast
{    
    // Create and configure a new instance of the Event entity
	[briefcast insertIntoManagedContext:[self managedObjectContext]];
    
    // Save the context
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (BriefRef *)addBriefAtPath:(NSString *) path usingData:(NSData *)data fromURL:(NSString *)url
{
    NSString *destination = [[self documentDirectory] stringByAppendingPathComponent:path];
    
    // check to see if the brief already exists
    // if it doesn't, add it the regular way
    
    BriefRef *brief = [self findBriefUsingURL:url];
    if (brief == nil) {
        
        // check to see if a file exists at that path
        // if so, alter the incoming file path to avoid
        // overwriting data
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:NO]) {
            
            // Meh. This is ugly. Desperately needs refactoring.
            NSString *alteredURL = [[[url stringByReplacingOccurrencesOfString:@".brieflist" withString:@""]
                                    stringByReplacingOccurrencesOfString:@"http://" withString:@""] 
                                    stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            path = [NSString stringWithFormat:@"(%@)%@", alteredURL, path];
            NSString *newDestination = [[self documentDirectory] stringByAppendingPathComponent:path];
            
            [data writeToFile:newDestination atomically:YES];
        }
        else [data writeToFile:destination atomically:YES];
        
        return [self addBriefAtPath:path fromURL:url];
        
    }
    
    // else, get the reference and update it's download date
    else {
        [brief setDateLastDownloaded:[NSDate date]];
        [data writeToFile:destination atomically:YES];
        
        return brief;
    }
}

- (BriefRef *)addBriefAtPath:(NSString *)path fromURL:(NSString *)url
{
    // NOTE: This signature is only called by itself, when the
    //       brief is already stored on the file system.
    //       (i.e., only internally by the data manager)
    
    NSString *destination = [[self documentDirectory] stringByAppendingPathComponent:path];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:destination];
    
    BFBriefInfo *info = [BFBriefInfo infoForBriefData:dictionary atPath:path];
    BriefRef *newRef = [info insertIntoManagedContext:[self managedObjectContext]];
    [newRef setDateLastDownloaded:[NSDate date]];
    [newRef setFromURL:url];
    
    
    // Save the context
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return newRef;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Remove API

- (void)removeBrief:(BriefRef *)brief
{   
    NSError *error;
    
    // Remove the brief's binary file
    NSString *pathToBrief = [[self documentDirectory] stringByAppendingPathComponent:[brief filePath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToBrief isDirectory:NO]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:pathToBrief error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    // Remove it from the database
    [[self managedObjectContext] deleteObject:brief];
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)removeBriefcast:(BriefcastRef *)briefcast
{
    // cycle through existing briefs and delete
    // TODO: this should be an archive operation
    for (BriefRef *brief in [briefcast briefs]) {
        [self removeBrief:brief];
    }
    
    // delete the reference to the briefcast
    [[self managedObjectContext] deleteObject:briefcast];
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark High-Level API

- (NSArray *)allBriefcastsSortedAs:(BFDataManagerSortType)typeOfSort
{
    // TODO: implement sorting types
    
    NSMutableArray *arrayOfBriefcasts = [NSMutableArray array];
    
    // Fetch Data from the database
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BriefcastRef" inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Boom! Handle the error.
        NSLog(@"There was a problem retrieving the listing of Briefcasts");
        [request release];
        return nil;
	}
    
    for (BriefcastRef *ref in mutableFetchResults) {
        [arrayOfBriefcasts addObject:ref];
    }
    
	[mutableFetchResults release];
	[request release];
    
    return arrayOfBriefcasts;
}

- (NSArray *)briefsFromBriefcast:(BriefcastRef *)briefcast sortedAs:(BFDataManagerSortType)typeOfSort
{
    // TODO: implement sorting types
    return [[briefcast briefs] allObjects];
}

- (id<BFBriefDataSource>)allBriefsSortedAs:(BFDataManagerSortType)typeOfSort;
{
    // TODO: implement sorting types
    
    NSMutableArray *arrayOfBriefs = [NSMutableArray array];
    
    // Fetch Data from the database
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BriefRef" inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Boom! Handle the error.
        NSLog(@"There was a problem retrieving the listing of Briefs");
        [request release];
        return nil;
	}
    
    for (BriefRef *ref in mutableFetchResults) {
        [arrayOfBriefs addObject:ref];
    }
    
	[mutableFetchResults release];
	[request release];
    
    return [[BFArrayBriefDataSource alloc] initWithArray:arrayOfBriefs];
}

- (BriefcastRef *)localBriefcastRefMarker
{
    BriefcastRef *refToReturn;
    
    // Build predicate to locate marker
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fromURL == %@", kBFLocallyStoredBriefURLString];
    
    // Fetch Data from the database
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BriefcastRef" inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil || [mutableFetchResults count] <= 0) {
        
        // Marker does not exist
        BriefcastRef *ref = (BriefcastRef *) [NSEntityDescription insertNewObjectForEntityForName:@"BriefcastRef" 
                                                                           inManagedObjectContext:[self managedObjectContext]];
        
        [ref setFromURL:kBFLocallyStoredBriefURLString];
        [ref setTitle:@"Local Briefs"];
        [ref setDesc:@"This contains briefs that did not originate from a briefcast and are stored locally on the device."];
        
        // Save the context
        NSError *error;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        refToReturn = ref;
	}
    
    else refToReturn = (BriefcastRef *) [mutableFetchResults objectAtIndex:0];
    
    [request release];
    [mutableFetchResults release];
    
    return refToReturn;
    
}

- (BriefRef *)findBriefUsingURL:(NSString *)url
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fromURL == %@", url];
    
    // Fetch Data from the database
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BriefRef" inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil || [mutableFetchResults count] <= 0) {
        return nil;
	}
    
    BriefRef *refToReturn = (BriefRef *) [mutableFetchResults objectAtIndex:0];
    
    [request release];
    [mutableFetchResults release];
    
    return refToReturn;
}

- (NSDate *)briefFromURLWasInstalledOnDate:(NSString *)url
{
    BriefRef *ref = [self findBriefUsingURL:url];
    if (ref == nil) {
        return nil;
    }
    else return [ref dateLastDownloaded];
}


///////////////////////////////////////////////////////////////////////////////

@end
