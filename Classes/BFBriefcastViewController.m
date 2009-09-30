//
//  BFBriefcastViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastViewController.h"
#import "FeedParser.h"


@implementation BFBriefcastViewController

@synthesize table, refresh, channelTitle, channelLink, locationOfBriefcast;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UI Methods

- (IBAction)refreshBriefListing
{
    // TODO: Do something here.
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController overrides

- (void)viewDidLoad 
{
    [super viewDidLoad];

    if (locationOfBriefcast != nil) {
        // Load Briefcast url
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self locationOfBriefcast]]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    }
    
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = [[NSError alloc] init];
    FPFeed *feed = [FPParser parsedFeedWithData:data error:&error];
    
    [self channelTitle].text = [feed title];
    [self channelLink].text = [[feed link] href];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: do something here.
    // Boom, we failed.
    NSLog(@"Boom, the briefcast load failed.");
}

///////////////////////////////////////////////////////////////////////////////

@end
