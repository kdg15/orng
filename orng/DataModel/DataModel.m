//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "DataModel.h"
#import "UIColor+KDGUtilities.h"

static NSString * const kPrefClockFontName        = @"orngPrefClockFontName";
static NSString * const kPrefClockTextColor       = @"orngPrefClockTextColor";
static NSString * const kPrefClockBackgroundColor = @"orngPrefClockBackgroundColor";
static NSString * const kPrefBackDoorPrompt       = @"orngPrefBackDoorPrompt";

@implementation DataModel

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
    UIColor *color = [UIColor whiteColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:kPrefClockTextColor];
    if (string)
    {
        color = [UIColor kdgColorWithString:string];
    }

    return color;
}

+ (void)setClockTextColor:(UIColor *)color
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [color kdgColorString];
    [userDefaults setObject:colorString forKey:kPrefClockTextColor];
}

+ (UIColor *)clockBackgroundColor
{
    UIColor *color = [UIColor blackColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults stringForKey:kPrefClockBackgroundColor];
    if (string)
    {
        color = [UIColor kdgColorWithString:string];
    }

    return color;
}

+ (void)setClockBackgroundColor:(UIColor *)color
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorString = [color kdgColorString];
    [userDefaults setObject:colorString forKey:kPrefClockBackgroundColor];
}

+ (NSString *)backDoorPrompt
{
    return [DataModel getStringPref:kPrefBackDoorPrompt defaultValue:@"%ld)"];
}

+ (void)setBackDoorPrompt:(NSString *)prompt
{
    [DataModel setStringPref:kPrefBackDoorPrompt value:prompt];
}

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

@end
