//
//  Created by Brian Kramer on 15.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataModel : NSObject

+ (NSString *)clockFontName;
+ (void)setClockFontName:(NSString *)fontName;

+ (UIColor *)clockTextColor;
+ (void)setClockTextColor:(UIColor *)color;

+ (UIColor *)clockBackgroundColor;
+ (void)setClockBackgroundColor:(UIColor *)color;

+ (NSString *)backDoorPrompt;
+ (void)setBackDoorPrompt:(NSString *)prompt;

+ (UIColor *)backDoorBackgroundColor;
+ (void)setBackDoorBackgroundColor:(UIColor *)color;

@end
