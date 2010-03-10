//
//  BFBriefcast+CoreDataAdditions.m
//  Briefs
//
//  Created by Rob Rhyne on 3/10/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFBriefcast+CoreDataAdditions.h"


@implementation BFBriefcast (CoreDataAdditions)

- (id)initWithRef:(BriefcastRef *)aRef
{
    self = [self initWithName:[aRef title] andURL:[aRef fromURL]];
    if (self != nil) {
        self.description = [aRef desc];
    }
    
    return self;
}

- (void)insertIntoManagedContext:(NSManagedObjectContext *)context
{
    BriefcastRef *ref = (BriefcastRef *) [NSEntityDescription insertNewObjectForEntityForName:@"BriefcastRef" 
                                                                       inManagedObjectContext:context];
    
    [ref setFromURL:self.url];
    [ref setTitle:self.title];
    [ref setDesc:self.description];
}

@end
