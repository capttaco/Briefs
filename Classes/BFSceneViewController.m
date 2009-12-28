//
//  SceneViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFSceneViewController.h"
#import "BFViewUtilityParser.h"
#import "BFRootView.h"
#import "BFActorView.h"
#import "BFConstants.h"

@implementation BFSceneViewController

@synthesize dataManager, current_scene;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController overrides

- (id)initWithSceneManager:(BFSceneManager*)manager
{
    if (self = [super init]) {
        self.dataManager = manager;
        self.view = [[BFRootView alloc] initWithFrame:CGRectMake(0.0f,0.0f,320.0f,480.0f) andViewController:self];
        
        // load current view, according to data model
        BFSceneView *scene_view = [[BFSceneView alloc] initWithScene:[self.dataManager currentScene]];
        self.current_scene = scene_view;
        [self.view addSubview:scene_view];
        
        [scene_view release];
    }
    return self;
}

- (void)loadView 
{
    // TODO: do I need to add view allocation here?
    
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
    self.current_scene = nil;
}

- (void)dealloc 
{
    if (current_scene != nil) {
        [current_scene release];
    }
    [dataManager release];
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Local Dispatch Methods

- (BOOL)willLoadSceneWithIndex:(int)index
{
    return [self willLoadSceneWithIndex:index usingTransition:nil];
}

- (BOOL)willLoadSceneWithIndex:(int)index usingTransition:(NSString *)transition 
{
    BFScene *scene = [dataManager sceneByNumber:index];
    
    // ensure that the scene exists
    if (scene == nil)
        return false;
    
    // display the view
    else {
        
        // remove from old scene
        // TODO: need to remove this according to scene transition
        BFSceneView *scene_view = [[BFSceneView alloc] initWithScene:scene];
        
        if (self.current_scene != nil && transition != nil)
            [self performTransition:transition onEnteringView:scene_view removingOldView:self.current_scene];
            
        else
            [self.view addSubview:scene_view];
        
        self.current_scene = scene_view;
        [scene_view release];
        
        return true;
    }
}

- (BOOL)willToggleActorWithIndex:(int)index 
{
    if (self.current_scene != nil) {
        BFActorView *actorView = [self.current_scene.actor_views objectAtIndex:index];
        
        UIImageView *stubView = [[UIImageView alloc] initWithImage:actorView.image];
        stubView.frame = actorView.frame;
        [self.current_scene addSubview:stubView];
        
        // begin animation
        [UIView beginAnimations:@"ToggleTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        stubView.alpha = 1.0f;
        actorView.alpha = 0.0f;
        
        // swap the images
        [actorView.actor toggle];
        actorView.image = [BFViewUtilityParser parseImageFromRepresentation:[actorView.actor background]];
        
        // ease the new image back in
        stubView.alpha = 0.0f;
        actorView.alpha = 1.0f;
        
        // commit the animation stack
        [UIView commitAnimations];
        
        return true;
    }
    
    else return false;
}

- (BOOL)willShowActorWithIndex:(int)index
{
    if (self.current_scene != nil) {
        BFActorView *actorView = [self.current_scene.actor_views objectAtIndex:index];
        
        // begin animation
        [UIView beginAnimations:@"ShowTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        actorView.alpha = 1.0f;
        
        // commit the animation stack
        [UIView commitAnimations];
        
        return true;
    }
    
    else return false;
}

- (BOOL)willHideActorWithIndex:(int)index
{
    if (self.current_scene != nil) {
        BFActorView *actorView = [self.current_scene.actor_views objectAtIndex:index];
        
        // begin animation
        [UIView beginAnimations:@"HideTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        actorView.alpha = 0.0f;
        
        // commit the animation stack
        [UIView commitAnimations];
        
        return true;
    }
    
    else return false;
    
}

- (BOOL)willResizeActorWithIndex:(int)index toSize:(CGSize)size 
{
    if (self.current_scene != nil) {
        BFActorView *actor = [self.current_scene.actor_views objectAtIndex:index];

        // begin animation
        [UIView beginAnimations:@"ResizeTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        CGPoint origin = actor.frame.origin;
        actor.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        // commit the animation stack
        [UIView commitAnimations];
        
        return true;
    }
    
    else return false;
}

- (BOOL)willMoveActorWithIndex:(int)index toPoint:(CGPoint)point 
{
    if (self.current_scene != nil) {
        BFActorView *actor = [self.current_scene.actor_views objectAtIndex:index];
        
        // begin animation
        [UIView beginAnimations:@"MoveTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        CGSize size = actor.frame.size;
        actor.frame = CGRectMake(point.x, point.y, size.width, size.height);
        
        // commit the animation stack
        [UIView commitAnimations];
        
        return true;
    }
    
    else return false;
}


- (void)performTransition:(NSString *)transition onEnteringView:(BFSceneView *)entering removingOldView:(BFSceneView *)exiting
{
    
    // P U S H  T R A N S I T I O N
    // supported directions: (left, right, up, down)
    
    if ([transition hasPrefix:kBFSceneTransitionPush]) {
        
        CGFloat tx = 0.0f;
        CGFloat ty = 0.0f;
		
		if([transition hasSuffix:kBFSceneTransitionDirectionLeft])   tx = -320.0f;
		else if([transition hasSuffix:kBFSceneTransitionDirectionRight]) tx = 320.0f;
		else if([transition hasSuffix:kBFSceneTransitionDirectionUp])   ty = -480.0f;
		else if([transition hasSuffix:kBFSceneTransitionDirectionDown]) ty = 480.0f;

        entering.transform = CGAffineTransformMakeTranslation(-tx, -ty);
        
        [UIView beginAnimations:@"PushTransition" context:nil];
        [UIView setAnimationDuration:0.4f];
        
        [self.view insertSubview:entering belowSubview:exiting];
        
        exiting.transform = CGAffineTransformMakeTranslation(tx, ty);
        entering.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
    // F L I P  T R A N S I T I O N
    // supported directions: (left, right)
    
    else if ([transition hasPrefix:kBFSceneTransitionFlip]) {
        
        [UIView beginAnimations:@"FlipTransition" context:nil];
        [UIView setAnimationDuration:0.8f];
        
        UIViewAnimationTransition transitionType = [transition hasSuffix:kBFSceneTransitionDirectionRight] ?  UIViewAnimationTransitionFlipFromLeft :  UIViewAnimationTransitionFlipFromRight;
        [UIView setAnimationTransition:transitionType forView:self.view cache:YES];
        
        [self.view addSubview:entering];
        [exiting removeFromSuperview];
    }
    
    // C U R L  T R A N S I T I O N
    // supported directions: (up, down)
    
    else if ([transition hasPrefix:kBFSceneTransitionCurl]) {
        
        [UIView beginAnimations:@"CurlTransition" context:nil];
        [UIView setAnimationDuration:1.0f];
        
        UIViewAnimationTransition transitionType = [transition hasSuffix:kBFSceneTransitionDirectionDown] ?  UIViewAnimationTransitionCurlDown :  UIViewAnimationTransitionCurlUp;
        [UIView setAnimationTransition:transitionType forView:self.view cache:YES];
        
        [self.view addSubview:entering];
        [exiting removeFromSuperview];
    }    
    
    // C O V E R  T R A N S I T I O N
    // supported directions: (left, right, up, down)
    
    else if ([transition hasPrefix:kBFSceneTransitionCover]) {
        
		CGFloat tx = 0.0f;
		CGFloat ty = 0.0f;
		
        if ([transition hasSuffix:kBFSceneTransitionDirectionLeft])       tx = -320.0f;
		else if ([transition hasSuffix:kBFSceneTransitionDirectionRight]) tx = 320.0f;
		else if ([transition hasSuffix:kBFSceneTransitionDirectionUp])    ty = -480.0f;
		else if ([transition hasSuffix:kBFSceneTransitionDirectionDown])  ty = 480.0f;
		
        
        
        entering.transform = CGAffineTransformMakeTranslation(-tx, -ty);
        
        [UIView beginAnimations:@"SlideTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        [self.view insertSubview:entering aboveSubview:exiting];
        entering.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
    }
	
	// R E V E A L  T R A N S I T I O N
    // supported directions: (left, right, up, down)
    
    else if ([transition hasPrefix:kBFSceneTransitionReveal]) {
        
		CGFloat tx = 0.0f;
		CGFloat ty = 0.0f;
		
		if ([transition hasSuffix:kBFSceneTransitionDirectionLeft])       tx = -320.0f;
		else if ([transition hasSuffix:kBFSceneTransitionDirectionRight]) tx = 320.0f;
        else if ([transition hasSuffix:kBFSceneTransitionDirectionDown])  ty = 480.0f;
		else if ([transition hasSuffix:kBFSceneTransitionDirectionUp])    ty = -480.0f;
        
        
        exiting.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        
        [UIView beginAnimations:@"SlideTransition" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        [self.view insertSubview:entering belowSubview:exiting];
        exiting.transform = CGAffineTransformMakeTranslation(tx, ty);
    }
	
	// Z O O M  T R A N S I T I O N
    // supported directions: (in, out)
	
    else {
        
        CGFloat d0 = ([transition hasSuffix:kBFSceneTransitionDirectionIn]) ? 0.01f : 3.0f;
        CGFloat d1 = 1.0f;
        
        exiting.alpha = 0.5f;
        
        [UIView beginAnimations:@"ZoomTransition" context:nil];
        [UIView setAnimationDuration:0.4f];
        [self.view addSubview:entering];
        
        entering.transform = CGAffineTransformMakeScale(d0, d0);
        entering.alpha = 0.01f;
        
        exiting.alpha = 0.0f;
        if ([transition hasSuffix:kBFSceneTransitionDirectionIn])
            exiting.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
        
        entering.transform = CGAffineTransformMakeScale(d1, d1);
        entering.alpha = 1.0f;
    }
    
	
    
    // commit the animation stack
    [UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Global Dispatch Methods

- (BOOL)willShowKeyboard:(NSString *)type {
    // TODO: implement keyboard display
    return false;
}


@end
