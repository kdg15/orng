//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDGCircularSlider : UIControl

@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) CGFloat minimum;
@property (nonatomic, assign) CGFloat maximum;
@property (nonatomic, assign) CGFloat value;

/**
 Distance beyond the control border where touch events are still considered to
 be inside the control. Note this does not pertain to the intial touch down event.
 */
@property (nonatomic, assign) CGFloat slopDistance;

#pragma mark - tests;

+ (void)runTests;

@end

