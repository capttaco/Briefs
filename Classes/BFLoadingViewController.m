//
//  BFLoadingViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 4/5/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFLoadingViewController.h"


@implementation BFLoadingViewController
@synthesize delegate, locationOfRequest, data;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSView & NSObject Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (nibNameOrNil != nil) 
        return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    else
        return [super initWithNibName:@"BFLoadingViewController" bundle:nibBundleOrNil];
}

- (id)init 
{
    return [self initWithNibName:nil bundle:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (IBAction)dismissView
{
    if (delegate)
        [delegate loadingView:self shouldDismissView:YES];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection API

- (void)load:(NSString *)location withStatus:(NSString *)status
{
    [self load:location withStatus:status initialStatus:@"Connecting to Server..."];
}

- (void)load:(NSString *)location withStatus:(NSString *)status initialStatus:(NSString *)initial;
{
    self.locationOfRequest = location;
    self.data = [[NSMutableData alloc] initWithLength:0];
    workingStatus = status;
    
    if (initial)
        [statusLabel setText:initial];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:location]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    expectedSizeOfResponse = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nextData
{
    [self.data appendData:nextData];
    
    [statusLabel setText:workingStatus];
    float progressSoFar = [self.data length] / expectedSizeOfResponse;
    
    // animate stuff
    [progress setProgressValue:progressSoFar animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [statusLabel setText:@"Finished."];
    [self.delegate loadingView:self didCompleteWithData:self.data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [statusLabel setText:@"Oops, an error occured."];
    [self.delegate loadingView:self didNotCompleteWithError:error];
}

///////////////////////////////////////////////////////////////////////////////

@end








