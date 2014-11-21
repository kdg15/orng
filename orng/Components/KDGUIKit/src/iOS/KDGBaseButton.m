//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGBaseButton.h"
#import "KDGCALayer.h"
#import "KDGUtilities.h"

static CGFloat const kDefaultBorderWidth          = 0.0;
static CGFloat const kDefaultSelectionBorderWidth = 3.0;
static CGFloat const kDefaultShadowOpacity        = 0.0;
static CGFloat const kDefaultShadowRadius         = 3.0;
static CGFloat const kDefaultSlopDistance         = 30.0;

static CGSize const kDefaultShadowOffset = { 2.0, 2.0 };

static CFTimeInterval const kDefaultSelectionDuration = 0.2;

@interface KDGBaseButton ()

@property (nonatomic, strong) KDGCALayer *selectionLayer;
@property (nonatomic, strong) UIColor    *color;
@property (nonatomic, assign) CGPoint    lastTouchPoint;

@end

@implementation KDGBaseButton

#pragma mark - initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgBaseButtonInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgBaseButtonInitialize];
    }
    
    return self;
}

- (void)kdgBaseButtonInitialize
{
    _color          = [UIColor lightGrayColor];
    _highlightColor = [UIColor grayColor];
    _borderColor    = [UIColor darkGrayColor];
    _selectionColor = [UIColor blackColor];
    
    _borderWidth          = kDefaultBorderWidth;
    _selectionBorderWidth = kDefaultSelectionBorderWidth;

    _shadowOpacity = kDefaultShadowOpacity;
    _shadowRadius = kDefaultShadowRadius;
    _cornerRadius  = 0.5 * self.bounds.size.height;
    _slopDistance  = kDefaultSlopDistance;

    _shadowOffset = kDefaultShadowOffset;

    _selectionDuration = kDefaultSelectionDuration;
    
    self.layer.backgroundColor = _color.CGColor;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
    self.layer.shadowOpacity = _shadowOpacity;
    self.layer.shadowRadius = _shadowRadius;
    self.layer.shadowOffset = _shadowOffset;
    
    _selectionLayer = [KDGCALayer layer];
    _selectionLayer.frame = self.bounds;
    _selectionLayer.cornerRadius = _cornerRadius;
    _selectionLayer.borderColor = _selectionColor.CGColor;
    _selectionLayer.borderWidth = 0.0;
    [self.layer addSublayer:_selectionLayer];
}

#pragma mark - properties

- (UIColor *)backgroundColor
{
    return _color;
}

- (void)setBackgroundColor:(UIColor *)color
{
    _color = color;
    self.layer.backgroundColor = color.CGColor;
}

- (void)setBorderColor:(UIColor *)color
{
    _borderColor = color;
    self.layer.borderColor = color.CGColor;
}

- (void)setSelectionColor:(UIColor *)color
{
    _selectionColor = color;
    self.selectionLayer.borderColor = color.CGColor;
}

- (void)setBorderWidth:(CGFloat)width
{
    _borderWidth = width;
    self.layer.borderWidth = width;
}

- (void)setShadowOpacity:(CGFloat)opacity
{
    _shadowOpacity = opacity;
    self.layer.shadowOpacity = opacity;
}

- (void)setShadowRadius:(CGFloat)radius
{
    _shadowRadius = radius;
    self.layer.shadowRadius = radius;
}

- (void)setCornerRadius:(CGFloat)radius
{
    _cornerRadius = radius;
    self.layer.cornerRadius = radius;
    self.selectionLayer.cornerRadius = radius;
}

- (void)setShadowOffset:(CGSize)offset
{
    _shadowOffset = offset;
    self.layer.shadowOffset = offset;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.duration = self.selectionDuration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;

    if (selected)
    {
        animation.fromValue = @0.0;
        animation.toValue = [NSNumber numberWithFloat:self.selectionBorderWidth];
    }
    else
    {
        animation.fromValue = [NSNumber numberWithFloat:self.selectionBorderWidth];
        animation.toValue = @0.0;
    }

    [self.selectionLayer addAnimation:animation forKey:nil];
}

#pragma mark - highlight

- (void)highlight
{
    self.layer.backgroundColor = self.highlightColor.CGColor;
    self.highlighted = YES;
}

- (void)unhighlight
{
    self.layer.backgroundColor = self.color.CGColor;
    self.highlighted = NO;
}

#pragma mark - point inside

- (BOOL)isCircleButton
{
    return (self.bounds.size.width == self.bounds.size.height && self.cornerRadius == 0.5 * self.bounds.size.height);
}

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint c = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat dx = point.x - c.x;
    CGFloat dy = point.y - c.y;
    CGFloat d = sqrtf(dx * dx + dy * dy);
    
    return d;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL result = NO;

    if ([self isCircleButton])
    {
        CGFloat distance = [self calculateDistanceFromCenter:point];
        result = (distance <= 0.5 * self.bounds.size.width);
    }
    else
    {
        result = [super pointInside:point withEvent:event];
    }
    
    return result;
}

- (BOOL)pointInsideSlop:(CGPoint)point
{
    BOOL result = NO;
    
    if ([self isCircleButton])
    {
        CGFloat distance = [self calculateDistanceFromCenter:point];
        result = (distance <= (0.5 * self.bounds.size.width + self.slopDistance));
    }
    else
    {
        CGRect bounds = CGRectInset(self.bounds, -self.slopDistance, -self.slopDistance);
        result = CGRectContainsPoint(bounds, point);
    }

    return result;
}

#pragma mark - event tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self highlight];

    CGPoint touchPoint = [touch locationInView:self];
    self.lastTouchPoint = touchPoint;

    [self sendActionsForControlEvents:UIControlEventTouchDown];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    if ([self pointInsideSlop:touchPoint])
    {
        if ([self pointInsideSlop:self.lastTouchPoint])
        {
            [self sendActionsForControlEvents:UIControlEventTouchDragInside];
        }
        else
        {
            [self highlight];

            [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
        }
    }
    else
    {
        if ([self pointInsideSlop:self.lastTouchPoint])
        {
            [self unhighlight];

            [self sendActionsForControlEvents:UIControlEventTouchDragExit];
        }
        else
        {
            [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
        }
    }
    
    self.lastTouchPoint = touchPoint;

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    [self unhighlight];

    if ([self pointInsideSlop:touchPoint])
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self unhighlight];

    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self beginTrackingWithTouch:touch withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self continueTrackingWithTouch:touch withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self endTrackingWithTouch:touch withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelTrackingWithEvent:event];
}

@end
