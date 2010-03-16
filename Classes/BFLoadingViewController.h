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
    //IBOutlet UIActivityIndicatorView    *spinner;
    IBOutlet UILabel            *statusLabel;
    IBOutlet UISlider           *progressSlider;
    IBOutlet UIImageView        *imageView;
    IBOutlet UIButton           *cancelButton;
    IBOutlet UIButton           *actionButton;
    
    id<BFLoadingViewDelegate>   delegate;
    NSURLConnection             *connection;
    NSMutableData               *data;
    NSString                    *locationOfRequest;
    long long                   expectedSizeOfResponse;
    BOOL                        safeToClose;
    BOOL                        shouldAnimate;
}

@property (nonatomic, assign) id            delegate;
@property (nonatomic, retain) NSString      *locationOfRequest;
@property (nonatomic, retain) NSMutableData *data;

// Connection API
- (void)load:(NSString *)location withInitialStatus:(NSString *)status animated:(BOOL)animate;
- (void)load:(NSString *)location withInitialStatus:(NSString *)status action:(NSString *)actionText animated:(BOOL)animate;

- (IBAction)dismissView;
- (IBAction)dismissViewWithAction;

@end

@protocol BFLoadingViewDelegate

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data;
- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error;
- (void)loadingView:(BFLoadingViewController *)controller shouldDismissView:(BOOL)animate;
- (void)loadingView:(BFLoadingViewController *)controller shouldDismissViewWithAction:(BOOL)animate;

@end