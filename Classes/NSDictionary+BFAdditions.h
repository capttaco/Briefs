//
//  NSDictionary+BFAdditions.h
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

@interface NSDictionary (BFAdditions) 

- (id)objectForKey:(NSString *)key orDefaultValue:(id)defaultValue;

@end
