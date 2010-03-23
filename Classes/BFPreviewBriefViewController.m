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
        BriefRef *ref = [dataSource dataForIndex:pageIndex];
        previewView.titleLabel.text = [ref title];
        
        
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
	}
    
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

- (void)briefShouldStartPlaying
{
    // Animate the transition

    UIView *grandParentView = [[self.view superview] superview];
    [self.parentNavigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:previewView.sceneView.image];
    transitionView.frame = previewView.sceneView.frame;
    transitionView.center = CGPointMake(171.0f, 160.0f);
    transitionView.alpha = 0.0f;
    [grandParentView addSubview:transitionView];
    
    
    [UIView beginAnimations:@"ZoomBriefIntoView" context:transitionView];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(zoomViewDidStop:finished:context:)];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    transitionView.frame = CGRectInset(transitionView.frame, -64.0f, -96.0f);
    transitionView.center = CGPointMake(160.0f, 240.0f);
    transitionView.alpha = 1.0f;
    
    [UIView commitAnimations];    
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


@end
