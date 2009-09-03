//
//  BFBrowseViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 8/31/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface BFBrowseViewController : UITableViewController 
{
  NSDictionary *knownBriefs;
}

@property (nonatomic, retain) NSDictionary *knownBriefs;

- (NSArray *)localBriefLocations;
- (NSArray *)storedBriefcastLocations;


@end
