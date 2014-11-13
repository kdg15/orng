//
//  Created by brian on 12.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class KDGCircularSlider;

@interface KDGCircularSliderKnobLayer : CALayer

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, weak) KDGCircularSlider *slider;

@end
