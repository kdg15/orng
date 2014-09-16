//
//  UIColor+Utilities.h
//  orng
//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

+ (UIColor *)colorFromNSString:(NSString *)string;

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

@end
