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

#define kBFDATAMANAGER_STORE_LOCATION    @"Briefs-data.plist"


@implementation BFDataManager
@synthesize data_store, knownBriefcasts, knownBriefs;

SYNTHESIZE_SINGLETON_FOR_CLASS(BFDataManager);

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization

- (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)load
{
    // load the file
    NSString *pathToDictionary = [[[NSBundle mainBundle] resourcePath] 
                                                                stringByAppendingFormat:@"/%@", kBFDATAMANAGER_STORE_LOCATION];
    self.data_store = [NSMutableDictionary dictionaryWithContentsOfFile: pathToDictionary];
    
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
            
            // check if installed prior
            if ([[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory:NO]) {
                
                // if it does exist, remove it
                // ==================================
                // This allows for new versions to be
                // loaded, when the user is testing 
                // in the simulator.
                
                if (![[NSFileManager defaultManager] removeItemAtPath:newPath error:&error])
                    NSLog(@"ERROR! - %@", error);
            }
            
            if(![[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newPath error:&error])
                NSLog(@"ERROR! - %@", error);
        }
    }
    
}

- (void)save
{
    // save the data store
    NSString *pathToDictionary = [[[NSBundle mainBundle] resourcePath] 
                                                                stringByAppendingFormat:@"/%@", kBFDATAMANAGER_STORE_LOCATION];
    if ([self.data_store writeToFile:pathToDictionary atomically:YES]) {
        NSLog(@"Successfully persisted briefs meta data file");
    }
    else {
        NSLog(@"Was unable to save out the briefs meta data");
    }
}

- (void)dealloc
{
    [self.knownBriefcasts release];
    [self.knownBriefs release];
    [self.data_store release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Briefs Methods

- (NSArray *)listOfLocalBriefsWithExtension:(NSString *)extension
{
    if (self.knownBriefs == nil) {
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self documentDirectory]];
        NSMutableArray *arrayOfLocals = [NSMutableArray array];
        
        NSString *next;
        while (next = [enumerator nextObject]) {
            if ([[next pathExtension] isEqualToString:extension]) {
                BFBriefCellController *controller = [[[BFBriefCellController alloc] initWithNameOfBrief:next] autorelease];
                [arrayOfLocals addObject:controller];
            }
        }
        self.knownBriefs = [NSArray arrayWithArray:arrayOfLocals];
    }
    return self.knownBriefs;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Briefcast Methods

- (NSArray *)listOfKnownBriefcasts
{
    if (self.knownBriefcasts == nil) {
        if (self.data_store == nil) {
            [self load];
        }
        NSArray *briefcastDescriptors = [self.data_store valueForKey:@"briefcasts"];
        NSMutableArray *briefcasts = [NSMutableArray arrayWithCapacity:[briefcastDescriptors count]];
        for (NSDictionary *descriptor in briefcastDescriptors) {
            BFBriefcast *bcast = [[[BFBriefcast alloc] initWithDictionary:descriptor] autorelease]; 
            BFBriefcastCellController *controller = [[[BFBriefcastCellController alloc] initWithBriefcast:bcast] autorelease];
            [briefcasts addObject:controller];
        }
        self.knownBriefcasts = briefcasts;
    }
    
    return self.knownBriefcasts;
}

- (void)addBriefcastInformation:(BFBriefcast *)briefcast
{
    if (self.data_store != nil) {
        NSArray *briefcastDescriptors = [self.data_store valueForKey:@"briefcasts"];
        
        // add briefcast into data store
        [self.data_store setObject:[briefcastDescriptors arrayByAddingObject:[briefcast dictionary]] forKey:@"briefcasts"];
        self.knownBriefcasts = nil;
    }
}

@end
