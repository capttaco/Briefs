//
//  BFBrowseBriefsViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/12/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFTableViewController.h"
#import "BFAddBriefcastViewController.h"


@interface BFBrowseBriefcastsViewController : BFTableViewController <BFAddBriefcastViewDelegate> 
{
}

- (IBAction)addBriefcast;

@end
