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

#import "BriefcastRef.h"
#import "BriefRef.h"

#define kBFDataManagerStoreLocation    @"Briefs.sqlite"


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
                    BriefRef *briefRef = (BriefRef *)[NSEntityDescription insertNewObjectForEntityForName:@"BriefRef" inManagedObjectContext:[self managedObjectContext]];
                    
                    // create reference object for database
                    [briefRef setFromURL:kBFLocallyStoredBriefURLString];
                    [briefRef setFilePath:next];
                    [briefRef setTitle:[next stringByReplacingOccurrencesOfString:@".brieflist" withString:@""]];
                    
                    // Save the context
                    if (![managedObjectContext save:&error]) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    }  
                }
                
                else
                    // If not, throw an error, dude.
                    NSLog(@"ERROR! - %@", error);
            }
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
#pragma mark Briefs Methods

- (NSArray *)listOfLocalBriefsWithExtension:(NSString *)extension
{
    NSMutableArray *arrayOfLocals = [NSMutableArray array];
    
    // Fetch Data from the database
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"BriefRef" inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[self managedObjectContext]executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Boom! Handle the error.
        NSLog(@"There was a problem retrieving the listing of Briefs");
	}
	
    else {
        for (BriefRef *ref in mutableFetchResults) {
            BFBriefCellController *controller = [[[BFBriefCellController alloc] initWithNameOfBrief:ref] autorelease];
            [arrayOfLocals addObject:controller];
        }
    }
    
	[mutableFetchResults release];
	[request release];
    
    return arrayOfLocals;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Briefcast Methods

- (NSArray *)listOfKnownBriefcasts
{
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
	}
	
    else {
        for (BriefcastRef *ref in mutableFetchResults) {
            BFBriefcast *briefcast = [[[BFBriefcast alloc] initWithRef:ref] autorelease]; 
            BFBriefcastCellController *controller = [[[BFBriefcastCellController alloc] initWithBriefcast:briefcast] autorelease];

            [arrayOfBriefcasts addObject:controller];
        }
    }
    
	[mutableFetchResults release];
	[request release];
    
    return arrayOfBriefcasts;
}

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

@end
