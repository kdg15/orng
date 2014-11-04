//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "UIDevice+KDGUtilities.h"

NSArray * KDGSystemVersionComponents(void);
NSArray * KDGSystemVersionComponents(void)
{
    return [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
}

@implementation UIDevice (KDGUtilities)

+ (NSInteger)kdgMajorVersion
{
    NSInteger version = 0;
    NSArray *versionComponents = KDGSystemVersionComponents();
    if (versionComponents && versionComponents.count > 0)
    {
        version = [[versionComponents objectAtIndex:0] integerValue];
    }
    return version;
}

+ (NSInteger)kdgMinorVersion
{
    NSInteger version = 0;
    NSArray *versionComponents = KDGSystemVersionComponents();
    if (versionComponents && versionComponents.count > 1)
    {
        version = [[versionComponents objectAtIndex:1] integerValue];
    }
    return version;
}

+ (NSInteger)kdgPatchVersion
{
    NSInteger version = 0;
    NSArray *versionComponents = KDGSystemVersionComponents();
    if (versionComponents && versionComponents.count > 2)
    {
        version = [[versionComponents objectAtIndex:2] integerValue];
    }
    return version;
}

@end
