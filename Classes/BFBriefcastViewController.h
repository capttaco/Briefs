//
//  BFBriefcastViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTableViewController.h"
#import "BFBriefcastEventDelegate.h"
#import "BFLoadingViewController.h"
#import "BriefcastRef.h"
#import "BFRemoteBriefViewController.h"

@interface BFBriefcastViewController : BFTableViewController <BFBriefcastEventDelegate, BFLoadingViewDelegate, BFRemoteBriefViewDelegate> 
{
    NSMutableArray          *enclosedBriefs;
    NSString                *channelTitle;
    NSString                *channelLink;
    NSString                *channelDescription;
    NSMutableData           *recievedData;
    
    NSString                *locationOfBriefcast;
    BriefcastRef            *briefcast;
    
    // IB Objects
    IBOutlet UILabel                    *titleLabel;
    IBOutlet UILabel                    *locationLabel;
    IBOutlet UIButton                   *buttonView;
    IBOutlet UIActivityIndicatorView    *spinner;

}

@property (nonatomic, retain) NSMutableArray    *enclosedBriefs;
@property (nonatomic, retain) NSString          *channelTitle;
@property (nonatomic, retain) NSString          *channelLink;
@property (nonatomic, retain) NSString          *channelDescription;
@property (nonatomic, retain) NSString          *locationOfBriefcast;
@property (nonatomic, retain) BriefcastRef      *briefcast;
@property (nonatomic, retain) NSMutableData     *recievedData;


- (IBAction)reloadBriefcast;


@end
