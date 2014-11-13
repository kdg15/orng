//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCALayer.h"
#import <UIKit/UIKit.h>

@implementation KDGCALayer

#pragma mark - initialization

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self kdgCALayerInitialize];
    }
    
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    
    if (self)
    {
        [self kdgCALayerInitialize];
    }
    
    return self;
}

- (void)kdgCALayerInitialize
{
    self.contentsScale = [UIScreen mainScreen].scale;
}

@end
