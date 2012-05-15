//
//  NSDictionary+BFAdditions.m
//  Briefs
//
//  Created by Rob Rhyne on 3/13/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "NSDictionary+BFAdditions.h"


@implementation NSDictionary (BFAdditions)

- (id)objectForKey:(NSString *)key orDefaultValue:(id)defaultValue
{
    id returnValue = [self objectForKey:key];
    return returnValue != nil ? returnValue : defaultValue;
}

+ (NSDictionary *)dictionaryFromData:(NSData *)data
{
    CFStringRef errorString = NULL;
    CFDataRef dataRef = (__bridge CFDataRef) data;
    CFPropertyListRef propertyListRef = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, dataRef, kCFPropertyListImmutable, &errorString);
    CFBridgingRelease(propertyListRef);
    if (errorString != NULL) {
        NSLog(@"The following error occured while converting the incoming data: %@", errorString); 
        return nil;
    }
    else return (__bridge NSDictionary *) propertyListRef;
}

@end
