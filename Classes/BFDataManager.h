//
//  BFDataManager.h
//  Briefs
//
//  Created by Rob Rhyne on 9/23/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFBriefcast.h"

@interface BFDataManager : NSObject
{
  NSMutableDictionary *data_store;
  
  NSArray *knownBriefs;
  NSArray *knownBriefcasts;
}

@property (retain) NSMutableDictionary *data_store;
@property (retain) NSArray *knownBriefs;
@property (retain) NSArray *knownBriefcasts;

// Access & Initialization
+ (BFDataManager *)sharedBFDataManager;

- (void)load;
- (void)save;

// Briefs
- (NSArray *)listOfLocalBriefsWithExtension:(NSString *)extension;

// Briefcasts
- (NSArray *)listOfKnownBriefcasts;
- (void)addBriefcastInformation:(BFBriefcast *)briefcast;

@end
