//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIScreen+KDGUtilities.h"
#import "UIDevice+KDGUtilities.h"

@implementation UIScreen (KDGUtilities)

+ (CGSize)kdgScreenSizeWithCurrentOrientation
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGSize screenSize = screenBounds.size;

    NSInteger iOSVersion = [UIDevice kdgMajorVersion];
    if (iOSVersion <= 7)
    {
        //  Prior to iOS 8 a screen's bounds rectangle always reflected
        //  the screen dimensions relative to a portrait-up orientation.
        //  Therefore if in landscape orientation the width and height
        //  dimensions must be swapped.
        //
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            screenSize.width = screenBounds.size.height;
            screenSize.height = screenBounds.size.width;
        }
    }

    return screenSize;
}

+ (CGSize)kdgScreenSizeWithPortraitOrientation
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGSize screenSize = screenBounds.size;

    NSInteger iOSVersion = [UIDevice kdgMajorVersion];
    if (iOSVersion >= 8)
    {
        //  In iOS 8 a screen's bounds rectangle reflects the current
        //  interface orientation.
        //  Therefore if in landscape orientation the width and height
        //  dimensions must be swapped.
        //
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            screenSize.width = screenBounds.size.height;
            screenSize.height = screenBounds.size.width;
        }
    }

    return screenSize;
}

+ (UIImage *)kdgCaptureScreen
{
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView *sourceView = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [sourceView drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
