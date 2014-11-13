//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGBaseButton.h"

static CGFloat const kDefaultBorderWidth   = 0.0;
static CGFloat const kDefaultShadowOpacity = 0.0;
static CGFloat const kDefaultSlopDistance  = 30.0;

@implementation KDGColorSwatch

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgColorSwatchInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgColorSwatchInitialize];
    }
    
    return self;
}

- (void)kdgColorSwatchInitialize
{
    _swatchColor = [UIColor colorWithWhite:255 / 255.0 alpha:1.0];
    
    self.layer.backgroundColor = _swatchColor.CGColor;
    self.layer.cornerRadius = 0.5 * self.bounds.size.height;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 0.5;
}

- (void)setSwatchColor:(UIColor *)color
{
    _swatchColor = color;
    self.layer.backgroundColor = color.CGColor;
}

@end

@interface KDGBaseButton ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint  lastTouchPoint;

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
    
    _borderWidth   = kDefaultBorderWidth;
    _shadowOpacity = kDefaultShadowOpacity;
    _cornerRadius  = 0.5 * self.bounds.size.height;
    _slopDistance  = kDefaultSlopDistance;
    
    self.layer.backgroundColor = _color.CGColor;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
    self.layer.shadowOpacity = _shadowOpacity;
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
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

- (void)setCornerRadius:(CGFloat)radius
{
    _cornerRadius = radius;
    self.layer.cornerRadius = radius;
}

#pragma mark - highlight

- (void)highlight
{
    self.layer.backgroundColor = self.highlightColor.CGColor;

    /*
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
     animation.duration = 0.1;
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeBoth;
     animation.fromValue = @0.0;
     animation.toValue = [NSNumber numberWithFloat:kBorderWidth];

     [self.layer addAnimation:animation forKey:nil];
     */
}

- (void)unhighlight
{
    self.layer.backgroundColor = self.color.CGColor;

    /*
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
     animation.duration = 0.1;
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeBoth;
     animation.fromValue = [NSNumber numberWithFloat:kBorderWidth];
     animation.toValue = @0.0;

     [self.layer addAnimation:animation forKey:nil];
     */
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

@interface KDGTextButton ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation KDGTextButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgTextLabelButtonInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgTextLabelButtonInitialize];
    }
    
    return self;
}

- (void)kdgTextLabelButtonInitialize
{
    _textColor          = [UIColor whiteColor];
    _textHighlightColor = [UIColor lightGrayColor];

    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.text = @"kdg";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = _textColor;
    
    [self addSubview:self.label];
}

- (void)setTextColor:(UIColor *)color
{
    _textColor = color;
    self.label.textColor = color;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

- (void)highlight
{
    [super highlight];
    self.label.textColor = _textHighlightColor;
}

- (void)unhighlight
{
    [super unhighlight];
    self.label.textColor = _textColor;
}

@end

@interface KDGColorSwatchButton ()

@property (nonatomic, strong) KDGColorSwatch *swatch;

@end

@implementation KDGColorSwatchButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self kdgColorSwatchButtonInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self kdgColorSwatchButtonInitialize];
    }
    
    return self;
}

- (void)kdgColorSwatchButtonInitialize
{
    _swatchColor = [UIColor whiteColor];
    
    CGFloat inset = 8.0;
    CGRect swatchBounds = CGRectInset(self.bounds, inset, inset);
    
    self.swatch = [[KDGColorSwatch alloc] initWithFrame:swatchBounds];
    self.swatch.swatchColor = _swatchColor;
    
    [self addSubview:self.swatch];
}

- (void)setSwatchColor:(UIColor *)color
{
    _swatchColor = color;
    self.swatch.swatchColor = color;
}

@end
