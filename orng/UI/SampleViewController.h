//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "KDGBaseButton.h"
#import "KDGCircularSlider.h"

@interface SampleViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIView            *sampleView;
@property (nonatomic, strong) IBOutlet UIView            *settingsView;
@property (nonatomic, strong) IBOutlet UISlider          *slider;
@property (nonatomic, strong) IBOutlet KDGCircularSlider *hueSlider;
@property (nonatomic, strong) IBOutlet KDGCircularSlider *saturationSlider;
@property (nonatomic, strong) IBOutlet KDGCircularSlider *brightnessSlider;
@property (nonatomic, strong) IBOutlet UILabel           *label;
@property (nonatomic, strong) IBOutlet KDGButton         *okayButton;
@property (nonatomic, strong) IBOutlet KDGButton         *cancelButton;

- (IBAction)backAction:(id)sender;
- (IBAction)okayAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)sliderChangedAction:(id)sender;
- (IBAction)colorSliderChangedAction:(id)sender;

@end
