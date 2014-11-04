//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Definition of KDG_UTILITIES_EXTERN */
#if !defined(KDG_UTILITIES_EXTERN)
#  if defined(__cplusplus)
#   define KDG_UTILITIES_EXTERN extern "C"
#  else
#   define KDG_UTILITIES_EXTERN extern
#  endif
#endif /* !defined(KDG_UTILITIES_EXTERN) */

#pragma mark - radians and degrees

/**
 Convert radians to degrees.

 @return Angle in radians.
 */
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)

/**
 Convert degrees to radians.

 @return Angle in degrees.
 */
#define DEGREES_TO_RADIANS(angle) ((angle  ) * M_PI / 180.0)

#pragma mark - random

/**
 Return random integer ranging from 0 to n - 1.

 @return Random integer.
 */
KDG_UTILITIES_EXTERN const int IntRandom(int n);

/**
 Return random float ranging from 0.0 to 1.0.

 @return Random float.
 */
KDG_UTILITIES_EXTERN const float FloatRandom();

/**
 Return random float ranging from min to max.

 @param minimum float value.
 @param maximum float value.

 @return Random float.
 */
KDG_UTILITIES_EXTERN const float FloatRandomInRange(float minimum, float maximum);

#pragma mark - string

/**
 Return @"YES" or @"NO" as appropriate for argument boolean.

 @return String constant.
 */
KDG_UTILITIES_EXTERN const NSString * NSStringFromBOOL(BOOL b);

#pragma mark - utilities

@interface KDGUtilities : NSObject

@end
