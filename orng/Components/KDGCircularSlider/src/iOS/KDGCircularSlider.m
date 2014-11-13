//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCircularSlider.h"
#import "KDGCircularSliderKnobLayer.h"
#import "KDGUtilities.h"

static CGSize const kKnobSize = { 16, 16 };
static CGFloat const kDefaultSlopDistance  = 30.0;

@interface KDGCircularSlider ()
{
    CALayer *_trackLayer;
    KDGCircularSliderKnobLayer *_knobLayer;
}

//@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic, strong) UILabel *label;

@end

@implementation KDGCircularSlider

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
    _angle = 0;
    _minimum = 0.0;
    _maximum = 1.0;
    _value = _minimum;

    _slopDistance = kDefaultSlopDistance;

    _trackLayer = [CALayer layer];
    _trackLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_trackLayer];

    _knobLayer = [KDGCircularSliderKnobLayer layer];
    _knobLayer.slider = self;
    _knobLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:_knobLayer];

    [self setLayerFrames];
    _trackLayer.frame = self.bounds;

    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.text = @"0";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];

    [self addSubview:self.label];

    /*
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
     */
}

- (void)setLayerFrames
{
    CGPoint position = [self pointFromAngle:self.angle];
    //NSLog(@"self.angle = %d, point = %.1f, %.1f", self.angle, position.x, position.y);
    _knobLayer.frame = CGRectMake(position.x - 0.5 * kKnobSize.width,
                                  position.y - 0.5 * kKnobSize.height,
                                  kKnobSize.width,
                                  kKnobSize.height);

    //[_trackLayer setNeedsDisplay];
    [_knobLayer setNeedsDisplay];
}

#pragma mark - properties

- (CGFloat)value
{
    return [self valueFromAngle:self.angle];
}

- (CGFloat)valueFromAngle:(NSInteger)angle
{
    //  0 at east - adjust by 0
    //  0 at north - adjust by 90
    //  0 at west - adjust by 180
    //  0 at south - adjust by 270
    NSInteger adjust = 270;

    angle -= adjust;
    if (angle < 0) angle += 360;
    angle = 359 - angle;

    CGFloat value = self.minimum + angle / 359.0 * (self.maximum - self.minimum);

    return value;
}

- (NSInteger)angleFromValue:(CGFloat)value
{
    NSInteger angle = floor(359.0 * (value - self.minimum) / (self.maximum - self.minimum));

    //  0 at east - adjust by 0
    //  0 at north - adjust by 90
    //  0 at west - adjust by 180
    //  0 at south - adjust by 270

    NSInteger adjust = 270;
    angle = 359 - angle;
    angle += adjust;
    if (angle >= 360) angle -= 360;

    return angle;
}

#pragma mark - highlight

- (void)highlight
{
    _trackLayer.backgroundColor = [UIColor purpleColor].CGColor;
}

- (void)unhighlight
{
    _trackLayer.backgroundColor = [UIColor blueColor].CGColor;
}

#pragma mark - point inside

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

    CGFloat distance = [self calculateDistanceFromCenter:point];
    result = (distance <= 0.5 * self.bounds.size.width);

    return result;
}

- (BOOL)pointInsideSlop:(CGPoint)point
{
    BOOL result = NO;

    CGFloat distance = [self calculateDistanceFromCenter:point];
    result = (distance <= (0.5 * self.bounds.size.width + self.slopDistance));

    return result;
}

#pragma mark - knob

-(void)angleFromPoint:(CGPoint)point
{
    CGPoint center = CGPointMake(0.5 * self.frame.size.width,
                                 0.5 * self.frame.size.height);

    float currentAngle = KDGAngleBetweenPoints(center, point);
    int angle = floor(currentAngle);
    self.angle = angle;

    self.label.text = [NSString stringWithFormat:@"%.1f", self.value];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self setLayerFrames];

    [CATransaction commit];
}

- (CGPoint)pointFromAngle:(int)angle
{
    CGPoint center = CGPointMake(0.5 * self.frame.size.width,
                                 0.5 * self.frame.size.height);

    CGFloat radius = 0.5 * self.frame.size.width;

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

    //NSInteger angle = [slider angleFromValue:slider.value];

    for (NSInteger angle = 0; angle < 360; angle += 15)
    {
        CGFloat value = [slider valueFromAngle:angle];
        NSLog(@"angle %3d, value %.3f, angle %d",
              angle, value, [slider angleFromValue:value]);
    }

//    for (CGFloat value = slider.minimum; value < slider.maximum; value += 0.1)
//    {
//        //slider.value = value;
//        NSLog(@"value %.3f, angle %d", value, [slider angleFromValue:value]);
//    }

    NSLog(@"--- testValue: %@", failures == 0 ? @"all passed" : [NSString stringWithFormat:@"%d failures", failures]);
}

@end
