//
//  BFRefreshBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFCellController.h"
#import "BriefRef.h"

@interface BFRefreshBriefCellController : NSObject<BFCellController>
{
    IBOutlet UILabel    *name;
    IBOutlet UILabel    *desc;
    
    BriefRef            *brief;
    UITableViewCell     *cell;
}

@property (nonatomic, retain) BriefRef *brief;

- (IBAction)updateBriefData;

- (id)initWithBrief:(BriefRef *)item;

@end
