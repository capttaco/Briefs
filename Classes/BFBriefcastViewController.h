//
//  BFBriefcastViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFTableViewController.h"

@interface BFBriefcastViewController : BFTableViewController {
    NSString *channelTitle;
    NSString *channelLink;
    NSString *channelDescription;
    NSMutableArray *enclosedBriefs;
    
    NSString *locationOfBriefcast;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) NSString *channelTitle;
@property (nonatomic, retain) NSString *channelLink;
@property (nonatomic, retain) NSString *channelDescription;
@property (nonatomic, retain) NSMutableArray *enclosedBriefs;
@property (nonatomic, retain) NSString *locationOfBriefcast;


@end
