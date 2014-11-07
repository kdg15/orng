//
//  Created by Brian Kramer on 31.10.14.
//  Copyright (c) 2014 kdg15. All rights reserved.
//

#import "UIView+KDGAnimation.h"

static CGFloat KDGAnimationDurationFactor = 1.0;

@implementation UIView (KDGAnimation)

+ (void)kdgSetAnimationDurationFactor:(CGFloat)factor
{
    KDGAnimationDurationFactor = factor;
}

+ (NSTimeInterval)kdgAdjustAnimationDuration:(NSTimeInterval)duration
{
    return duration * KDGAnimationDurationFactor;
}

- (void)kdgAddAnimateFadeIn:(CFTimeInterval)duration
                      delay:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)kdgAddAnimateFadeOut:(CFTimeInterval)duration
                       delay:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)kdgAddAnimateTransform:(CFTimeInterval)duration
                         delay:(CFTimeInterval)delay
                     fromPoint:(CGPoint)fromPoint
                       toPoint:(CGPoint)toPoint
                     fromScale:(CGSize)fromScale
                       toScale:(CGSize)toScale
{
    CGFloat dx = fromPoint.x - self.center.x;
    CGFloat dy = fromPoint.y - self.center.y;
    
    CGFloat dxTo = toPoint.x - self.center.x;
    CGFloat dyTo = toPoint.y - self.center.y;
    
    CATransform3D fromTransform = CATransform3DMakeTranslation(dx, dy, 0.0);
    fromTransform = CATransform3DScale(fromTransform, fromScale.width, fromScale.height, 1.0);
    
    CATransform3D toTransform = CATransform3DMakeTranslation(dxTo, dyTo, 0.0);
    toTransform = CATransform3DScale(toTransform, toScale.width, toScale.height, 1.0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    animation.toValue = [NSValue valueWithCATransform3D:toTransform];
    
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    
    [self.layer addAnimation:animation forKey:nil];
}

@end
