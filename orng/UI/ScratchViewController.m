//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ScratchViewController.h"
#import "CommandSystem.h"
#import "KDGBaseButton.h"
#import "KDGCircularSlider.h"
#import "KDGUtilities.h"

@interface ScratchViewController ()

@end

@implementation ScratchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CommandEngine sharedInstance] addResponder:self];

    [self setUp];
}

- (void)dealloc
{
    [[CommandEngine sharedInstance] removeResponder:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUp
{
    CGRect testFrame = CGRectMake(10, 60, 100, 100);
    KDGTestView *testView = [[KDGTestView alloc] initWithFrame:testFrame];
    [self.view addSubview:testView];
    
    CGRect sliderFrame = CGRectMake(120, 280, 60, 60);
    KDGCircularSlider *slider = [[KDGCircularSlider alloc] initWithFrame:sliderFrame];
    slider.minimum = 0.0;
    slider.maximum = 360.0;
    slider.value = slider.minimum;
    
    [slider setTrackDrawBlock:^(CALayer *layer, CGContextRef context) {
        
        CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
        CGContextFillEllipseInRect(context, layer.bounds);
        
        CGRect bounds = CGRectInset(layer.bounds, 4, 4);
        CGPoint center = KDGRectCenter(bounds);
        
        static CGFloat const kThickness = 12;
        static CGFloat const kLineWidth = 1;
        static CGFloat const kShadowWidth = 4;
        
        CGContextAddArc(context,
                        center.x, center.y,
                        (bounds.size.width - kThickness - kLineWidth) / 2,
                        -7 * M_PI / 8,//M_PI,
                        -1 * M_PI / 8,//0,
                        NO);
        CGContextSetLineWidth(context, kThickness);
        CGContextSetLineCap(context, kCGLineCapRound/*kCGLineCapButt*/);
        CGContextReplacePathWithStrokedPath(context);
        
        //  Save the path so we can draw an outline of it after the fill.
        //  We need to save it because CGContextClip will reset the current path.
        //
        CGPathRef path = CGContextCopyPath(context);
        
        /*
         CGContextSetShadowWithColor(gc,
         CGSizeMake(0, kShadowWidth / 2), kShadowWidth / 2,
         [UIColor colorWithWhite:0 alpha:0.3].CGColor);
         */
        
        //CGContextBeginTransparencyLayer(gc, 0); {
        
        CGContextSaveGState(context); {
            
            CGFloat colors [] =
            {
                1.0, 0.0, 0.0, 1.0,
                0.0, 0.0, 1.0, 1.0
            };
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
            CGColorSpaceRelease(colorSpace), colorSpace = NULL;
            
            CGRect bbox = CGContextGetPathBoundingBox(context);
            CGPoint start = bbox.origin;
            CGPoint end = CGPointMake(CGRectGetMaxX(bbox), CGRectGetMaxY(bbox));
            if (bbox.size.width > bbox.size.height)
            {
                end.y = start.y;
            }
            else
            {
                end.x = start.x;
            }
            
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient, start, end, 0);
            CGGradientRelease(gradient);
            
        } CGContextRestoreGState(context);
        
        
        CGContextAddPath(context, path);
        CGPathRelease(path);
        
        CGContextSetLineWidth(context, kLineWidth);
        CGContextSetLineJoin(context, kCGLineJoinMiter);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextStrokePath(context);
        
        //} CGContextEndTransparencyLayer(gc);
        
        /*
         CGPoint startPoint = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
         CGPoint endPoint = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
         CGPoint centerPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
         CGFloat radius = 0.5 * bounds.size.height;
         CGFloat startAngle = 0.0;
         CGFloat endAngle = M_PI;
         */
        
        /*
         CGMutablePathRef arc = CGPathCreateMutable();
         CGPathMoveToPoint(arc, NULL, startPoint.x, startPoint.y);
         CGPathAddArc(arc, NULL,
         centerPoint.x, centerPoint.y,
         radius,
         startAngle,
         endAngle,
         NO);
         
         CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
         CGContextSetLineWidth(context, 2.0);
         CGContextAddPath(context, arc);
         CGContextStrokePath(context);
         CGPathRelease(arc);
         */
        
        /*
         UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint
         radius:radius
         startAngle:startAngle
         endAngle:endAngle
         clockwise:NO];
         
         CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
         CGContextSetLineWidth(context, 1.0);
         CGContextAddPath(context, path.CGPath);
         CGContextStrokePath(context);
         
         
         CGPathRef strokedArc = CGPathCreateCopyByStrokingPath(path.CGPath, NULL,
         6,
         kCGLineCapRound,//kCGLineCapButt,
         kCGLineJoinMiter,
         10);
         
         CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
         CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
         CGContextSetLineWidth(context, 1.0);
         CGContextAddPath(context, strokedArc);
         CGContextDrawPath(context, kCGPathFillStroke);
         
         
         CGFloat colors [] = {
         1.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0
         };
         
         CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
         CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
         CGColorSpaceRelease(baseSpace), baseSpace = NULL;
         
         CGContextSaveGState(context);
         CGContextAddPath(context, strokedArc);
         CGContextClip(context);
         
         CGRect boundingBox = CGPathGetBoundingBox(strokedArc);
         CGPoint gradientStart = CGPointMake(0, CGRectGetMinY(boundingBox));
         CGPoint gradientEnd   = CGPointMake(0, CGRectGetMaxY(boundingBox));
         
         CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, 0);
         CGGradientRelease(gradient), gradient = NULL;
         CGContextRestoreGState(context);
         
         CGPathRelease(strokedArc);
         */
        
        /*
         CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
         
         CGFloat comps[] = {1.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0};
         CGFloat locs[] = {0, 1};
         CGGradientRef gradient = CGGradientCreateWithColorComponents(space, comps, locs, 2);
         
         CGPoint startCenter = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
         CGPoint endCenter = startCenter;
         CGFloat startRadius = 0;
         CGFloat endRadius = 0.5 * layer.bounds.size.width;
         
         CGGradientDrawingOptions options = 0;
         
         CGContextDrawRadialGradient(context,
         gradient,
         startCenter,
         startRadius,
         endCenter,
         endRadius,
         options);
         
         CGGradientRelease(gradient);
         */
        
        /*
         CGFloat colors [] = {
         1.0, 1.0, 1.0, 1.0,
         1.0, 0.0, 0.0, 1.0
         };
         
         CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
         CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
         CGColorSpaceRelease(baseSpace), baseSpace = NULL;
         
         CGContextSetLineWidth(context, 40);
         CGContextSetLineJoin(context, kCGLineJoinRound);
         CGContextSetLineCap(context, kCGLineCapRound);
         
         UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds];
         CGContextAddPath(context, path.CGPath);
         //CGContextAddPath(context, [self pathForOverlayForMapRect:mapRect].CGPath);
         CGContextReplacePathWithStrokedPath(context);
         CGContextClip(context);
         
         //[self updateTouchablePathForMapRect:mapRect];
         
         // Define the start and end points for the gradient
         // This determines the direction in which the gradient is drawn
         CGRect rect = layer.bounds;
         CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
         CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
         
         CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
         CGGradientRelease(gradient), gradient = NULL;
         */
        
        /*
         CGFloat colors [] = {
         1.0, 1.0, 1.0, 1.0,
         1.0, 0.0, 0.0, 1.0
         };
         
         CGRect rect = layer.bounds;
         
         CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
         CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
         CGColorSpaceRelease(baseSpace), baseSpace = NULL;
         
         //CGContextRef context = UIGraphicsGetCurrentContext();
         
         CGContextSaveGState(context);
         CGContextAddEllipseInRect(context, rect);
         CGContextClip(context);
         
         CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
         CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
         
         CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
         CGGradientRelease(gradient), gradient = NULL;
         
         CGContextRestoreGState(context);
         
         CGContextAddEllipseInRect(context, rect);
         CGContextDrawPath(context, kCGPathStroke);
         */
    }];
    
    /*
     slider.backgroundColor = [UIColor appLightBlueColor];
     slider.highlightColor = [UIColor appBlueColor];
     slider.trackColor = [UIColor whiteColor];
     slider.trackHighlightColor = [UIColor lightGrayColor];
     slider.knobColor = [UIColor whiteColor];
     slider.knobHighlightColor = [UIColor appOrangeColor];
     */
    
    [self.view addSubview:slider];
    
    /*
     [slider addTarget:self action:@selector(sliderTouchDownAction:)        forControlEvents:UIControlEventTouchDown];
     [slider addTarget:self action:@selector(sliderTouchUpInsideAction:)    forControlEvents:UIControlEventTouchUpInside];
     [slider addTarget:self action:@selector(sliderTouchUpOutsideAction:)   forControlEvents:UIControlEventTouchUpOutside];
     [slider addTarget:self action:@selector(sliderTouchCancelAction:)      forControlEvents:UIControlEventTouchCancel];
     [slider addTarget:self action:@selector(sliderTouchDragInsideAction:)  forControlEvents:UIControlEventTouchDragInside];
     [slider addTarget:self action:@selector(sliderTouchDragOutsideAction:) forControlEvents:UIControlEventTouchDragOutside];
     [slider addTarget:self action:@selector(sliderTouchDragEnterAction:)   forControlEvents:UIControlEventTouchDragEnter];
     [slider addTarget:self action:@selector(sliderTouchDragExitAction:)    forControlEvents:UIControlEventTouchDragExit];
     */
    [slider addTarget:self action:@selector(sliderChangedAction:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - ui

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissScratchView]];
}

- (void)sliderChangedAction:(id)sender
{
    KDGCircularSlider *slider = (KDGCircularSlider *)sender;
    NSLog(@"sliderChanged %.3f", slider.value);
}

#pragma mark - command system

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];
    
    if ([command isEqualToCommand:[Command dismissScratchView]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
