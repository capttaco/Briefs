//
//  BFRemoteLoadViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 4/5/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFProgressBar.h"

@protocol BFRemoteLoadViewDelegate;

@interface BFRemoteLoadViewController : UIViewController 
{
    // Outlets
    IBOutlet BFProgressBar  *progress;
    IBOutlet UILabel        *statusLabel;
    IBOutlet UIButton       *dismissButton;
    
    id<BFRemoteLoadViewDelegate>    delegate;
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


@protocol BFRemoteLoadViewDelegate

- (void)loadingView:(BFRemoteLoadViewController *)controller didCompleteWithData:(NSData *)data;
- (void)loadingView:(BFRemoteLoadViewController *)controller didNotCompleteWithError:(NSError *)error;
- (void)loadingView:(BFRemoteLoadViewController *)controller didCancelConnection:(NSString *)url;
- (void)loadingView:(BFRemoteLoadViewController *)controller shouldDismissView:(BOOL)animate;
                                                                                  
@end