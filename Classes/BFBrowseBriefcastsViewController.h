//
//  BFBrowseBriefsViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/12/10.
//  Copyright 2010 Digital Arch Design. All rights reserved.
//

#import "BFTableViewController.h"
#import "BFAddBriefcastViewController.h"


@interface BFBrowseBriefcastsViewController : BFTableViewController <BFAddBriefcastViewDelegate> 
{
}

- (IBAction)addBriefcast;

@end
