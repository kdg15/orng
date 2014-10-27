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
