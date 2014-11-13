//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCALayer.h"
#import "KDGCircularSlider.h"

@interface KDGCircularSliderTrackLayer : KDGCALayer

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, weak) KDGCircularSlider *slider;

@property (nonatomic, copy) KDGLayerDrawBlock drawBlock;

@end
