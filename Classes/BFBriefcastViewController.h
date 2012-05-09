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
    NSArray          *enclosedBriefs;
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

@property (nonatomic) NSArray    *enclosedBriefs;
@property (nonatomic) NSString          *channelTitle;
@property (nonatomic) NSString          *channelLink;
@property (nonatomic) NSString          *channelDescription;
@property (nonatomic) NSString          *locationOfBriefcast;
@property (nonatomic) BriefcastRef      *briefcast;
@property (nonatomic) NSMutableData     *recievedData;


- (IBAction)reloadBriefcast;


@end
