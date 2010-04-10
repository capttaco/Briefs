//
//  BFLoadingViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 4/5/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFProgressBar.h"

@protocol BFLoadingViewDelegate;

@interface BFLoadingViewController : UIViewController 
{
    // Outlets
    IBOutlet BFProgressBar  *progress;
    IBOutlet UILabel        *statusLabel;
    IBOutlet UIButton       *dismissButton;
    
    id<BFLoadingViewDelegate>    delegate;
    NSString                        *workingStatus;
    
    // Internals
    NSURLConnection                 *connection;
    NSMutableData                   *data;
    NSString                        *locationOfRequest;
    long long                       expectedSizeOfResponse;
}

@property (nonatomic, assign) id            delegate;
@property (nonatomic, retain) NSString      *locationOfRequest;
@property (nonatomic, retain) NSMutableData *data;


- (void)load:(NSString *)location withStatus:(NSString *)status;
- (void)load:(NSString *)location withStatus:(NSString *)status initialStatus:(NSString *)initial;

- (IBAction)dismissView;

@end


@protocol BFLoadingViewDelegate

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data;
- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error;
- (void)loadingView:(BFLoadingViewController *)controller didCancelConnection:(NSString *)url;

@optional
- (void)loadingView:(BFLoadingViewController *)controller shouldDismissView:(BOOL)animate;
                                                                                  
@end