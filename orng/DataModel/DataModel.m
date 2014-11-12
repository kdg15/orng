//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "DataModel.h"
#import "UIColor+KDGUtilities.h"

static NSString * const kPrefClockFontName           = @"orngPrefClockFontName";
static NSString * const kPrefClockTextColor          = @"orngPrefClockTextColor";
static NSString * const kPrefClockBackgroundColor    = @"orngPrefClockBackgroundColor";
static NSString * const kPrefBackDoorPrompt          = @"orngPrefBackDoorPrompt";
static NSString * const kPrefBackDoorBackgroundColor = @"orngPrefBackDoorBackgroundColor";

@implementation DataModel

+ (NSString *)getStringPref:(NSString *)prefKey defaultValue:(NSString *)defaultValue
{
    NSString *result = defaultValue;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:prefKey];
    if (string)
    {
        result = string;
    }

    return result;
}

+ (void)setStringPref:(NSString *)prefKey value:(NSString *)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:prefKey];
}

+ (UIColor *)getColorPref:(NSString *)prefKey defaultValue:(UIColor *)defaultValue
{
    UIColor *color = defaultValue;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:prefKey];
    if (string)
    {
        color = [UIColor kdgColorWithString:string];
    }

    return color;
}

+ (void)setColorPref:(NSString *)prefKey value:(UIColor *)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [value kdgAsString];
    [userDefaults setObject:colorString forKey:prefKey];
}

+ (NSString *)clockFontName
{
    return [DataModel getStringPref:kPrefClockFontName defaultValue:@"Avenir-Light"];
}

+ (void)setClockFontName:(NSString *)fontName
{
    [DataModel setStringPref:kPrefClockFontName value:fontName];
}

+ (UIColor *)clockTextColor
{
    return [DataModel getColorPref:kPrefClockTextColor defaultValue:[UIColor whiteColor]];
}

+ (void)setClockTextColor:(UIColor *)color
{
    [DataModel setColorPref:kPrefClockTextColor value:color];
}

+ (UIColor *)clockBackgroundColor
{
    return [DataModel getColorPref:kPrefClockBackgroundColor defaultValue:[UIColor blackColor]];
}

+ (void)setClockBackgroundColor:(UIColor *)color
{
    [DataModel setColorPref:kPrefClockBackgroundColor value:color];
}

+ (NSString *)backDoorPrompt
{
    return [DataModel getStringPref:kPrefBackDoorPrompt defaultValue:@"%ld)"];
}

+ (void)setBackDoorPrompt:(NSString *)prompt
{
    [DataModel setStringPref:kPrefBackDoorPrompt value:prompt];
}

+ (UIColor *)backDoorBackgroundColor
{
    return [DataModel getColorPref:kPrefBackDoorBackgroundColor defaultValue:[UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:0.9]];
}

+ (void)setBackDoorBackgroundColor:(UIColor *)color
{
    [DataModel setColorPref:kPrefBackDoorBackgroundColor value:color];
}

@end
