//
//  BFActorView.h
//  Briefs
//
//  Created by Rob Rhyne on 8/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFActor.h"

@interface BFActorView : UIImageView {
    BFActor *actor;
}

@property (nonatomic, retain) BFActor *actor;

// initialization
- (id)initWithActor:(BFActor *)source;

// action handling
- (void)executeAction:(NSString *)action;

@end
