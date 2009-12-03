//
//  BFViewUtilityParser.m
//  Briefs
//
//  Created by Rob Rhyne on 9/30/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFViewUtilityParser.h"


@implementation BFViewUtilityParser

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Parsing Methods

+ (UIImage *)parseImageFromRepresentation:(id)representation
{
    UIImage *image;
    
    // U N C O M P A C T E D
    // Image is specified as a path to a local file
    if ([representation isKindOfClass:[NSString class]]) {
        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:representation ofType:nil];
        NSLog(@"loading image at path: %@ from representation: %@", pathToImage, representation);
        image = [UIImage imageWithContentsOfFile:pathToImage];
    }
    
    // C O M P A C T E D
    // Image is specified as an embedded data blob
    else {
        NSData *imageData = representation;
        image = [UIImage imageWithData:imageData];
    }
    
    return image;
}

///////////////////////////////////////////////////////////////////////////////

@end
