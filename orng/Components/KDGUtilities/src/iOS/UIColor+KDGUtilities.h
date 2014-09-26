//
//  UIColor+Utilities.h
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KDGUtilities)

//  String must be 4 float values separated by a space representing the red,
//  green, blue, and alpha components.
//  For exampe: "0.5 0.0 0.25 1.0"
//
+ (UIColor *)kdgColorWithString:(NSString *)string;

//  Returned string is 4 float values separated by a space representing the red,
//  green, blue, and alpha components.
//  For exampe: "0.5 0.0 0.25 1.0"
//
- (NSString *)kdgColorString;

- (BOOL)kdgIsEqualToColor:(UIColor *)color;

- (UIColor *)kdgLighterColor;
- (UIColor *)kdgDarkerColor;

@end
