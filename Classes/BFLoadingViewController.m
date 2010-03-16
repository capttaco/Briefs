//
//  BFLoadingViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFLoadingViewController.h"


@implementation BFLoadingViewController
@synthesize delegate, locationOfRequest, data;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSView & NSObject Methods

- (void)viewDidLoad
{
    // Setup slider to be styled as a progress view.
    CGRect sliderFrame = progressSlider.frame;
    progressSlider.frame = CGRectMake(sliderFrame.origin.x, sliderFrame.origin.y, sliderFrame.size.width, 12.0f);
    
    progressSlider.backgroundColor = [UIColor clearColor];  
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"pop-slider-fg.png"]
                                stretchableImageWithLeftCapWidth:6.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"pop-slider-blank.png"]
                                 stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [progressSlider setThumbImage:nil forState:UIControlStateNormal];
    [progressSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [progressSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];

}

- (void)dealloc 
{
    [self.data release];
    [self.locationOfRequest release];
    [super dealloc];
}

- (IBAction)dismissView
{
    if (delegate)
        [delegate loadingView:self shouldDismissView:shouldAnimate];
}

- (IBAction)dismissViewWithAction
{
    if (delegate)
        [delegate loadingView:self shouldDismissViewWithAction:shouldAnimate];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection API

- (void)load:(NSString *)location withInitialStatus:(NSString *)status animated:(BOOL)animate
{
    [self load:location withInitialStatus:status action:nil animated:animate];
}

- (void)load:(NSString *)location withInitialStatus:(NSString *)status action:(NSString *)actionText animated:(BOOL)animate
{
    shouldAnimate = animate;
    safeToClose = NO;
    self.locationOfRequest = location;
    self.data = [[NSMutableData alloc] initWithLength:0];
    
    if (status)
        [statusLabel setText:status];
    
    if (actionText)
        [actionButton setTitle:actionText forState:UIControlStateNormal];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:location]];
    connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];   
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    expectedSizeOfResponse = [response expectedContentLength];
    imageView.alpha = 0.05;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nextData
{
    [self.data appendData:nextData];
    
    [statusLabel setText:@"Receiving Data"];
    float progressSoFar = [self.data length] / expectedSizeOfResponse;

    // animate stuff
    [UIView beginAnimations:@"fade-in Graphic" context:nil];
        [progressSlider setValue:progressSoFar animated:YES];
        imageView.alpha = progressSoFar > 0.05 ? progressSoFar: 0.05;
    [UIView commitAnimations];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [statusLabel setText:@"Download Complete"];
    [self.delegate loadingView:self didCompleteWithData:self.data];
    [actionButton setEnabled:YES];
    safeToClose = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [statusLabel setText:@"Oops, an error occured."];
    [self.delegate loadingView:self didNotCompleteWithError:error];
    safeToClose = YES;
}

///////////////////////////////////////////////////////////////////////////////


@end
