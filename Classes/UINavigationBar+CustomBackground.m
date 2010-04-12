//
//  UINavigationBar+CustomBackground.m
//  Briefs
//
//  Created by Rob Rhyne on 4/11/10.
//  Copyright 2010 Digital Arch Design. All rights reserved.
//


@implementation UINavigationBar (CustomBackground)

- (void)drawRect:(CGRect)rect 
{
    UIImage *image = [UIImage imageNamed:@"navigation-bar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
