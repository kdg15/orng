//
//  DataModel.m
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "DataModel.h"
#import "UIColor+Utilities.h"
#import "NSString+Utilities.h"

static NSString * const kPrefClockTextColor = @"clockTextColor";
static NSString * const kPrefClockBackgroundColor = @"clockBackgroundColor";

@implementation DataModel

+ (UIColor *)clockTextColor
{
    UIColor *color = [UIColor whiteColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [userDefaults stringForKey:kPrefClockTextColor];
    if (colorString)
    {
        color = [UIColor colorFromNSString:colorString];
    }

    return color;
}

+ (UIColor *)clockBackgroundColor
{
    UIColor *color = [UIColor blackColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [userDefaults stringForKey:kPrefClockBackgroundColor];
    if (colorString)
    {
        color = [UIColor colorFromNSString:colorString];
    }

    return color;
}

@end
