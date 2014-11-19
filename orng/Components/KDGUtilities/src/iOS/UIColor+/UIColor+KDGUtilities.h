//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KDGUtilities)

/**
 Return color initialized with RGB components where all values range from 0 to 255.
 */
+ (UIColor *)kdgColorWithRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue
                       alpha:(NSInteger)alpha;

/**
 Return color initialized with HSB components where hue ranges from 0 to 359,
 saturation and brightness range from 0 to 100, and alpha ranges from 0 to 255.
 */
+ (UIColor *)kdgColorWithHue:(NSInteger)hue
                  saturation:(NSInteger)saturation
                  brightness:(NSInteger)brightness
                       alpha:(NSInteger)alpha;

/**
 String must be 4 integer values separated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
+ (UIColor *)kdgColorWithString:(NSString *)string; // todo: remove
+ (UIColor *)kdgColorWithRGBString:(NSString *)string;

/**
 String must be 4 integer values separated by a single space.
 The values represent the hue, saturation, brightness, and alpha color components.
 Hue value ranges from 0 to 359. Saturation and brightness range from 0 to 100, and alpha 
 ranges from 0 to 255.
 */
+ (UIColor *)kdgColorWithHSBString:(NSString *)string;

/**
 Return color as string of 4 integer values seperated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
- (NSString *)kdgAsString;
- (NSString *)kdgAsRGBString;
- (NSString *)kdgAsHSBString;

/**
 Return red, green, and blue color components.
 Works on all colors regardless of color space.
 */
- (void)kdgGetRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

/**
 Return hue, saturation, and brightness color components.
 Works on all colors regardless of color space.
 */
- (void)kdgGetHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;

/**
 Test equality of colors.
 */
- (BOOL)kdgIsEqualToColor:(UIColor *)color;

/**
 Return a lighter color.
 */
- (UIColor *)kdgLighterColor;

/**
 Return a darker color.
 */
- (UIColor *)kdgDarkerColor;

/**
 Return current color with hue.
 */
- (UIColor *)kdgColorWithHue:(CGFloat)hue;

/**
 Return current color with saturation.
 */
- (UIColor *)kdgColorWithSaturation:(CGFloat)saturation;

/**
 Return current color with brightness.
 */
- (UIColor *)kdgColorWithBrightness:(CGFloat)brightness;

#pragma mark - tests;

+ (void)runTests;

@end
