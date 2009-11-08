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

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [label release];
    [spinner release];
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    
    if (numTaps >= 1 && safeToClose) {
        [self.delegate loadingView:self shouldCloseView:YES];
    }
    
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection API

- (void)load:(NSString *)location withInitialStatus:(NSString *)status animated:(BOOL)animate
{
    safeToClose = NO;
    self.locationOfRequest = location;
    self.data = [[NSMutableData alloc] initWithLength:0];
    
    [label setText:status];
    [spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:location]];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];    
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nextData
{
    [self.data appendData:nextData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [label setText:@"Download Complete"];
    [spinner stopAnimating];
    
    [self.delegate loadingView:self didCompleteWithData:self.data];
    safeToClose = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Boom, we failed.
    NSLog(@"Boom, the URL load failed.");
    [self.delegate loadingView:self didNotCompleteWithError:error];
    safeToClose = YES;
}

///////////////////////////////////////////////////////////////////////////////


@end
