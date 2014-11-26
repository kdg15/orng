//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSlider.h"
#import "KDGCircularSliderTrackLayer.h"
#import "KDGCircularSliderKnobLayer.h"
#import "KDGUtilities.h"

static CGFloat const kDefaultKnobSize      =  8.0;
static CGFloat const kDefaultTrackSize     =  2.0;
static CGFloat const kDefaultTrackMargin   =  2.0;
static CGFloat const kDefaultSlopDistance  = 60.0;

@interface KDGCircularSlider ()

@property (nonatomic, strong) KDGCircularSliderTrackLayer *trackLayer;
@property (nonatomic, strong) KDGCircularSliderKnobLayer *knobLayer;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat originalAngle;
@property (nonatomic, assign) CGPoint lastTouchPoint;

@end

@implementation KDGCircularSlider

@synthesize value = _value;

#pragma mark - initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        [self kdgCircularSliderInitialize];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self kdgCircularSliderInitialize];
    }

    return self;
}

- (void)kdgCircularSliderInitialize
{
    _angle = 0.0;
    _minimum = 0.0;
    _maximum = 1.0;
    _value = _minimum;
    _orientation = 270.0;

    _knobSize = kDefaultKnobSize;
    _trackSize = kDefaultTrackSize;
    _trackMargin = kDefaultTrackMargin;
    _slopDistance = kDefaultSlopDistance;

    _color               = [UIColor lightGrayColor];
    _highlightColor      = [UIColor grayColor];
    _trackColor          = [UIColor whiteColor];
    _trackHighlightColor = [UIColor whiteColor];
    _knobColor           = [UIColor whiteColor];
    _knobHighlightColor  = [UIColor darkGrayColor];
    _textColor           = [UIColor whiteColor];

    _trackLayer = [KDGCircularSliderTrackLayer layer];
    _trackLayer.slider = self;
    [self.layer addSublayer:_trackLayer];

    _knobLayer = [KDGCircularSliderKnobLayer layer];
    _knobLayer.slider = self;
    [self.layer addSublayer:_knobLayer];

    [self updateLayers];

    _formatString = @"%.0f";

    self.label = [[UILabel alloc] initWithFrame:[self actualBounds]];
    self.label.text = @"0";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = self.textColor;
    self.label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];

    [self addSubview:self.label];
}

#pragma mark - actual bounds

- (CGRect)actualBounds
{
    CGRect bounds = self.bounds;

    if (bounds.size.width < bounds.size.height)
    {
        bounds.origin.y = 0.5 * (bounds.size.height - bounds.size.width);
        bounds.size.height = bounds.size.width;
    }
    else if (bounds.size.height < bounds.size.width)
    {
        bounds.origin.x = 0.5 * (bounds.size.width - bounds.size.height);
        bounds.size.width = bounds.size.height;
    }

    return bounds;
}

#pragma mark - properties

- (CGFloat)value
{
    return [self valueFromAngle:self.angle];
}

- (void)setValue:(CGFloat)value
{
    if      (value < self.minimum) value = self.minimum;
    else if (value > self.maximum) value = self.maximum;
    
    _value = value;
    
    self.angle = [self angleFromValue:value];
    
    [self updateKnob];
    [self updateLabel];
}

- (UIColor *)backgroundColor
{
    return _color;
}

- (void)setBackgroundColor:(UIColor *)color
{
    _color = color;
}

#pragma mark - font

- (void)setFont:(UIFont *)font
{
    self.label.font = font;
}

#pragma mark - draw blocks

- (void)setTrackDrawBlock:(KDGLayerDrawBlock)drawBlock
{
    self.trackLayer.drawBlock = drawBlock;
}

#pragma mark - highlight

- (void)highlight
{
    _trackLayer.highlighted = YES;
    _knobLayer.highlighted = YES;
    [self updateKnob];
}

- (void)unhighlight
{
    _trackLayer.highlighted = NO;
    _knobLayer.highlighted = NO;
    [self updateKnob];
}

#pragma mark - point inside

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point
{
    CGRect bounds = [self actualBounds];
    CGPoint c = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGFloat dx = point.x - c.x;
    CGFloat dy = point.y - c.y;
    CGFloat d = sqrtf(dx * dx + dy * dy);

    return d;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL result = NO;

    CGRect bounds = [self actualBounds];
    CGFloat distance = [self calculateDistanceFromCenter:point];
    result = (distance <= 0.5 * bounds.size.width);

    return result;
}

- (BOOL)pointInsideSlop:(CGPoint)point
{
    BOOL result = NO;

    CGRect bounds = [self actualBounds];
    CGFloat distance = [self calculateDistanceFromCenter:point];
    result = (distance <= (0.5 * bounds.size.width + self.slopDistance));

    return result;
}

#pragma mark - ui

- (void)updateLayers
{
    CGRect bounds = [self actualBounds];
    _trackLayer.frame = bounds;
    
    CGPoint position = [self pointFromAngle:self.angle];
    CGFloat knobSize = self.knobSize;

    _knobLayer.frame = CGRectMake(position.x - 0.5 * knobSize,
                                  position.y - 0.5 * knobSize,
                                  knobSize,
                                  knobSize);
    
    [_trackLayer setNeedsDisplay];
    [_knobLayer setNeedsDisplay];
}

- (void)updateKnob
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self updateLayers];
    [CATransaction commit];
}

- (void)updateLabel
{
    self.label.text = [NSString stringWithFormat:self.formatString, self.value];
}

#pragma mark - knob

- (CGFloat)valueFromAngle:(CGFloat)angle
{
    CGFloat adjust = self.orientation;
    
    angle -= adjust;
    if (angle < 0) angle += 360.0;
    angle = 359.0 - angle;
    
    CGFloat value = self.minimum + angle * (self.maximum - self.minimum) / 359.0;
    
    return value;
}

- (CGFloat)angleFromValue:(CGFloat)value
{
    CGFloat angle = 359.0 * (value - self.minimum) / (self.maximum - self.minimum);
    
    CGFloat adjust = self.orientation;
    angle = 359.0 - angle;
    angle += adjust;
    if (angle >= 360.0) angle -= 360.0;
    
    return angle;
}

-(void)angleFromPoint:(CGPoint)point
{
    CGPoint center = CGPointMake(0.5 * self.frame.size.width,
                                 0.5 * self.frame.size.height);

    float currentAngle = KDGAngleBetweenPoints(center, point);
    int angle = floor(currentAngle);
    self.angle = angle;

    [self updateKnob];
    [self updateLabel];
}

- (CGPoint)pointFromAngle:(CGFloat)angle
{
    CGPoint center = CGPointMake(0.5 * self.frame.size.width,
                                 0.5 * self.frame.size.height);

    CGRect bounds = [self actualBounds];
    CGFloat radius = 0.5 * (bounds.size.width - self.knobSize) - self.trackMargin;

    CGPoint result;
    result.y = round(center.y + radius * sin(DEGREES_TO_RADIANS(-angle))) ;
    result.x = round(center.x + radius * cos(DEGREES_TO_RADIANS(-angle)));
    
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

    [self angleFromPoint:touchPoint];

    [self sendActionsForControlEvents:UIControlEventValueChanged];

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

#pragma mark - tests

+ (void)runTests
{
    [self testValue];
}

+ (void)testValue
{
    NSInteger failures = 0;

    CGRect sliderFrame = CGRectMake(0, 0, 100, 100);
    KDGCircularSlider *slider = [[KDGCircularSlider alloc] initWithFrame:sliderFrame];
    slider.minimum = 0.0;
    slider.maximum = 1.0;
    slider.value = slider.minimum;

    for (CGFloat angle = 0.0; angle < 360.0; angle += 15.0)
    {
        CGFloat value = [slider valueFromAngle:angle];
        CGFloat resultAngle = [slider angleFromValue:value];
        if (resultAngle != angle)
        {
            failures++;
            NSLog(@"### test failure: expected %.3f, got %.3f", angle, resultAngle);
        }
    }

    NSLog(@"--- testValue: %@", failures == 0 ? @"all passed" : [NSString stringWithFormat:@"%ld failures", failures]);
}

@end
