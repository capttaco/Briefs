//
//  BFBriefcast+CoreDataAdditions.h
//  Briefs
//
//  Created by Rob Rhyne on 3/10/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BriefcastRef.h"
#import "BFBriefcast.h"

@interface BFBriefcast (CoreDataAdditions)

- (id)initWithRef:(BriefcastRef *)aRef;
- (void)insertIntoManagedContext:(NSManagedObjectContext *)context;

@end
