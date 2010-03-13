//
//  BFAddBriefcastCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFButtonCellController.h"

@interface BFAddBriefcastCellController : BFButtonCellController 
{
    id delegate;
}

@property (nonatomic, retain) id delegate;

@end
