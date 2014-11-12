//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "KDGBaseButton.h"

@interface DummyViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIView        *sampleView;
@property (nonatomic, strong) IBOutlet UIView        *settingsView;
@property (nonatomic, strong) IBOutlet UISlider      *slider;
@property (nonatomic, strong) IBOutlet UILabel       *label;
@property (nonatomic, strong) IBOutlet KDGTextButton *okayButton;
@property (nonatomic, strong) IBOutlet KDGTextButton *cancelButton;

- (IBAction)backAction:(id)sender;
- (IBAction)okayAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)sliderChangedAction:(id)sender;

@end
