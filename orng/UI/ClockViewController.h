//
//  ClockViewController.h
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *helpLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *dimButton;
@property (nonatomic, strong) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) IBOutlet UISlider *slider;

- (IBAction)backAction:(id)sender;
- (IBAction)dimAction:(id)sender;
- (IBAction)sliderChangedAction:(id)sender;

@end
