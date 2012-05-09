//
//  BFRefreshBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFCellController.h"
#import "BriefRef.h"
#import "BFLoadingViewController.h"
#import "BFSceneViewController.h"

@interface BFRefreshBriefCellController : NSObject<BFCellController, BFLoadingViewDelegate, BFSceneViewDelegate>
{
    IBOutlet UILabel    *name;
    IBOutlet UILabel    *desc;
    
    BriefRef            *brief;
    UITableViewCell     *cell;
    UINavigationController  *__unsafe_unretained navigation;
}

@property (nonatomic) BriefRef      *brief;
@property (unsafe_unretained) UINavigationController   *navigation;

- (IBAction)updateBriefData;

- (id)initWithBrief:(BriefRef *)item;

@end
