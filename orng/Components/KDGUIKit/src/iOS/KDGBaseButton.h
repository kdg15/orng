//
//  Created by Brian Kramer on 07.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface KDGColorSwatch : UIView
//
//@property (nonatomic, strong) UIColor *swatchColor;
//
//@end

@interface KDGBaseButton : UIControl

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 Distance beyond the control border where touch events are still considered to
 be inside the control. Note this does not pertain to the intial touch down event.
 */
@property (nonatomic, assign) CGFloat slopDistance;

- (void)highlight;
- (void)unhighlight;

@end

//@interface KDGButton : KDGBaseButton
//
//@property (nonatomic, strong) NSString *text;
//@property (nonatomic, strong) UIColor *textColor;
//@property (nonatomic, strong) UIColor *textHighlightColor;
//
//@end
//
//@interface KDGColorSwatchButton : KDGBaseButton
//
//@property (nonatomic, strong) UIColor *swatchColor;
//
//@end
//
//@interface KDGTestView : UIView
//
//@end
