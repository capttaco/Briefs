//
//  BFRemoteBriefViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 4/7/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFRemoteBriefViewController.h"
#import "NSDictionary+BFAdditions.h"
#import "BFSceneManager.h"
#import "BFPresentationDispatch.h"
#import "BriefRef.h"
#import "BFDataManager.h"


@implementation BFRemoteBriefViewController
@synthesize delegate;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSViewController overrides

- (id)initWithLocationOfBrief:(NSString *)location
{
    if (self = [super init]) {
        locationOfBrief = location;
        
        // setup the loading controller
        loadingController = [[BFLoadingViewController alloc] initWithNibName:@"FullPageRemoteLoad" bundle:nil];
        [loadingController setDelegate:self];
        [loadingController load:location withStatus:@"Pulling out a fresh pair..."];
        
        // setup the remote saver
        remoteSaver = [[BFRemoteBriefSaver alloc] init];
        [remoteSaver setDelegate:self];
        [remoteSaver setPromptLabelText:@"Place a copy in your Library?"];
        
        // initialize data values
        briefData = nil;
        alreadyLoaded = NO;
        
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (loadingController) {
        self.view.clipsToBounds = NO;
        [self.view addSubview:loadingController.view];
    }
}



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFLoadingViewDelegate Methods

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data
{
    briefData = data;
    alreadyLoaded = YES;
    
    // LAUNCH THE BRIEF
    // ================
    // setup scene view controller
    
    //NB the functions in the dictionaryFromData category do not work on the device as of iOS 5.1
    //they just return an empty dictionary so we're writing to a temp file and reading it back in
    NSString *plistPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"RemoteBrief.plist"];
    [briefData writeToFile:plistPath atomically:YES];
    //NSDictionary *dict = [NSDictionary dictionaryFromData:briefData];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    BFSceneManager *manager = [[BFSceneManager alloc] initWithDictionary:dict];
    BFSceneViewController *sceneController = [[BFSceneViewController alloc] initWithSceneManager:manager];
   
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:sceneController];
    [BFPresentationDispatch sharedBFPresentationDispatch].viewController.delegate = self;

    [UIView beginAnimations:@"display brief" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(briefShowDidStop:finished:context:)];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.8f];
    
        // swap loader for brief
        [loadingController.view removeFromSuperview];
        [self.view addSubview:[BFPresentationDispatch sharedBFPresentationDispatch].viewController.view];
    
    [UIView commitAnimations];
    
}

- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error
{
    // TODO: handle error
    [loadingController.view removeFromSuperview];
}

- (void)loadingView:(BFLoadingViewController *)controller didCancelConnection:(NSString *)url
{
    // TODO: handle cancelation
    [loadingController.view removeFromSuperview];
}

- (void)briefShowDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFSceneViewDelegate Methods

- (void)sceneView:(BFSceneViewController *)controller shouldDismissView:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [UIView beginAnimations:@"remove brief" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.8f];
        
        // swap brief for save view
        [controller.view removeFromSuperview];
        [self.view addSubview:remoteSaver.view];
    
    [UIView commitAnimations];
    
}

- (void)dismissLoadingViewAnimation:(BriefRef *)savedBrief
{
    if (self.delegate) {
        [self.delegate remoteView:self shouldDismissView:savedBrief];
    }
}



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFRemoteBriefSaverDelegate Methods

- (void)view:(id)sender shouldDismissAndSave:(BOOL)animated
{
    // persist the brief
    NSString *remoteNameOfBrief = [locationOfBrief lastPathComponent];
    BriefRef *ref = [[BFDataManager sharedBFDataManager] addBriefAtPath:remoteNameOfBrief usingData:briefData fromURL:locationOfBrief];
        
    [self dismissLoadingViewAnimation:ref];
}

- (void)view:(id)sender shouldDismissAndCancel:(BOOL)animated
{
    [self dismissLoadingViewAnimation:nil];
}

///////////////////////////////////////////////////////////////////////////////

@end
