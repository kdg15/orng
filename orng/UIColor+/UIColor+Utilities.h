//
//  UIColor+Utilities.h
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

+ (UIColor *)colorWithString:(NSString *)string;

- (NSString *)colorString;

- (BOOL)isEqualToColor:(UIColor *)color;

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

@end
