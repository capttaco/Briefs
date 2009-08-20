//
//  BFActor.m
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFActor.h"
#import "BFDispatch.h"

#define	kBFACTOR_GOTO_ACTION		@"goto"
#define	kBFACTOR_TOGGLE_ACTION	@"toggle"
#define	kBFACTOR_RESIZE_ACTION	@"resize"
#define	kBFACTOR_MOVE_ACTION		@"move"

@implementation BFActor

@synthesize bg, name, size, action, touchedBg, disabledBg, releasedBg;



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Support

+ (NSArray *)availableActions {
	// FIXME Best way to represent this?
	return [[NSArray alloc] initWithObjects:kBFACTOR_GOTO_ACTION, kBFACTOR_TOGGLE_ACTION,
					kBFACTOR_RESIZE_ACTION, kBFACTOR_MOVE_ACTION, nil];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)init:(NSString*)name withDictionary:(NSDictionary*)dict
{
	isActive = true; 
	
	// TODO: Refactor this into a Briefs data formatter
	if (self = [super init]) {
		self.name = [dict valueForKey:@"name"];

		// backgrounds
		NSString *pathToImage = [[NSBundle mainBundle] pathForResource:[dict valueForKey:@"img"] ofType:nil];
		self.bg = [UIImage imageWithContentsOfFile:pathToImage];
		
		self.touchedBg = [dict valueForKey:@"touched"];
		self.disabledBg = [dict	valueForKey:@"disabled"];
		self.releasedBg = [dict	valueForKey:@"released"];
		
		// Dimensions
		NSNumber *x = [dict valueForKey:@"x"];
		NSNumber *y = [dict valueForKey:@"y"];
		NSNumber *width = [dict valueForKey:@"width"];
		NSNumber *height = [dict valueForKey:@"height"];
		self.size = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
		
		[x release];
		[y release];
		[width release];
		[height	release];
		
		// Action
		// TODO: generalize this as well?
		self.action = [dict valueForKey:@"action"];
		
	}
	return self;
}

- (void)dealloc 
{
	[bg release];
	[name release];
	[action release];
	[touchedBg release];
	[disabledBg release];
	[releasedBg release];
	[super dealloc];
}



///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark State Management

- (void) activate
{
	isActive = true;
}

- (void) deactivate 
{
	isActive = false;
}

- (UIImage *) background
{
	if (isActive)
		return [self bg];
	else
		return [self disabledBg];
}

///////////////////////////////////////////////////////////////////////////////
@end
