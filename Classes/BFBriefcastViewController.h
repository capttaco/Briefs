//
//  BFBriefcastViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface BFBriefcastViewController : UIViewController {
    IBOutlet UITableView *table;
    IBOutlet UIButton *refresh;
    IBOutlet UILabel *channelTitle;
    IBOutlet UILabel *channelLink;
    
    NSString *locationOfBriefcast;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *refresh;
@property (nonatomic, retain) IBOutlet UILabel *channelTitle;
@property (nonatomic, retain) IBOutlet UILabel *channelLink;

@property (nonatomic, retain) NSString *locationOfBriefcast;


- (IBAction)refreshBriefListing; 

@end
