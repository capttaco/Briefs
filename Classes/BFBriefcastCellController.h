//
//  BFBriefcastCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFCellController.h"
#import "BriefcastRef.h"

@interface BFBriefcastCellController : NSObject<BFCellController> 
{
    IBOutlet UILabel    *titleLabel;
    IBOutlet UILabel    *descLabel;
    
    BriefcastRef            *briefcast;
    UINavigationController  *__unsafe_unretained delegate;
}

@property  BriefcastRef *briefcast;
@property (unsafe_unretained) UINavigationController *delegate;

- (id)initWithBriefcast:(BriefcastRef *)bcast;

@end
