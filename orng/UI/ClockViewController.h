//
//  ClockViewController.h
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"

@interface ClockViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UISlider *optionSlider;

@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet UIButton *fontButton;
@property (nonatomic, strong) IBOutlet UIButton *foregroundButton;
@property (nonatomic, strong) IBOutlet UIButton *backgroundButton;
@property (nonatomic, strong) IBOutlet UIButton *brightnessButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *okayButton;

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
