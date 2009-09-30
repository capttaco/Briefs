//
//  BFTableViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/15/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>

//  Adapted from code seen on http://cocoawithlove.com/2008/12/heterogeneous-cells-in.html
// 
//  Originally created by Matt Gallagher on 27/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//


@interface BFTableViewController : UITableViewController
{
    NSArray *tableGroups;
}

@property (nonatomic, retain) NSArray *tableGroups;

- (void)updateAndReload;

@end
