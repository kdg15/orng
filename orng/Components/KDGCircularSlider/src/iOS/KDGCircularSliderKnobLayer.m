//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSliderKnobLayer.h"
#import <UIKit/UIKit.h>

@implementation KDGCircularSliderKnobLayer

- (void)drawInContext:(CGContextRef)context
{
    if (self.highlighted)
    {
        CGContextSetFillColorWithColor(context, self.slider.knobHighlightColor.CGColor);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    else
    {
        CGContextSetFillColorWithColor(context, self.slider.knobColor.CGColor);
        CGContextFillEllipseInRect(context, self.bounds);
    }
}

@end
