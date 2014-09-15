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
+ (UIColor *)colorFromNSString:(NSString *)string
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

@end
