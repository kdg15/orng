//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSliderTrackLayer.h"
#import <UIKit/UIKit.h>

@implementation KDGCircularSliderTrackLayer

#pragma mark - draw

- (void)drawInContext:(CGContextRef)context
{
    if (self.drawBlock)
    {
        self.drawBlock(self, context);
    }
    else
    {
        CGFloat inset = 0.5 * self.slider.knobSize;
        CGRect pathRect = CGRectInset(self.bounds, inset, inset);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pathRect];
        
        if (self.highlighted)
        {
            CGContextSetFillColorWithColor(context, self.slider.highlightColor.CGColor);
            CGContextFillEllipseInRect(context, self.bounds);
            CGContextSetStrokeColorWithColor(context, self.slider.trackHighlightColor.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.slider.backgroundColor.CGColor);
            CGContextFillEllipseInRect(context, self.bounds);
            CGContextSetStrokeColorWithColor(context, self.slider.trackColor.CGColor);
        }
        
        CGContextSetLineWidth(context, self.slider.trackSize);
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    }
}

@end
