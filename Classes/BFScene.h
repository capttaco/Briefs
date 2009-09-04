//
//  BFScene.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFScene : NSObject 
{
	NSString	*bg;
	NSArray		*actors;
	NSString	*name;
}

@property (nonatomic, retain) NSString	*bg;
@property (nonatomic, retain) NSArray		*actors;
@property (nonatomic, retain) NSString	*name;


- (id)init:(NSString *)name withDictionary:(NSDictionary *)dict;

- (NSDictionary *)copyAsDictionary;

@end
