//
//  UIColor+Utilities.m
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)

//  String must be 4 float values separated by a space representing the red,
//  green, blue, and alpha components.
//  For exampe: "0.5 0.0 0.25 1.0"
//
+ (UIColor *)colorWithString:(NSString *)string
{
    UIColor *color = [UIColor whiteColor];

    if (string)
    {
        NSArray *values = [string componentsSeparatedByString:@" "];
        if (values.count == 4)
        {
            CGFloat red   = [values[0] floatValue];
            CGFloat green = [values[1] floatValue];
            CGFloat blue  = [values[2] floatValue];
            CGFloat alpha = [values[3] floatValue];
            color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        }
    }

    return color;
}

//  Returned string is 4 float values separated by a space representing the red,
//  green, blue, and alpha components.
//  For exampe: "0.5 0.0 0.25 1.0"
//
- (NSString *)colorString;
{
    NSString *colorString = @"0.0 0.0 0.0 1.0";

    CGFloat white, red, green, blue, alpha;

    if ([self getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        colorString = [NSString stringWithFormat:@"%.3f %.3f %.3f %.3f", red, green, blue, alpha];
    }
    else if ([self getWhite:&white alpha:&alpha])
    {
        colorString = [NSString stringWithFormat:@"%.3f %.3f %.3f %.3f", white, white, white, alpha];
    }
    else
    {
        NSLog(@"# error: couldn't convert color to string.");
    }

    return colorString;
}

- (BOOL)isEqualToColor:(UIColor *)color
{
    NSString *aString = [self colorString];
    NSString *bString = [color colorString];
    return [aString isEqualToString:bString];
}

- (UIColor *)lighterColor
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

- (UIColor *)darkerColor
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

@end
