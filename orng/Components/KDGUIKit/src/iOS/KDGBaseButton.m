//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGBaseButton.h"
#import "KDGUtilities.h"

static CGFloat const kDefaultBorderWidth   = 0.0;
static CGFloat const kDefaultShadowOpacity = 0.0;
static CGFloat const kDefaultSlopDistance  = 30.0;

//@implementation KDGColorSwatch
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    
//    if (self)
//    {
//        [self kdgColorSwatchInitialize];
//    }
//    
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self)
//    {
//        [self kdgColorSwatchInitialize];
//    }
//    
//    return self;
//}
//
//- (void)kdgColorSwatchInitialize
//{
//    _swatchColor = [UIColor colorWithWhite:255 / 255.0 alpha:1.0];
//    
//    self.layer.backgroundColor = _swatchColor.CGColor;
//    self.layer.cornerRadius = 0.5 * self.bounds.size.height;
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowRadius = 0.5;
//}
//
//- (void)setSwatchColor:(UIColor *)color
//{
//    _swatchColor = color;
//    self.layer.backgroundColor = color.CGColor;
//}
//
//@end

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

//@interface KDGButton ()
//
//@property (nonatomic, strong) UILabel *label;
//
//@end
//
//@implementation KDGButton
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    
//    if (self)
//    {
//        [self kdgButtonInitialize];
//    }
//    
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self)
//    {
//        [self kdgButtonInitialize];
//    }
//    
//    return self;
//}
//
//- (void)kdgButtonInitialize
//{
//    _textColor          = [UIColor whiteColor];
//    _textHighlightColor = [UIColor lightGrayColor];
//
//    self.label = [[UILabel alloc] initWithFrame:self.bounds];
//    self.label.text = @"kdg";
//    self.label.textAlignment = NSTextAlignmentCenter;
//    self.label.textColor = _textColor;
//    
//    [self addSubview:self.label];
//}
//
//- (void)setTextColor:(UIColor *)color
//{
//    _textColor = color;
//    self.label.textColor = color;
//}
//
//- (void)setText:(NSString *)text
//{
//    _text = text;
//    self.label.text = text;
//}
//
//- (void)highlight
//{
//    [super highlight];
//    self.label.textColor = _textHighlightColor;
//}
//
//- (void)unhighlight
//{
//    [super unhighlight];
//    self.label.textColor = _textColor;
//}
//
//@end

//@interface KDGColorSwatchButton ()
//
//@property (nonatomic, strong) KDGColorSwatch *swatch;
//
//@end
//
//@implementation KDGColorSwatchButton
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    
//    if (self)
//    {
//        [self kdgColorSwatchButtonInitialize];
//    }
//    
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self)
//    {
//        [self kdgColorSwatchButtonInitialize];
//    }
//    
//    return self;
//}
//
//- (void)kdgColorSwatchButtonInitialize
//{
//    _swatchColor = [UIColor whiteColor];
//    
//    CGFloat inset = 8.0;
//    CGRect swatchBounds = CGRectInset(self.bounds, inset, inset);
//    
//    self.swatch = [[KDGColorSwatch alloc] initWithFrame:swatchBounds];
//    self.swatch.swatchColor = _swatchColor;
//    
//    [self addSubview:self.swatch];
//}
//
//- (void)setSwatchColor:(UIColor *)color
//{
//    _swatchColor = color;
//    self.swatch.swatchColor = color;
//}
//
//@end
//
//@implementation KDGTestView
//
//typedef void (^voidBlock)(void);
//typedef float (^floatfloatBlock)(float);
//typedef UIColor * (^floatColorBlock)(float);
//
//-(CGPoint) pointForTrapezoidWithAngle:(float)a andRadius:(float)r  forCenter:(CGPoint)p{
//    return CGPointMake(p.x + r*cos(a), p.y + r*sin(a));
//}
//
//-(void)drawGradientInContext:(CGContextRef)ctx
//               startingAngle:(float)a
//                 endingAngle:(float)b
//                   intRadius:(floatfloatBlock)intRadiusBlock
//                   outRadius:(floatfloatBlock)outRadiusBlock
//           withGradientBlock:(floatColorBlock)colorBlock
//                  withSubdiv:(int)subdivCount
//                  withCenter:(CGPoint)center
//                   withScale:(float)scale
//{
//    float angleDelta = (b-a)/subdivCount;
//    float fractionDelta = 1.0/subdivCount;
//    
//    CGPoint p0,p1,p2,p3, p4,p5;
//    float currentAngle=a;
//    p4=p0 = [self pointForTrapezoidWithAngle:currentAngle andRadius:intRadiusBlock(0) forCenter:center];
//    p5=p3 = [self pointForTrapezoidWithAngle:currentAngle andRadius:outRadiusBlock(0) forCenter:center];
//    CGMutablePathRef innerEnveloppe=CGPathCreateMutable(),
//    outerEnveloppe=CGPathCreateMutable();
//    
//    CGPathMoveToPoint(outerEnveloppe, 0, p3.x, p3.y);
//    CGPathMoveToPoint(innerEnveloppe, 0, p0.x, p0.y);
//    CGContextSaveGState(ctx);
//    
//    CGContextSetLineWidth(ctx, 1);
//    
//    for (int i=0;i<subdivCount;i++)
//    {
//        float fraction = (float)i/subdivCount;
//        currentAngle=a+fraction*(b-a);
//        CGMutablePathRef trapezoid = CGPathCreateMutable();
//        
//        p1 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:intRadiusBlock(fraction+fractionDelta) forCenter:center];
//        p2 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:outRadiusBlock(fraction+fractionDelta) forCenter:center];
//        
//        CGPathMoveToPoint(trapezoid, 0, p0.x, p0.y);
//        CGPathAddLineToPoint(trapezoid, 0, p1.x, p1.y);
//        CGPathAddLineToPoint(trapezoid, 0, p2.x, p2.y);
//        CGPathAddLineToPoint(trapezoid, 0, p3.x, p3.y);
//        CGPathCloseSubpath(trapezoid);
//        
//        CGPoint centerofTrapezoid = CGPointMake((p0.x+p1.x+p2.x+p3.x)/4, (p0.y+p1.y+p2.y+p3.y)/4);
//        
//        CGAffineTransform t = CGAffineTransformMakeTranslation(-centerofTrapezoid.x, -centerofTrapezoid.y);
//        CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
//        CGAffineTransform concat = CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformInvert(t)));
//        CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(trapezoid, &concat);
//        
//        CGContextAddPath(ctx, scaledPath);
//        CGContextSetFillColorWithColor(ctx,colorBlock(fraction).CGColor);
//        CGContextSetStrokeColorWithColor(ctx, colorBlock(fraction).CGColor);
//        CGContextSetMiterLimit(ctx, 0);
//        
//        CGContextDrawPath(ctx, kCGPathFillStroke);
//        
//        CGPathRelease(trapezoid);
//        p0=p1;
//        p3=p2;
//        
//        CGPathAddLineToPoint(outerEnveloppe, 0, p3.x, p3.y);
//        CGPathAddLineToPoint(innerEnveloppe, 0, p0.x, p0.y);
//    }
//    CGContextSetLineWidth(ctx, 10);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextAddPath(ctx, outerEnveloppe);
//    CGContextAddPath(ctx, innerEnveloppe);
//    CGContextMoveToPoint(ctx, p0.x, p0.y);
//    CGContextAddLineToPoint(ctx, p3.x, p3.y);
//    CGContextMoveToPoint(ctx, p4.x, p4.y);
//    CGContextAddLineToPoint(ctx, p5.x, p5.y);
//    CGContextStrokePath(ctx);
//}
//
///*
//-(void)drawRect:(CGRect)rect
//{
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    [[UIColor whiteColor] set];
//    UIRectFill(self.bounds);
//    
//    CGRect r = self.bounds;
//    
//    r=CGRectInset(r, 60, 60);
//    
//    if (r.size.width > r.size.height)
//        r.size.width=r.size.height;
//    else r.size.height=r.size.width;
//    
//    float radius=r.size.width/2;
//    
//    [self drawGradientInContext:ctx  startingAngle:M_PI/16 endingAngle:2*M_PI-M_PI/16 intRadius:^float(float f) {
//        //        return 0*f + radius/2*(1-f);
//        return 200+10*sin(M_PI*2*f*7);
//        //        return 50+sqrtf(f)*200;
//        //        return radius/2;
//    } outRadius:^float(float f) {
//        //         return radius *f + radius/2*(1-f);
//        return radius;
//        //        return 300+10*sin(M_PI*2*f*17);
//    } withGradientBlock:^UIColor *(float f) {
//        
//        //        return [UIColor colorWithHue:f saturation:1 brightness:1 alpha:1];
//        float sr=90, sg=54, sb=255;
//        float er=218, eg=0, eb=255;
//        return [UIColor colorWithRed:(f*sr+(1-f)*er)/255. green:(f*sg+(1-f)*eg)/255. blue:(f*sb+(1-f)*eb)/255. alpha:1];
//        
//    } withSubdiv:256 withCenter:CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r)) withScale:1];
//    
//}
// */
//
//-(void)drawRect:(CGRect)dirtyRect
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    [[UIColor lightGrayColor] set];
//    
//    CGContextFillRect(ctx, [self bounds]);
//    
//    CGPoint center = KDGRectCenter(self.bounds);
//
//    float diameter = MIN(self.bounds.size.width, self.bounds.size.height);
//    int subdiv = 64;//512;
//    float innerRadius = 0.25 * diameter;
//    float outerRadius = 0.50 * diameter;
//    
//    //  length of inner arc.
//    float halfinteriorPerim = M_PI * innerRadius;
//    
//    //  length of outer arc.
//    float halfexteriorPerim = M_PI * outerRadius;
//    
//    NSLog(@"lengths of arc = %.3f, %.3f", halfexteriorPerim, halfinteriorPerim);
//
//    float smallBase = halfinteriorPerim / subdiv;
//    float largeBase = halfexteriorPerim / subdiv;
//    
//    NSLog(@"bases = %.3f, %.3f", largeBase, smallBase);
//    
//    UIBezierPath *cell = [UIBezierPath bezierPath];
//    
//    [cell moveToPoint:CGPointMake(- smallBase/2, innerRadius)];
//    [cell addLineToPoint:CGPointMake(+ smallBase/2, innerRadius)];
//    
//    [cell addLineToPoint:CGPointMake( largeBase /2 , outerRadius)];
//    [cell addLineToPoint:CGPointMake(-largeBase /2,  outerRadius)];
//    [cell closePath];
//    
//    float incr = M_PI / subdiv;
//    //CGContextTranslateCTM(ctx, +self.bounds.size.width / 2, +self.bounds.size.height / 2);
//    CGContextTranslateCTM(ctx, center.x, center.y);
//    
//    //CGContextScaleCTM(ctx, 0.9, 0.9);
//    CGContextScaleCTM(ctx, 1.0, 1.0);
//    CGContextRotateCTM(ctx, -M_PI/2);
//    CGContextRotateCTM(ctx, -incr / 2);
//    
//    for (int i=0; i < subdiv; i++)
//    {
//        // replace this color with a color extracted from your gradient object
//        [[UIColor colorWithHue:(float)i/subdiv saturation:1 brightness:1 alpha:1] set];
//        //[[UIColor colorWithHue:0.0 saturation:(float)i/subdiv brightness:1 alpha:1] set];
//        //[[UIColor colorWithHue:0.0 saturation:1 brightness:(float)i/subdiv alpha:1] set];
//        
//        [cell fill];
//        [cell stroke];
//        CGContextRotateCTM(ctx, -incr);
//    }
//}
//
//@end
