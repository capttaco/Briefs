//
//  BFPreviewBriefViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefViewController.h"
#import "BFDataManager.h"
#import "BFPresentationDispatch.h"
#import "BFSceneViewController.h"
#import "BFSceneManager.h"
#import "BFPagedBrowseViewController.h"


@interface BFPreviewBriefViewController (PrivateMethods)

- (void)zoomViewDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context;
- (void)prepareInfoView:(BriefRef *)ref;
- (void)preparePreview:(BriefRef *)ref;

@end


@implementation BFPreviewBriefViewController
@synthesize dataSource, pageIndex, parentNavigationController;

- (id)init
{
    if (self = [super initWithNibName:@"BFPreviewBriefViewController" bundle:nil]) {
    }
    
    return self;
}


- (void)setPageIndex:(NSInteger)newPageIndex
{
    if ([infoView isDescendantOfView:self.view]) {
        //[self shouldReturnToPreview];
        [infoView removeFromSuperview];
        [self.view addSubview:previewView];
    }
    
	pageIndex = newPageIndex;
	
	if (pageIndex >= 0 && pageIndex < [dataSource numberOfRecords])
	{
        briefBeingPreviewed = [dataSource dataForIndex:pageIndex];
        [self preparePreview:briefBeingPreviewed];
        [self prepareInfoView:briefBeingPreviewed];
	}
    
}

- (void)prepareInfoView:(BriefRef *)ref
{
    infoView.titleLabel.text = ref.title;
    infoView.numberOfScenesLabel.text = [NSString stringWithFormat:@"%@", [ref totalNumberOfScenes]];
    infoView.authorLabel.text = ref.author;
    
    // adjust size of description box
    // to account for multiple lines
    CGSize adjustedSize = [ref.desc sizeWithFont:infoView.infoLabel.font constrainedToSize:CGSizeMake(116.0f, 50.0f)];
    CGRect adjustedFrame = infoView.infoLabel.frame;
    adjustedFrame.size = adjustedSize;
    infoView.infoLabel.frame = adjustedFrame;
    infoView.infoLabel.text = ref.desc;
    
    // check if locally stored
    if ([[ref fromURL] isEqual:kBFLocallyStoredBriefURLString]) {
        infoView.fromLabel.text = @"Built-in";
    }
    else infoView.fromLabel.text = [[NSURL URLWithString:[ref fromURL]] host];
    
    // format date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    infoView.dateLabel.text = [dateFormatter stringFromDate:[ref dateLastDownloaded]];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    infoView.timeLabel.text = [[dateFormatter stringFromDate:[ref dateLastDownloaded]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [dateFormatter release];
}

- (void)preparePreview:(BriefRef *)ref
{
    previewView.titleLabel.text = ref.title;
    
    // generate scene
    NSString *pathToDictionary = [[[BFDataManager sharedBFDataManager] documentDirectory] stringByAppendingPathComponent:[ref filePath]];
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneView *scene = [[BFSceneView alloc] initWithScene:[manager openingScene]];
    
    // output to image
    UIGraphicsBeginImageContext(scene.bounds.size);
    [scene.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sceneImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // blit image into preview
    previewView.sceneView.image = sceneImage;
    
    [scene release];
    [manager release];
}

- (void)zoomViewDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    // Start playing the brief
    NSString *pathToDictionary = [[[BFDataManager sharedBFDataManager] documentDirectory] stringByAppendingPathComponent:[[dataSource dataForIndex:pageIndex] filePath]];
    
    // setup scene view controller
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
    
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
    [self.parentNavigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:NO];
    
    [controller release];
    [manager release];
    
    UIView *viewToRemove = context;
    [viewToRemove removeFromSuperview];
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


- (void)dealloc 
{
    [super dealloc];
}


- (void)briefShouldStartPlaying
{
    // Animate the transition
    
    UIView *grandParentView = [[self.view superview] superview];    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:previewView.sceneView.image];
    transitionView.frame = previewView.sceneView.frame;
    transitionView.center = CGPointMake(171.0f, 160.0f);
    transitionView.alpha = 0.0f;
    [grandParentView addSubview:transitionView];
    
    
    [UIView beginAnimations:@"ZoomBriefIntoView" context:transitionView];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(zoomViewDidStop:finished:context:)];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [self.parentNavigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    
    transitionView.frame = CGRectInset(transitionView.frame, -64.0f, -96.0f);
    transitionView.center = CGPointMake(160.0f, 240.0f);
    transitionView.alpha = 1.0f;
    
    [UIView commitAnimations];    
}

- (void)shouldShowBriefDetails
{ 
    
    // replace preview with details
    [UIView beginAnimations:@"flip around details" context:nil];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    
    [self.view addSubview:infoView];
    [previewView removeFromSuperview];
    
    
    [UIView commitAnimations];
}

- (void)shouldReturnToPreview
{
    // replace preview with details
    [UIView beginAnimations:@"flip around details" context:nil];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    [self.view addSubview:previewView];
    [infoView removeFromSuperview];
    
    [UIView commitAnimations];
}

- (void)shouldDeleteBrief
{
    UIActionSheet *confirmDelete = [[UIActionSheet alloc] 
                                    initWithTitle:@"Are you sure you want remove this brief?\nI suppose you could download it again." 
                                    delegate:self 
                                    cancelButtonTitle:@"Oops, Nevermind" 
                                    destructiveButtonTitle:@"Nuke It" otherButtonTitles:nil];
    [confirmDelete showInView:[[self.view superview] superview]];
    [confirmDelete autorelease];
}

- (void)deleteFadeDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    BFPagedBrowseViewController *controller;
    if (controller = (BFPagedBrowseViewController *)[self.parentNavigationController topViewController]) {
        [controller refresh:[[BFDataManager sharedBFDataManager] allBriefsSortedAs:BFDataManagerSortByDateOpened] gotoIndex:pageIndex-1];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // remove the brief, if it is confirmed.
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [[BFDataManager sharedBFDataManager] removeBrief:briefBeingPreviewed];
        
        [UIView beginAnimations:@"fade deleted Brief" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationDidStopSelector:@selector(deleteFadeDidStop:finished:context:)];
            self.view.alpha = 0.0f;
        [UIView commitAnimations];
    }
}

- (void)shouldReloadBrief
{
    
}


@end
