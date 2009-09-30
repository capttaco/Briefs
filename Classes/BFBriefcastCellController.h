//
//  BFBriefcastCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"
#import "BFBriefcast.h"

@interface BFBriefcastCellController : NSObject<BFCellController> 
{
    BFBriefcast *briefcast;
}

@property (retain) BFBriefcast *briefcast;

- (id)initWithBriefcast:(BFBriefcast *)bcast;

@end
