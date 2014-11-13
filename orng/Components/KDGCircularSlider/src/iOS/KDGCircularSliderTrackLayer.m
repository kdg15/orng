//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSliderTrackLayer.h"
#import "KDGCircularSlider.h"
#import <UIKit/UIKit.h>

@implementation KDGCircularSliderTrackLayer

#pragma mark - draw

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat inset = 0.5 * self.slider.knobSize;
    CGRect pathRect = CGRectInset(self.bounds, inset, inset);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pathRect];

    if (self.highlighted)
    {
        CGContextSetFillColorWithColor(ctx, self.slider.highlightColor.CGColor);
        CGContextFillEllipseInRect(ctx, self.bounds);
        CGContextSetStrokeColorWithColor(ctx, self.slider.trackHighlightColor.CGColor);
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, self.slider.backgroundColor.CGColor);
        CGContextFillEllipseInRect(ctx, self.bounds);
        CGContextSetStrokeColorWithColor(ctx, self.slider.trackColor.CGColor);
    }
    
    CGContextSetLineWidth(ctx, self.slider.trackSize);
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

@end
