//
//  DataModel.m
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "DataModel.h"
#import "UIColor+Utilities.h"

static NSString * const kPrefClockFontName = @"clockFontName";
static NSString * const kPrefClockTextColor = @"clockTextColor";
static NSString * const kPrefClockBackgroundColor = @"clockBackgroundColor";

@implementation DataModel

+ (NSString *)clockFontName
{
    NSString *fontName = @"Avenir-Light";

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:kPrefClockFontName];
    if (string)
    {
        fontName = string;
    }

    return fontName;
}

+ (void)setClockFontName:(NSString *)fontName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:fontName forKey:kPrefClockFontName];
}

+ (UIColor *)clockTextColor
{
    UIColor *color = [UIColor whiteColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:kPrefClockTextColor];
    if (string)
    {
        color = [UIColor colorWithString:string];
    }

    return color;
}

+ (void)setClockTextColor:(UIColor *)color
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [color colorString];
    [userDefaults setObject:colorString forKey:kPrefClockTextColor];
}

+ (UIColor *)clockBackgroundColor
{
    UIColor *color = [UIColor blackColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:kPrefClockBackgroundColor];
    if (string)
    {
        color = [UIColor colorWithString:string];
    }

    return color;
}

+ (void)setClockBackgroundColor:(UIColor *)color
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [color colorString];
    [userDefaults setObject:colorString forKey:kPrefClockBackgroundColor];
}

@end
