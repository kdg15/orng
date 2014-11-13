//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KDGLayerDrawBlock)(CALayer *layer, CGContextRef context);

@interface KDGCircularSlider : UIControl

@property (nonatomic, assign) CGFloat minimum;
@property (nonatomic, assign) CGFloat maximum;
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *trackHighlightColor;
@property (nonatomic, strong) UIColor *knobColor;
@property (nonatomic, strong) UIColor *knobHighlightColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat knobSize;
@property (nonatomic, assign) CGFloat trackSize;

/**
 Set the format for displaying the value in the label.
 The format must include a single %f token. Feel free to add whatever else you like,
 for example the number of decimal places or units.
 
 The default format is "%.0f".
 */
@property (nonatomic, copy) NSString *formatString;

/**
 Orientation of the control. Indicate where the minimum value is positioned on the slider.
   0.0 for 3 o'clock,
  90.0 for 12 o'clock,
 180.0 for 9 o'clock, and
 270.0 for 6 o'clock (default).
 */
@property (nonatomic, assign) CGFloat orientation;

/**
 Distance beyond the control border where touch events are still considered to
 be inside the control. Note this does not pertain to the intial touch down event.
 */
@property (nonatomic, assign) CGFloat slopDistance;

- (void)setFont:(UIFont *)font;

- (void)setTrackDrawBlock:(KDGLayerDrawBlock)drawBlock;

#pragma mark - tests;

+ (void)runTests;

@end

