//
//  Created by Brian Kramer on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIColor+AppColors.h"
#import "UIColor+KDGUtilities.h"

@implementation UIColor (AppColors)

//               base         highlight   border
//  blue         70 138 207,  51 112 173,  57 125 194
//  light blue   99 191 225,  63 175 225,  80 183 221
//  orange      238 174  56, 233 152   0, 235 163   4
//  green       102 184  77,  78 157  51,  87 174  58
//  red         212  84  76, 193  49  38, 199  63  52

+ (UIColor *)appRedColor       { return [UIColor kdgColorWithRed:212 green: 84 blue: 76 alpha:255]; }
+ (UIColor *)appGreenColor     { return [UIColor kdgColorWithRed:102 green:184 blue: 77 alpha:255]; }
+ (UIColor *)appBlueColor      { return [UIColor kdgColorWithRed: 70 green:138 blue:207 alpha:255]; }
+ (UIColor *)appLightBlueColor { return [UIColor kdgColorWithRed: 99 green:191 blue:225 alpha:255]; }
+ (UIColor *)appOrangeColor    { return [UIColor kdgColorWithRed:238 green:174 blue: 56 alpha:255]; }

@end
