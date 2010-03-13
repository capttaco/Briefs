//
//  BFBriefcastViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "BFTableViewController.h"
#import "BFRemoteBriefEventDelegate.h"
#import "BFLoadingViewController.h"
#import "BriefcastRef.h"

@interface BFBriefcastViewController : BFTableViewController <BFRemoteBriefEventDelegate, BFLoadingViewDelegate> 
{
    NSMutableArray  *enclosedBriefs;
    NSString        *channelTitle;
    NSString        *channelLink;
    NSString        *channelDescription;
    NSMutableData   *recievedData;
    
    NSString                *locationOfBriefcast;
    BriefcastRef            *briefcast;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) NSMutableArray    *enclosedBriefs;
@property (nonatomic, retain) NSString          *channelTitle;
@property (nonatomic, retain) NSString          *channelLink;
@property (nonatomic, retain) NSString          *channelDescription;
@property (nonatomic, retain) NSString          *locationOfBriefcast;
@property (nonatomic, retain) BriefcastRef      *briefcast;
@property (nonatomic, retain) NSMutableData     *recievedData;


@end
