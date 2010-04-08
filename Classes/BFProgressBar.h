//
//  BFProgressBar.h
//  Briefs
//
//  Created by Rob Rhyne on 4/5/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//


@interface BFProgressBar : UIView
{
    UISlider *internalSlider;
}

- (id)initWithMarkerImageRef:(NSString *)imageRef usingBackground:(NSString *)backgroundRef;

- (void)setProgressValue:(float)value animated:(BOOL)shouldAnimate;
- (void)setProgressValue:(float)value;

@end
