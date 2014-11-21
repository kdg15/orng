//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "NSObject+KDGBlocks.h"

@implementation NSObject (KDGBlocks)

- (void)kdgPerformBlock:(void (^)())block
{
    block();
}

- (void)kdgPerformBlock:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    void (^block_)() = [block copy];
    [self performSelector:@selector(kdgPerformBlock:) withObject:block_ afterDelay:delay];
}

@end
