//
//  BFAddBriefcastViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/21/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFTableViewController.h"

@protocol BFAddBriefcastViewDelegate;


@interface BFAddBriefcastViewController : BFTableViewController 
{
  id <BFAddBriefcastViewDelegate> delegate;
}

@property (nonatomic, assign) id <BFAddBriefcastViewDelegate> delegate;

- (IBAction)save;
- (IBAction)cancel;

@end


@protocol BFAddBriefcastViewDelegate

- (void)addViewController:(BFAddBriefcastViewController *)controller didFinishWithSave:(BOOL)save;

@end
