//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "KDGButton.h"
#import "KDGColorSwatchButton.h"

@interface ClockViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UISlider *optionSlider;

@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet KDGButton *fontButton;
@property (nonatomic, strong) IBOutlet KDGColorSwatchButton *foregroundButton;
@property (nonatomic, strong) IBOutlet KDGColorSwatchButton *backgroundButton;
@property (nonatomic, strong) IBOutlet KDGButton *brightnessButton;
@property (nonatomic, strong) IBOutlet KDGButton *okayButton;
@property (nonatomic, strong) IBOutlet KDGButton *cancelButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeViewBottomConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintFontButtonX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintFontButtonY;

- (IBAction)backAction:(id)sender;

- (IBAction)optionsAction:(id)sender;

- (IBAction)fontAction:(id)sender;
- (IBAction)foregroundAction:(id)sender;
- (IBAction)backgroundAction:(id)sender;
- (IBAction)brightnessAction:(id)sender;

- (IBAction)cancelAction:(id)sender;
- (IBAction)okayAction:(id)sender;

- (IBAction)optionSliderChangedAction:(id)sender;

@end
