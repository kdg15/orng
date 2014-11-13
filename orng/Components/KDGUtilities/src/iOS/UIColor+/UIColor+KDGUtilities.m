//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIColor+KDGUtilities.h"

@implementation UIColor (KDGUtilities)

+ (UIColor *)kdgColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
}

+ (UIColor *)kdgColorWithString:(NSString *)string
{
    UIColor *color = [UIColor whiteColor];
    
    if (string)
    {
        NSArray *values = [string componentsSeparatedByString:@" "];
        if (values.count == 4)
        {
            CGFloat red   = [values[0] floatValue] / 255.0;
            CGFloat green = [values[1] floatValue] / 255.0;
            CGFloat blue  = [values[2] floatValue] / 255.0;
            CGFloat alpha = [values[3] floatValue] / 255.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        }
    }
    
    return color;
}

- (NSString *)kdgAsString;
{
    CGFloat red, green, blue, alpha;
    
    [self kdgGetRed:&red green:&green blue:&blue alpha:&alpha];

    NSInteger r = red   * 255;
    NSInteger g = green * 255;
    NSInteger b = blue  * 255;
    NSInteger a = alpha * 255;
    
    return [NSString stringWithFormat:@"%d %d %d %d", r, g, b, a];
}

- (void)kdgGetRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
{
    CGFloat white, r, g, b, a;

    if ([self getRed:&r green:&g blue:&b alpha:&a])
    {
        *red   = r;
        *green = g;
        *blue  = b;
        *alpha = a;
    }
    else if ([self getWhite:&white alpha:&a])
    {
        *red   = white;
        *green = white;
        *blue  = white;
        *alpha = a;
    }
    else
    {
        *red   = 0.0;
        *green = 0.0;
        *blue  = 0.0;
        *alpha = 1.0;
        NSLog(@"# error: couldn't get red, green, and blue components.");
    }
}

- (void)kdgGetHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha
{
    CGFloat white, h, s, b, a;
    
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    {
        *hue        = h;
        *saturation = s;
        *brightness = b;
        *alpha      = a;
    }
    else if ([self getWhite:&white alpha:&a])
    {
        *hue        = 0.0;
        *saturation = 0.0;
        *brightness = white;
        *alpha      = a;
    }
    else
    {
        *hue        = 0.0;
        *saturation = 0.0;
        *brightness = 0.0;
        *alpha      = 1.0;
        NSLog(@"# error: couldn't get hue, saturation, and brightness components.");
    }
}

- (BOOL)kdgIsEqualToColor:(UIColor *)color
{
    NSString *aString = [self kdgAsString];
    NSString *bString = [color kdgAsString];
    return [aString isEqualToString:bString];
}

- (UIColor *)kdgLighterColor
{
    UIColor *color = [UIColor colorWithCGColor:self.CGColor];

    CGFloat hue, saturation, brightness, alpha;

    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        color = [UIColor colorWithHue:hue
                           saturation:saturation
                           brightness:MIN(brightness * 1.333, 1.0)
                                alpha:alpha];
    }

    return color;
}

- (UIColor *)kdgDarkerColor
{
    UIColor *color = [UIColor colorWithCGColor:self.CGColor];

    CGFloat hue, saturation, brightness, alpha;

    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        color = [UIColor colorWithHue:hue
                           saturation:saturation
                           brightness:brightness * 0.75
                                alpha:alpha];
    }

    return color;
}

- (UIColor *)kdgColorWithHue:(CGFloat)hue
{
    CGFloat h, s, b, alpha;
    [self kdgGetHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:s brightness:b alpha:alpha];
}

- (UIColor *)kdgColorWithSaturation:(CGFloat)saturation
{
    CGFloat h, s, b, alpha;
    [self kdgGetHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:alpha];
}

- (UIColor *)kdgColorWithBrightness:(CGFloat)brightness
{
    CGFloat h, s, b, alpha;
    [self kdgGetHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:h saturation:s brightness:brightness alpha:alpha];
}

#pragma mark - tests;

+ (void)runTests
{
    [self testColorStrings];
}

+ (void)testColorStrings
{
    NSInteger failures = 0;
    
    NSArray *colorStrings = @[@"255 255 255 255",
                              @"0 0 0 255",
                              @"255 0 0 255",
                              @"0 255 0 255",
                              @"0 0 255 255"
                              ];
    
    for (NSString *colorString in colorStrings)
    {
        UIColor *color = [UIColor kdgColorWithString:colorString];
        NSString *resultString = [color kdgAsString];
        
        if (![resultString isEqualToString:colorString])
        {
            failures++;
            NSLog(@"### test failure: expected %@, got %@", colorString, resultString);
        }
    }
    
    for (NSInteger a = 0; a <= 255; a++)
    {
        for (NSInteger c = 0; c <= 255; c++)
        {
            NSString *colorString = [NSString stringWithFormat:@"%d %d %d %d", c, c, c, a];
            UIColor *color = [UIColor kdgColorWithString:colorString];
            NSString *resultString = [color kdgAsString];
            
            if (![resultString isEqualToString:colorString])
            {
                failures++;
                NSLog(@"### test failure: expected %@, got %@", colorString, resultString);
            }
            
        }
    }
    
    NSLog(@"--- testColorStrings: %@", failures == 0 ? @"all passed" : [NSString stringWithFormat:@"%d failures", failures]);
}

@end
