//
//  BFSceneView.m
//  Briefs
//
//  Created by Rob Rhyne on 8/18/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//


#import "BFSceneView.h"
#import "BFActor.h"
#import "BFActorView.h"
#import "BFPresentationDispatch.h"


@implementation BFSceneView
@synthesize scene, actor_views;

- (id)initWithScene:(BFScene *)source
{
	NSString *pathToImage = [[NSBundle mainBundle] pathForResource:[source bg] ofType:nil];
	if (self = [super initWithImage:[UIImage imageWithContentsOfFile:pathToImage]]) {
		self.scene = source;
		
		// enable user interaction, per documentation
		[self setUserInteractionEnabled:YES];
		
		// display actors
		NSMutableArray *subViews = [NSMutableArray arrayWithCapacity:[[self.scene actors] count]];
		for (BFActor *actor in [self.scene actors]) {
			BFActorView *view = [[BFActorView alloc] initWithActor:actor];
			[subViews addObject:view];
			[self addSubview:view];
			
			[view release];
		}
	}
	return self;
}

- (void)dealloc 
{
	[scene release];
	[super dealloc];
}




@end
