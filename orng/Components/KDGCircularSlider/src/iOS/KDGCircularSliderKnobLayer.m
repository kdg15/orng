//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSliderKnobLayer.h"
#import "KDGCircularSlider.h"
#import <UIKit/UIKit.h>

@implementation KDGCircularSliderKnobLayer

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.highlighted)
    {
        CGContextSetFillColorWithColor(ctx, self.slider.knobHighlightColor.CGColor);
        CGContextFillEllipseInRect(ctx, self.bounds);
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, self.slider.knobColor.CGColor);
        CGContextFillEllipseInRect(ctx, self.bounds);
    }
}

@end
