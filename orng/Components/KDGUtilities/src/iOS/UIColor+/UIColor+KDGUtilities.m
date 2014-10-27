//
//  UIColor+KDGUtilities.m
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIColor+KDGUtilities.h"

@implementation UIColor (KDGUtilities)

+ (UIColor *)kdgColorWithString:(NSString *)string
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

- (NSString *)kdgColorString;
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

- (BOOL)kdgIsEqualToColor:(UIColor *)color
{
    NSString *aString = [self kdgColorString];
    NSString *bString = [color kdgColorString];
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

@end
