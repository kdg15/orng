//
//  Created by Brian Kramer on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "NSString+AppStrings.h"

@implementation NSString (AppStrings)

+ (NSString *)okayString   { return NSLocalizedString(@"ok", @"okay"); }
+ (NSString *)cancelString { return NSLocalizedString(@"✕", @"cancel"); }

+ (NSString *)backString { return NSLocalizedString(@"❮", @"back"); }
+ (NSString *)moreString { return NSLocalizedString(@"⋯", @"more"); }

+ (NSString *)fontString        { return NSLocalizedString(@"ƒ", @"font"); }
+ (NSString *)brightnessString  { return NSLocalizedString(@"☀︎", @"brightness"); }

@end
