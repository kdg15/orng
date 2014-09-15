//
//  NSString+Utilities.m
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

//  String must be 4 float values separated by a space representing the red,
//  green, blue, and alpha components.
//  For exampe: "0.5 0.0 0.25 1.0"
//
+ (NSString *)stringFromUIColor:(UIColor *)color
{
    NSString *colorString = @"0.0 0.0 0.0 1.0";

    CGFloat white, red, green, blue, alpha;

    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        NSLog(@"- log: string from rgb color: %.3f %.3f %.3f %.3f", red, green, blue, alpha);;
        colorString = [NSString stringWithFormat:@"%.3f %.3f %.3f %.3f", red, green, blue, alpha];
    }
    else if ([color getWhite:&white alpha:&alpha])
    {
        NSLog(@"- log: string from greyscale color: %.3f %.3f", white, alpha);;
        colorString = [NSString stringWithFormat:@"%.3f %.3f %.3f %.3f", white, white, white, alpha];
    }
    else
    {
        NSLog(@"# error: couldn't convert color to string.");
    }

    return colorString;
}

@end
