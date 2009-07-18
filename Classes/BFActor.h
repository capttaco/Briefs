//
//  BFActor.h
//  Briefs
//
//  Created by Rob Rhyne on 7/17/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface BFActor : NSObject 
{
	UIImage		*bg;
	NSString	*name;
	CGRect		*size;
}

@property (nonatomic, retain) UIImage		*bg;
@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) CGRect		*size;

- (id)init:(String*)name withDictionary:(NSDictionary*)dict;

@end
