//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (KDGUtilities)

/**
 Return the major version of the operating system.

 Versions are typically in the form 1.2.3 (major.minor.patch).
 UIDevice has systemVersion property for returning the entire version
 as a string.

 Your application code may use these methods as follows:

 @code
 NSInteger iOSVersion = [UIDevice kdgMajorVersion];
 if (iOSVersion <= 7)
 {
    //  Prior to iOS 8
 }
 else
 {
    //  iOS 8 or greater
 }
 @endcode

 @return Version number.
 */
+ (NSInteger)kdgMajorVersion;

/**
 Return the minor version of the operating system.

 Versions are typically in the form 1.2.3 (major.minor.patch).
 UIDevice has systemVersion property for returning the entire version
 as a string.

 @return Version number.
 */

+ (NSInteger)kdgMinorVersion;
/**
 Return the patch version of the operating system.

 Versions are typically in the form 1.2.3 (major.minor.patch).
 UIDevice has systemVersion property for returning the entire version
 as a string.

 @return Version number.
 */
+ (NSInteger)kdgPatchVersion;

@end
