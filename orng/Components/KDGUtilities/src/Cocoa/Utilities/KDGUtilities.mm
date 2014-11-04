//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGUtilities.h"

#pragma mark - random

#define ARC4RANDOM_MAX 0x100000000

KDG_UTILITIES_EXTERN const int IntRandom(int n)
{
    if (n == 0) return 0;
    int value = arc4random() % n;
    assert(value < n);
    return value;
}

KDG_UTILITIES_EXTERN const float FloatRandom()
{
    return FloatRandomInRange(0.0, 1.0);
}

KDG_UTILITIES_EXTERN const float FloatRandomInRange(float min, float max)
{
    assert(max >= min);
    
    float r = (float)arc4random() / ARC4RANDOM_MAX;
    assert(r >= 0.0);
    assert(r <= 1.0);
    
    float value = min + r * (max - min);
    return value;
}

#pragma mark - string

KDG_UTILITIES_EXTERN const NSString * NSStringFromBOOL(BOOL b)
{
    return b ? @"YES" : @"NO";
}

#pragma mark - utilities

@implementation KDGUtilities

@end
