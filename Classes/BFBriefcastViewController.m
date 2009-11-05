//
//  BFBriefcastViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/14/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefcastViewController.h"
#import "FeedParser.h"
#import "BFTitleCellController.h"
#import "BFLabelCellController.h"
#import "BFParagraphCellController.h"
#import "BFHeaderCellController.h"


@implementation BFBriefcastViewController

@synthesize channelTitle, channelLink, channelDescription, locationOfBriefcast, enclosedBriefs;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UI Methods


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFTableViewController overrides

- (void)constructTableGroups
{
    if (self.channelTitle != nil) {
        NSMutableArray *groups = [NSMutableArray arrayWithCapacity:[self.enclosedBriefs count]+1];
        
        
        // Briefcast Information
        // =============================================
        // The details, & description views
        
        NSArray *briefsData = [NSArray arrayWithObjects: 
                               [[[BFTitleCellController alloc] initWithTitle:self.channelTitle] autorelease],
                               [[[BFHeaderCellController alloc] initWithHeader:self.channelLink] autorelease],
                               [[[BFParagraphCellController alloc] initWithBodyText:self.channelDescription andImage:@"37-suitcase.png"] autorelease],
                               nil];
        //self.tableGroups = [NSArray arrayWithObjects:briefsData, nil];
        [groups addObject:briefsData];
        
        
        // Enclosed Briefs
        // =============================================
        // Display the info on the enclosed briefs, 
        // including links to download locally
        
        for (FPItem *item in self.enclosedBriefs) {
            NSArray *itemInfo = [NSArray arrayWithObjects:
                                 [[[BFTitleCellController alloc] initWithTitle:item.title] autorelease],
//                                 [[[BFHeaderCellController alloc] initWithHeader:[item.pubDate description]] autorelease],
                                 [[[BFParagraphCellController alloc] initWithBodyText:item.content andImage:@"58-bookmark.png"] autorelease],
                                 nil];
            [groups addObject:itemInfo];
        }
        
        self.tableGroups = [NSArray arrayWithArray:groups];
    }
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (locationOfBriefcast != nil) {
        // Display "loading..." message and a spinner
        self.title = @"Loading...";
        spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        spinner.hidesWhenStopped = YES;
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease];
        
        // Load Briefcast url
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self locationOfBriefcast]]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    }
}


- (void)dealloc 
{
    [self.channelLink release];
    [self.channelTitle release];
    [self.channelDescription release];
    [self.enclosedBriefs release];
    [self.locationOfBriefcast release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = [[[NSError alloc] init] autorelease];
    FPFeed *feed = [FPParser parsedFeedWithData:data error:&error];
    
    self.channelTitle = [feed title];
    self.channelLink = [[feed link] href];
    self.channelDescription = [feed feedDescription];    
    self.enclosedBriefs = [feed items];
    
    // Update the UI
    self.title = [NSString stringWithFormat:@"%i Briefs", [[feed items] count]];
    [super updateAndReload];
    [spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: do something here.
    // Boom, we failed.
    NSLog(@"Boom, the briefcast load failed.");
}

///////////////////////////////////////////////////////////////////////////////

@end
