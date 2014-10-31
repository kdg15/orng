//
//  UIView+KDGAnimation.h
//  prpl
//
//  Created by Brian Kramer on 31.10.14.
//  Copyright (c) 2014 kdg15. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KDGAnimation)

- (void)kdgAddAnimateFadeIn:(CFTimeInterval)duration
                      delay:(CFTimeInterval)delay;

- (void)kdgAddAnimateFadeOut:(CFTimeInterval)duration
                       delay:(CFTimeInterval)delay;

- (void)kdgAddAnimateTransform:(CFTimeInterval)duration
                         delay:(CFTimeInterval)delay
                     fromPoint:(CGPoint)fromPoint
                       toPoint:(CGPoint)toPoint
                     fromScale:(CGFloat)fromScale
                       toScale:(CGFloat)toScale;

@end
