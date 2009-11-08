//
//  BFLoadingViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <UIKit/UIKit.h>

@protocol BFLoadingViewDelegate;

@interface BFLoadingViewController : UIViewController 
{
    IBOutlet UIActivityIndicatorView    *spinner;
    IBOutlet UILabel                    *label;
    
    id<BFLoadingViewDelegate>   delegate;
    NSMutableData               *data;
    NSString                    *locationOfRequest;
    BOOL                        safeToClose;
}

@property (nonatomic, assign) id            delegate;
@property (nonatomic, retain) NSString      *locationOfRequest;
@property (nonatomic, retain) NSMutableData *data;

// Connection API
- (void)load:(NSString *)location withInitialStatus:(NSString *)status animated:(BOOL)animate;


@end

@protocol BFLoadingViewDelegate

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data;
- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error;
- (void)loadingView:(BFLoadingViewController *)controller shouldCloseView:(BOOL)animated;

@end