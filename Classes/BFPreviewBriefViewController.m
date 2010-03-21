//
//  BFPreviewBriefViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefViewController.h"


@implementation BFPreviewBriefViewController
@synthesize dataSource, pageIndex;

- (id)init
{
    if (self = [super initWithNibName:@"BFPreviewBriefViewController" bundle:nil]) {
    }
    
    return self;
}


- (void)setPageIndex:(NSInteger)newPageIndex
{
	pageIndex = newPageIndex;
	
	if (pageIndex >= 0 && pageIndex < [dataSource numberOfRecords])
	{
        BriefRef *ref = [dataSource dataForIndex:pageIndex];
        previewView.titleLabel.text = [ref title];
        previewView.sceneView.image = [UIImage imageNamed:@"ks1.png"];
	}
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self.view addSubview:previewView];
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


- (void)dealloc {
    [super dealloc];
}


@end
