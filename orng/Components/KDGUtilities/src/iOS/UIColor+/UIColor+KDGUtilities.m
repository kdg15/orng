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
    NSString *colorString = @"0 0 0 255";
    
    CGFloat white, red, green, blue, alpha;
    
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        NSInteger r = red   * 255;
        NSInteger g = green * 255;
        NSInteger b = blue  * 255;
        NSInteger a = alpha * 255;
        
        colorString = [NSString stringWithFormat:@"%d %d %d %d", r, g, b, a];
    }
    else if ([self getWhite:&white alpha:&alpha])
    {
        NSInteger w = white * 255;
        NSInteger a = alpha * 255;
        colorString = [NSString stringWithFormat:@"%d %d %d %d", w, w, w, a];
    }
    else
    {
        NSLog(@"# error: couldn't convert color to string.");
    }
    
    return colorString;
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
