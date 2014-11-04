//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (KDGUtilities)

/**
 Return the screen size taking into consideration the current interface orientation.

 Note that interface orientation and device orientation are not always the same.
 For example an iPhone app may only display in portrait orientation regardless of
 the device's orientation.

 @return Screen size.
 */
+ (CGSize)kdgScreenSizeWithCurrentOrientation;

/**
 Return the screen size assuming device is in portrait orientation.

 @return Screen size.
 */
+ (CGSize)kdgScreenSizeWithPortraitOrientation;

/**
 Return a UIImage of the screen.
 
 @return Image.
 */
+ (UIImage *)kdgCaptureScreen;

@end
