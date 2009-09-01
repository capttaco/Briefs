//
//  SceneViewController.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFSceneViewController.h"
#import "BFRootView.h"


@implementation BFSceneViewController

@synthesize dataManager, current_scene;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController overrides

- (id)initWithSceneManager:(BFSceneManager*)manager
{
	if (self = [super init]) {
		self.dataManager = manager;
		self.view = [[BFRootView alloc] initWithFrame:CGRectMake(0.0f,0.0f,320.0f,480.0f)];
		
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
	BFScene *scene = [dataManager sceneByNumber:index];
	if (scene == nil) {
		return false;
	} else {
		
		// remove from old scene
		// TODO: need to remove this according to scene transition
		if (self.current_scene != nil) {
			[self.current_scene removeFromSuperview];
			//[self.current_scene release];
		}
		
		BFSceneView *scene_view = [[BFSceneView alloc] initWithScene:scene];
		self.current_scene = scene_view;
		[self.view addSubview:scene_view];
		
		[scene_view	release];
		
		return true;
	}
}

- (BOOL)willToggleActorWithIndex:(int)index 
{
	// TODO: implement actor toggling, by index
	return false;
}

- (BOOL)willResizeActorWithIndex:(int)index toSize:(CGSize)size 
{
	// TODO: implement actor resizing, by index
	return false;
}

- (BOOL)willMoveActorWithIndex:(int)index toPoint:(CGPoint)point 
{
	// TODO: implement actor movement, by index
	return false;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Global Dispatch Methods

- (BOOL) willShowKeyboard:(NSString *)type {
	// TODO: implement keyboard display
	return false;
}


@end
