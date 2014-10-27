/********************************************************************
 * (C) Copyright 2013 by Autodesk, Inc. All Rights Reserved. By using
 * this code,  you  are  agreeing  to the terms and conditions of the
 * License  Agreement  included  in  the documentation for this code.
 * AUTODESK  MAKES  NO  WARRANTIES,  EXPRESS  OR  IMPLIED,  AS TO THE
 * CORRECTNESS OF THIS CODE OR ANY DERIVATIVE WORKS WHICH INCORPORATE
 * IT.  AUTODESK PROVIDES THE CODE ON AN 'AS-IS' BASIS AND EXPLICITLY
 * DISCLAIMS  ANY  LIABILITY,  INCLUDING CONSEQUENTIAL AND INCIDENTAL
 * DAMAGES  FOR ERRORS, OMISSIONS, AND  OTHER  PROBLEMS IN THE  CODE.
 *
 * Use, duplication,  or disclosure by the U.S. Government is subject
 * to  restrictions  set forth  in FAR 52.227-19 (Commercial Computer
 * Software Restricted Rights) as well as DFAR 252.227-7013(c)(1)(ii)
 * (Rights  in Technical Data and Computer Software),  as applicable.
 *******************************************************************/

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
