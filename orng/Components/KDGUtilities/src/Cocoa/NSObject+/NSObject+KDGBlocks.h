//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KDGBlocks)

- (void)kdgPerformBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
