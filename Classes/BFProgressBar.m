//
//  BFProgressBar.m
//  Briefs
//
//  Created by Rob Rhyne on 4/5/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFProgressBar.h"


@implementation BFProgressBar

// setup default implementation from a .nib file
- (void)awakeFromNib
{
    // size the slider
    CGRect sliderFrame = self.frame;
    sliderFrame.origin = CGPointMake(6.0f, -3.0f);
    sliderFrame.size = CGSizeMake(sliderFrame.size.width-12.0f, 12.0f);
    internalSlider = [[UISlider alloc] initWithFrame:sliderFrame];
    
    // style the slider        
    internalSlider.backgroundColor = [UIColor clearColor];  
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"pop-slider-fg.png"]
                                stretchableImageWithLeftCapWidth:1.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"pop-slider-blank.png"]
                                 stretchableImageWithLeftCapWidth:1.0 topCapHeight:0.0];
    [internalSlider setThumbImage:nil forState:UIControlStateNormal];
    [internalSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [internalSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    
    // size the background
    UIImage *stretchableBG = [[UIImage imageNamed:@"pop-slider-bg.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:0.0];
    background = [[UIImageView alloc] initWithImage:stretchableBG];
    background.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    // add them to the parent view
    [self addSubview:background];
    [self addSubview:internalSlider];
    
}

- (id)initWithMarkerImageRef:(NSString *)imageRef usingBackground:(NSString *)backgroundRef
{
    // TODO: load the slider with custom images.
    return nil;
}

- (void)setProgressValue:(float)value animated:(BOOL)shouldAnimate
{
    if (internalSlider) {
        [internalSlider setValue:value animated:shouldAnimate];
    }
    
    // if the value to be set is near 1.0
    // then swap the background a completed image
    if (value > 0.98) {
        CGRect bgFrame = background.frame;
        [background removeFromSuperview];
        [background release];
        
        UIImage *stretchableBG = [[UIImage imageNamed:@"pop-slider-bg-filled.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:0.0];
        background = [[UIImageView alloc] initWithImage:stretchableBG];
        background.frame = bgFrame;
        [self insertSubview:background belowSubview:internalSlider];
    }
}

- (void)setProgressValue:(float)value
{
    [self setProgressValue:value animated:NO];
}

@end
