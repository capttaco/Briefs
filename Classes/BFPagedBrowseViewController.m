//
//  BFPagedBrowseViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.


#import "BFPagedBrowseViewController.h"

@interface BFPagedBrowseViewController (PrivateMethods)

- (CGFloat)totalWidthOfScrollView;
- (CGFloat)widthOfPage:(UIScrollView *)scrollView;
- (CGPoint)pageOriginAtIndex:(NSInteger)index;
- (CGFloat)fractionalPageAtCurrentScroll:(UIScrollView *)scrollView;

- (void)applyNewIndex:(NSInteger)newIndex pageController:(BFPreviewBriefViewController *)pageController;
- (BOOL)isPageAlreadyAssigned:(NSInteger)index;
- (BFPreviewBriefViewController *)findFarthestFromIndex:(NSInteger)index;

- (void)initializePagedView;


@end



@implementation BFPagedBrowseViewController
@synthesize dataSource, pages;


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController methods

- (id)initWithDataSource:(id<BFBriefDataSource>)ref
{
    return [self initWithDataSource:ref isLocal:NO];
}

- (id)initWithDataSource:(id<BFBriefDataSource>)ref isLocal:(BOOL)local
{
    if (self = [super initWithNibName:@"BFPagedBrowseViewController" bundle:nil]) {
        self.dataSource = ref;
        
        if (local == YES) self.title = @"Built-in Briefs";
        else self.title = @"Briefs";
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self initializePagedView];
    [self refresh:dataSource gotoIndex:0];
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [self.pages release];
    [self.dataSource release];
    [super dealloc];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollView Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	CGFloat currentPageAsFraction = [self fractionalPageAtCurrentScroll:pagedHorizontalView];
    
	NSInteger lowerLimit = floor(currentPageAsFraction);
	NSInteger upperLimit = lowerLimit + 1;
    
    if (![self isPageAlreadyAssigned:lowerLimit])
        [self applyNewIndex:lowerLimit pageController:[self findFarthestFromIndex:lowerLimit]];
    
    if (![self isPageAlreadyAssigned:upperLimit]) 
        [self applyNewIndex:upperLimit pageController:[self findFarthestFromIndex:upperLimit]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    CGFloat currentPageAsFraction = [self fractionalPageAtCurrentScroll:pagedHorizontalView];
    currentIndex = lround(currentPageAsFraction);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
    [self scrollViewDidEndScrollingAnimation:newScrollView];
    pageControl.currentPage = currentIndex;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scrolling Utility methods

- (void)refresh:(id<BFBriefDataSource>)source gotoIndex:(NSInteger)pageIndex
{
    // REFRESH
    dataSource = source;
    pagedHorizontalView.contentSize = CGSizeMake([self totalWidthOfScrollView], pagedHorizontalView.frame.size.height);
	pageControl.numberOfPages = [dataSource numberOfRecords];
	
    
    // if index is out of bounds, got to beginning,
    // then bail out.
    if (pageIndex < 0 || pageIndex >= [dataSource numberOfRecords]) {
        [self scrollToNewIndex:0 notifyPageControl:YES];
        return;
    }
        
    
    // load pages around current view
    int start = (pageIndex - 1 >= 0) ? pageIndex - 1 : pageIndex;
    int finish = (pageIndex == 0) ? pageIndex + 2 : pageIndex + 1;

    
    // PAGE LOAD
    for (int index = start; index <= finish; index++) {
        [self applyNewIndex:index pageController:[self.pages objectAtIndex:(index-start)]];
    }
    
    // SCROLL TO PAGE
    [self scrollToNewIndex:pageIndex notifyPageControl:YES];
}

- (void)applyNewIndex:(NSInteger)newIndex pageController:(BFPreviewBriefViewController *)pageController
{
    // make sure the data source is current for
    // the page controller
    pageController.dataSource = dataSource;
    
	NSInteger pageCount = [dataSource numberOfRecords];
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds) {
        pageController.view.alpha = 0.0f;
        
        CGRect pageFrame = pageController.view.frame;
		pageFrame.origin = [self pageOriginAtIndex:newIndex];
		pageController.view.frame = pageFrame;
        
        // Fade the view in
        [UIView beginAnimations:@"fade PageController" context:nil];
        pageController.view.alpha = 1.0f;

	}
    
	else {
        // Fade the view out
        [UIView beginAnimations:@"fade PageController" context:nil];
        pageController.view.alpha = 0.0f;
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    [UIView commitAnimations];
    pageController.pageIndex = newIndex;
}

- (IBAction)changePage:(id)sender
{
	NSInteger pageIndex = pageControl.currentPage;
    [self scrollToNewIndex:pageIndex notifyPageControl:NO];
}

- (void)scrollToNewIndex:(NSInteger)index notifyPageControl:(BOOL)notify
{
    // update the scroll view to the appropriate page
    CGRect frame = pagedHorizontalView.frame;
    frame.origin = [self pageOriginAtIndex:index];
    [pagedHorizontalView scrollRectToVisible:frame animated:YES];
    
    if (notify) {
        pageControl.currentPage = index;
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private methods

- (CGFloat)totalWidthOfScrollView
{
    NSInteger totalNumberOfPages = ([dataSource numberOfRecords] < 1) ? 1 : [dataSource numberOfRecords];
    return (pagedHorizontalView.frame.size.width) * totalNumberOfPages;
}

- (CGFloat)widthOfPage:(UIScrollView *)scrollView
{
    return scrollView.frame.size.width;
}

- (CGPoint)pageOriginAtIndex:(NSInteger)index
{
    return CGPointMake((pagedHorizontalView.frame.size.width) * index + 10.0f, 0);
}

- (CGFloat)fractionalPageAtCurrentScroll:(UIScrollView *)scrollView
{
    return scrollView.contentOffset.x / [self widthOfPage:scrollView];
}

- (BOOL)isPageAlreadyAssigned:(NSInteger)index
{
    for (BFPreviewBriefViewController *controller in self.pages) {
        if (controller.pageIndex == index)
            return YES;
    }
    
    return NO;
}

- (BFPreviewBriefViewController *)findFarthestFromIndex:(NSInteger)index
{
    BFPreviewBriefViewController *farthestFrom = nil;
    int distanceToIndex = 0;
    for (BFPreviewBriefViewController *controller in self.pages) {
        int distance = abs(controller.pageIndex - index);
        if (distance > distanceToIndex) {
            distanceToIndex = distance;
            farthestFrom = controller;
        }
    }
    
    return farthestFrom;
}

- (void)initializePagedView
{
//    self.title = @"Briefs";
    
    // Initialize page views
    self.pages = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i < 3; i++) {
        BFPreviewBriefViewController *controller = [[BFPreviewBriefViewController alloc] init];
        controller.dataSource = dataSource;
        controller.parentNavigationController = self.navigationController;
        [pagedHorizontalView addSubview:controller.view];
        
        [self.pages addObject:controller];
        [controller release];
    }
    
    // initialize the scroll view
    pagedHorizontalView.clipsToBounds = NO;
    pagedHorizontalView.showsHorizontalScrollIndicator = NO;
    pagedHorizontalView.contentOffset = CGPointMake(0, 0);
}


///////////////////////////////////////////////////////////////////////////////

@end
