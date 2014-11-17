//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGTestView.h"
#import "KDGUtilities.h"

@implementation KDGTestView

typedef void (^voidBlock)(void);
typedef float (^floatfloatBlock)(float);
typedef UIColor * (^floatColorBlock)(float);

-(CGPoint) pointForTrapezoidWithAngle:(float)a andRadius:(float)r  forCenter:(CGPoint)p{
    return CGPointMake(p.x + r*cos(a), p.y + r*sin(a));
}

-(void)drawGradientInContext:(CGContextRef)ctx
               startingAngle:(float)a
                 endingAngle:(float)b
                   intRadius:(floatfloatBlock)intRadiusBlock
                   outRadius:(floatfloatBlock)outRadiusBlock
           withGradientBlock:(floatColorBlock)colorBlock
                  withSubdiv:(int)subdivCount
                  withCenter:(CGPoint)center
                   withScale:(float)scale
{
    float angleDelta = (b-a)/subdivCount;
    float fractionDelta = 1.0/subdivCount;
    
    CGPoint p0,p1,p2,p3, p4,p5;
    float currentAngle=a;
    p4=p0 = [self pointForTrapezoidWithAngle:currentAngle andRadius:intRadiusBlock(0) forCenter:center];
    p5=p3 = [self pointForTrapezoidWithAngle:currentAngle andRadius:outRadiusBlock(0) forCenter:center];
    CGMutablePathRef innerEnveloppe=CGPathCreateMutable(),
    outerEnveloppe=CGPathCreateMutable();
    
    CGPathMoveToPoint(outerEnveloppe, 0, p3.x, p3.y);
    CGPathMoveToPoint(innerEnveloppe, 0, p0.x, p0.y);
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, 1);
    
    for (int i=0;i<subdivCount;i++)
    {
        float fraction = (float)i/subdivCount;
        currentAngle=a+fraction*(b-a);
        CGMutablePathRef trapezoid = CGPathCreateMutable();
        
        p1 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:intRadiusBlock(fraction+fractionDelta) forCenter:center];
        p2 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:outRadiusBlock(fraction+fractionDelta) forCenter:center];
        
        CGPathMoveToPoint(trapezoid, 0, p0.x, p0.y);
        CGPathAddLineToPoint(trapezoid, 0, p1.x, p1.y);
        CGPathAddLineToPoint(trapezoid, 0, p2.x, p2.y);
        CGPathAddLineToPoint(trapezoid, 0, p3.x, p3.y);
        CGPathCloseSubpath(trapezoid);
        
        CGPoint centerofTrapezoid = CGPointMake((p0.x+p1.x+p2.x+p3.x)/4, (p0.y+p1.y+p2.y+p3.y)/4);
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(-centerofTrapezoid.x, -centerofTrapezoid.y);
        CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
        CGAffineTransform concat = CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformInvert(t)));
        CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(trapezoid, &concat);
        
        CGContextAddPath(ctx, scaledPath);
        CGContextSetFillColorWithColor(ctx,colorBlock(fraction).CGColor);
        CGContextSetStrokeColorWithColor(ctx, colorBlock(fraction).CGColor);
        CGContextSetMiterLimit(ctx, 0);
        
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGPathRelease(trapezoid);
        p0=p1;
        p3=p2;
        
        CGPathAddLineToPoint(outerEnveloppe, 0, p3.x, p3.y);
        CGPathAddLineToPoint(innerEnveloppe, 0, p0.x, p0.y);
    }
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddPath(ctx, outerEnveloppe);
    CGContextAddPath(ctx, innerEnveloppe);
    CGContextMoveToPoint(ctx, p0.x, p0.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextMoveToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextStrokePath(ctx);
}

/*
-(void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    UIRectFill(self.bounds);
    
    CGRect r = self.bounds;
    
    r=CGRectInset(r, 60, 60);
    
    if (r.size.width > r.size.height)
        r.size.width=r.size.height;
    else r.size.height=r.size.width;
    
    float radius=r.size.width/2;
    
    [self drawGradientInContext:ctx  startingAngle:M_PI/16 endingAngle:2*M_PI-M_PI/16 intRadius:^float(float f) {
        //        return 0*f + radius/2*(1-f);
        return 200+10*sin(M_PI*2*f*7);
        //        return 50+sqrtf(f)*200;
        //        return radius/2;
    } outRadius:^float(float f) {
        //         return radius *f + radius/2*(1-f);
        return radius;
        //        return 300+10*sin(M_PI*2*f*17);
    } withGradientBlock:^UIColor *(float f) {
        
        //        return [UIColor colorWithHue:f saturation:1 brightness:1 alpha:1];
        float sr=90, sg=54, sb=255;
        float er=218, eg=0, eb=255;
        return [UIColor colorWithRed:(f*sr+(1-f)*er)/255. green:(f*sg+(1-f)*eg)/255. blue:(f*sb+(1-f)*eb)/255. alpha:1];
        
    } withSubdiv:256 withCenter:CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r)) withScale:1];
    
}
 */

-(void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [[UIColor lightGrayColor] set];
    
    CGContextFillRect(ctx, [self bounds]);
    
    CGPoint center = KDGRectCenter(self.bounds);

    float diameter = MIN(self.bounds.size.width, self.bounds.size.height);
    int subdiv = 64;//512;
    float innerRadius = 0.25 * diameter;
    float outerRadius = 0.50 * diameter;
    
    //  length of inner arc.
    float halfinteriorPerim = M_PI * innerRadius;
    
    //  length of outer arc.
    float halfexteriorPerim = M_PI * outerRadius;
    
    NSLog(@"lengths of arc = %.3f, %.3f", halfexteriorPerim, halfinteriorPerim);

    float smallBase = halfinteriorPerim / subdiv;
    float largeBase = halfexteriorPerim / subdiv;
    
    NSLog(@"bases = %.3f, %.3f", largeBase, smallBase);
    
    UIBezierPath *cell = [UIBezierPath bezierPath];
    
    [cell moveToPoint:CGPointMake(- smallBase/2, innerRadius)];
    [cell addLineToPoint:CGPointMake(+ smallBase/2, innerRadius)];
    
    [cell addLineToPoint:CGPointMake( largeBase /2 , outerRadius)];
    [cell addLineToPoint:CGPointMake(-largeBase /2,  outerRadius)];
    [cell closePath];
    
    float incr = M_PI / subdiv;
    //CGContextTranslateCTM(ctx, +self.bounds.size.width / 2, +self.bounds.size.height / 2);
    CGContextTranslateCTM(ctx, center.x, center.y);
    
    //CGContextScaleCTM(ctx, 0.9, 0.9);
    CGContextScaleCTM(ctx, 1.0, 1.0);
    CGContextRotateCTM(ctx, -M_PI/2);
    CGContextRotateCTM(ctx, -incr / 2);
    
    for (int i=0; i < subdiv; i++)
    {
        // replace this color with a color extracted from your gradient object
        [[UIColor colorWithHue:(float)i/subdiv saturation:1 brightness:1 alpha:1] set];
        //[[UIColor colorWithHue:0.0 saturation:(float)i/subdiv brightness:1 alpha:1] set];
        //[[UIColor colorWithHue:0.0 saturation:1 brightness:(float)i/subdiv alpha:1] set];
        
        [cell fill];
        [cell stroke];
        CGContextRotateCTM(ctx, -incr);
    }
}

@end