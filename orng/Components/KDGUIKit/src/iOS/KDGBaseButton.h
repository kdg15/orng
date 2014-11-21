//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDGBaseButton : UIControl

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *selectionColor;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat selectionBorderWidth;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGSize shadowOffset;

@property (nonatomic, assign) NSTimeInterval selectionDuration;

/**
 Distance beyond the control border where touch events are still considered to
 be inside the control. Note this does not pertain to the intial touch down event.
 */
@property (nonatomic, assign) CGFloat slopDistance;

- (void)highlight;
- (void)unhighlight;

@end
