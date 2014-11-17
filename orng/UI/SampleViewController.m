//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "SampleViewController.h"
#import "CommandSystem.h"
#import "KDGColorSwatchButton.h"
#import "UIColor+KDGUtilities.h"

static const CGSize kButtonSize = { 40.0, 40.0 };

typedef NS_ENUM(NSInteger, ActiveSetting)
{
    ActiveSettingBorderWidth,
    ActiveSettingCornerRadius,
    ActiveSettingShadowOpacity,
    ActiveSettingBackgroundColor,
    ActiveSettingHighlightColor,
    ActiveSettingBorderColor
};

typedef NS_ENUM(NSInteger, ColorSliderComponent)
{
    ColorSliderComponentHue,
    ColorSliderComponentSaturation,
    ColorSliderComponentBrightness
};

@interface SampleViewController ()

@property (nonatomic, strong) NSArray *samples;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, assign) ActiveSetting activeSetting;

@property (nonatomic, strong) KDGColorSwatchButton *backgroundColorButton;
@property (nonatomic, strong) KDGColorSwatchButton *highlightColorButton;
@property (nonatomic, strong) KDGColorSwatchButton *borderColorButton;

@end

@implementation SampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CommandEngine sharedInstance] addResponder:self];

    [self setUp];
}

- (void)dealloc
{
    [[CommandEngine sharedInstance] removeResponder:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUp
{
    self.label.text = @"";

    self.slider.hidden = YES;
    self.hueSlider.hidden = YES;
    self.saturationSlider.hidden = YES;
    self.brightnessSlider.hidden = YES;

    self.hueSlider.minimum = 0;
    self.hueSlider.maximum = 360;
    self.hueSlider.value   = 0;
    self.hueSlider.formatString = @"%.0f°";
    [self.hueSlider setFont:[UIFont systemFontOfSize:8]];
    self.hueSlider.tag = ColorSliderComponentHue;

    self.saturationSlider.minimum = 0;
    self.saturationSlider.maximum = 100;
    self.saturationSlider.value   = 0;
    self.saturationSlider.formatString = @"%.0f%%";
    [self.saturationSlider setFont:[UIFont systemFontOfSize:8]];
    self.saturationSlider.tag = ColorSliderComponentSaturation;
    
    self.brightnessSlider.minimum = 0;
    self.brightnessSlider.maximum = 100;
    self.brightnessSlider.value   = 0;
    self.brightnessSlider.formatString = @"%.0f%%";
    [self.brightnessSlider setFont:[UIFont systemFontOfSize:8]];
    self.brightnessSlider.tag = ColorSliderComponentBrightness;

    self.okayButton.hidden = YES;
    self.cancelButton.hidden = YES;
    
    self.okayButton.text = @"✔︎";
    self.cancelButton.text = @"✘";
    
    self.okayButton.backgroundColor = [UIColor kdgColorWithRed:102 green:184 blue: 77 alpha:255];
    self.okayButton.highlightColor  = [self.okayButton.backgroundColor kdgDarkerColor];

    self.cancelButton.backgroundColor = [UIColor kdgColorWithRed:212 green: 84 blue: 76 alpha:255];
    self.cancelButton.highlightColor  = [self.cancelButton.backgroundColor kdgDarkerColor];

    CGSize buttonSize = kButtonSize;
    CGSize space = CGSizeMake(8, 8);
    CGPoint position = CGPointMake(0, 0);
    CGRect buttonFrame;
    
    buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
    KDGButton *button0 = [[KDGButton alloc] initWithFrame:buttonFrame];
    position.y += buttonSize.height + space.height;
    
    buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
    KDGButton *button1 = [[KDGButton alloc] initWithFrame:buttonFrame];
    position.y += buttonSize.height + space.height;

    buttonFrame = CGRectMake(position.x, position.y, 2 * buttonSize.width, buttonSize.height);
    KDGButton *button2 = [[KDGButton alloc] initWithFrame:buttonFrame];
    position.y += buttonSize.height + space.height;

    buttonFrame = CGRectMake(position.x, position.y, 2 * buttonSize.width, buttonSize.height);
    KDGButton *button3 = [[KDGButton alloc] initWithFrame:buttonFrame];
    position.y += buttonSize.height + space.height;
    
    [button0 addTarget:self action:@selector(buttonTouchDownAction:)        forControlEvents:UIControlEventTouchDown];
    [button0 addTarget:self action:@selector(buttonTouchUpInsideAction:)    forControlEvents:UIControlEventTouchUpInside];
    [button0 addTarget:self action:@selector(buttonTouchUpOutsideAction:)   forControlEvents:UIControlEventTouchUpOutside];
    [button0 addTarget:self action:@selector(buttonTouchCancelAction:)      forControlEvents:UIControlEventTouchCancel];
    [button0 addTarget:self action:@selector(buttonTouchDragInsideAction:)  forControlEvents:UIControlEventTouchDragInside];
    [button0 addTarget:self action:@selector(buttonTouchDragOutsideAction:) forControlEvents:UIControlEventTouchDragOutside];
    [button0 addTarget:self action:@selector(buttonTouchDragEnterAction:)   forControlEvents:UIControlEventTouchDragEnter];
    [button0 addTarget:self action:@selector(buttonTouchDragExitAction:)    forControlEvents:UIControlEventTouchDragExit];

    button1.backgroundColor    = [UIColor kdgColorWithRed: 70 green:138 blue:207 alpha:255];
    button1.highlightColor     = [button1.backgroundColor kdgDarkerColor];
    
    button2.backgroundColor    = [UIColor kdgColorWithRed:99 green:191 blue:225 alpha:255];
    button2.highlightColor     = [button2.backgroundColor kdgDarkerColor];
    
    button3.backgroundColor    = [UIColor kdgColorWithRed:238 green:174 blue: 56 alpha:255];
    button3.highlightColor     = [button3.backgroundColor kdgDarkerColor];

    [self.sampleView addSubview:button0];
    [self.sampleView addSubview:button1];
    [self.sampleView addSubview:button2];
    [self.sampleView addSubview:button3];
    
    self.samples = @[button0, button1, button2, button3];

    {
        position = CGPointMake(0, self.settingsView.bounds.size.height - buttonSize.height);
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGButton *borderWidthButton = [[KDGButton alloc] initWithFrame:buttonFrame];
        borderWidthButton.text = @"bw";
        position.x += buttonSize.width + space.width;

        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGButton *cornerRadiusButton = [[KDGButton alloc] initWithFrame:buttonFrame];
        cornerRadiusButton.text = @"cr";
        position.x += buttonSize.width + space.width;

        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGButton *shadowOpacityButton = [[KDGButton alloc] initWithFrame:buttonFrame];
        shadowOpacityButton.text = @"so";
        position.x += buttonSize.width + space.width;
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGColorSwatchButton *backgroundColorButton = [[KDGColorSwatchButton alloc] initWithFrame:buttonFrame];
        position.x += buttonSize.width + space.width;
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGColorSwatchButton *highlightColorButton = [[KDGColorSwatchButton alloc] initWithFrame:buttonFrame];
        position.x += buttonSize.width + space.width;
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGColorSwatchButton *borderColorButton = [[KDGColorSwatchButton alloc] initWithFrame:buttonFrame];
        position.x += buttonSize.width + space.width;
        
        _backgroundColorButton = backgroundColorButton;
        _highlightColorButton = highlightColorButton;
        _borderColorButton = borderColorButton;
        
        [self updateColorButtons:button0];

        [borderWidthButton addTarget:self action:@selector(borderWidthAction:) forControlEvents:UIControlEventTouchUpInside];
        [cornerRadiusButton addTarget:self action:@selector(cornerRadiusAction:) forControlEvents:UIControlEventTouchUpInside];
        [shadowOpacityButton addTarget:self action:@selector(shadowOpacityAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundColorButton addTarget:self action:@selector(backgroundColorAction:) forControlEvents:UIControlEventTouchUpInside];
        [highlightColorButton addTarget:self action:@selector(highlightColorAction:) forControlEvents:UIControlEventTouchUpInside];
        [borderColorButton addTarget:self action:@selector(borderColorAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.settings = @[borderWidthButton,
                          cornerRadiusButton,
                          shadowOpacityButton,
                          backgroundColorButton,
                          highlightColorButton,
                          borderColorButton];
        
        for (UIView *view in self.settings)
        {
            [self.settingsView addSubview:view];
        }
    }
}

#pragma mark - ui

- (void)presentSettings
{
    for (UIView *setting in self.settings)
    {
        setting.hidden = NO;
    }
}

- (void)dismissSettings
{
    for (UIView *setting in self.settings)
    {
        setting.hidden = YES;
    }
}

- (void)presentSlider
{
    self.okayButton.hidden = NO;
    self.cancelButton.hidden = NO;

    switch (self.activeSetting)
    {
        case ActiveSettingBorderWidth:
        case ActiveSettingCornerRadius:
        case ActiveSettingShadowOpacity:
        {
            self.slider.hidden = NO;
            break;
        }
        case ActiveSettingBackgroundColor:
        case ActiveSettingHighlightColor:
        case ActiveSettingBorderColor:
        {
            self.hueSlider.hidden = NO;
            self.saturationSlider.hidden = NO;
            self.brightnessSlider.hidden = NO;
            break;
        }
    }
}

- (void)dismissSlider
{
    self.okayButton.hidden = YES;
    self.cancelButton.hidden = YES;

    switch (self.activeSetting)
    {
        case ActiveSettingBorderWidth:
        case ActiveSettingCornerRadius:
        case ActiveSettingShadowOpacity:
        {
            self.slider.hidden = YES;
            break;
        }
        case ActiveSettingBackgroundColor:
        case ActiveSettingHighlightColor:
        case ActiveSettingBorderColor:
        {
            self.hueSlider.hidden = YES;
            self.saturationSlider.hidden = YES;
            self.brightnessSlider.hidden = YES;
            
            [self updateColorButtons:self.samples[0]];
            break;
        }
    }
}

- (void)presentColorSlider:(UIColor *)color
{
    CGFloat hue, saturation, brightness, alpha;
    [color kdgGetHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    self.hueSlider.value        = hue        * 360.0;
    self.saturationSlider.value = saturation * 100.0;
    self.brightnessSlider.value = brightness * 100.0;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)updateColorButtons:(KDGButton *)button
{
    self.backgroundColorButton.swatchColor = button.backgroundColor;
    self.highlightColorButton.swatchColor = button.highlightColor;
    self.borderColorButton.swatchColor = button.borderColor;
}

- (void)output:(NSString *)string
{
    self.label.text = string;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissSampleView]];
}

- (IBAction)okayAction:(id)sender
{
    [self dismissSlider];
    [self presentSettings];
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissSlider];
    [self presentSettings];
}

- (void)borderWidthAction:(id)sender
{
    self.activeSetting = ActiveSettingBorderWidth;
    
    KDGButton *button = self.samples[0];

    self.label.text = @"border width";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 0.5 * kButtonSize.height;
    self.slider.value = button.borderWidth;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)cornerRadiusAction:(id)sender
{
    self.activeSetting = ActiveSettingCornerRadius;

    KDGButton *button = self.samples[0];

    self.label.text = @"corner radius";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 0.5 * kButtonSize.height;
    self.slider.value = button.cornerRadius;

    [self dismissSettings];
    [self presentSlider];
}

- (void)shadowOpacityAction:(id)sender
{
    self.activeSetting = ActiveSettingShadowOpacity;
    
    KDGButton *button = self.samples[0];
    
    self.label.text = @"shadow opacity";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.0;
    self.slider.value = button.shadowOpacity;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)backgroundColorAction:(id)sender
{
    self.label.text = @"background color";
    KDGButton *button = self.samples[0];

    self.activeSetting = ActiveSettingBackgroundColor;
    UIColor *color = button.backgroundColor;
    
    [self presentColorSlider:color];
}

- (void)highlightColorAction:(id)sender
{
    self.label.text = @"highlight color";
    KDGButton *button = self.samples[0];

    self.activeSetting = ActiveSettingHighlightColor;
    UIColor *color = button.highlightColor;
    
    [self presentColorSlider:color];
}

- (void)borderColorAction:(id)sender
{
    self.label.text = @"border color";
    KDGButton *button = self.samples[0];

    self.activeSetting = ActiveSettingBorderColor;
    UIColor *color = button.borderColor;

    [self presentColorSlider:color];
}

- (IBAction)sliderChangedAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    switch (self.activeSetting)
    {
        case ActiveSettingBorderWidth:
        {
            for (KDGButton *button in self.samples)
            {
                button.borderWidth = slider.value;
            }
            break;
        }
        case ActiveSettingCornerRadius:
        {
            for (KDGButton *button in self.samples)
            {
                button.cornerRadius = slider.value;
            }
            break;
        }
        case ActiveSettingShadowOpacity:
        {
            for (KDGButton *button in self.samples)
            {
                button.shadowOpacity = slider.value;
            }
            break;
        }
        case ActiveSettingBackgroundColor:
        case ActiveSettingHighlightColor:
        case ActiveSettingBorderColor:
            break;
    }
}

- (IBAction)colorSliderChangedAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    KDGButton *button = self.samples[0];
    
    CGFloat value = slider.value;

    if      (ColorSliderComponentHue        == slider.tag) value /= 360.0;
    else if (ColorSliderComponentSaturation == slider.tag) value /= 100.0;
    else if (ColorSliderComponentBrightness == slider.tag) value /= 100.0;

    UIColor *color;

    switch (self.activeSetting)
    {
        case ActiveSettingBackgroundColor:
        {
            color = button.backgroundColor;
            
            if      (ColorSliderComponentHue        == slider.tag) color = [color kdgColorWithHue:value];
            else if (ColorSliderComponentSaturation == slider.tag) color = [color kdgColorWithSaturation:value];
            else if (ColorSliderComponentBrightness == slider.tag) color = [color kdgColorWithBrightness:value];

            for (KDGButton *button in self.samples)
            {
                button.backgroundColor = color;
            }
            break;
        }
        case ActiveSettingHighlightColor:
        {
            color = button.highlightColor;

            if      (ColorSliderComponentHue        == slider.tag) color = [color kdgColorWithHue:value];
            else if (ColorSliderComponentSaturation == slider.tag) color = [color kdgColorWithSaturation:value];
            else if (ColorSliderComponentBrightness == slider.tag) color = [color kdgColorWithBrightness:value];

            for (KDGButton *button in self.samples)
            {
                button.highlightColor = color;
            }
            break;
        }
        case ActiveSettingBorderColor:
        {
            color = button.borderColor;

            if      (ColorSliderComponentHue        == slider.tag) color = [color kdgColorWithHue:value];
            else if (ColorSliderComponentSaturation == slider.tag) color = [color kdgColorWithSaturation:value];
            else if (ColorSliderComponentBrightness == slider.tag) color = [color kdgColorWithBrightness:value];
            
            for (KDGButton *button in self.samples)
            {
                button.borderColor = color;
            }
            break;
        }

        case ActiveSettingBorderWidth:
        case ActiveSettingCornerRadius:
        case ActiveSettingShadowOpacity:
            break;
    }
}

- (void)buttonTouchDownAction:(UIButton *)button        { [self output:@"buttonTouchDownAction"]; }
- (void)buttonTouchUpInsideAction:(UIButton *)button    { [self output:@"buttonTouchUpInsideAction"]; }
- (void)buttonTouchUpOutsideAction:(UIButton *)button   { [self output:@"buttonTouchUpOutsideAction"]; }
- (void)buttonTouchCancelAction:(UIButton *)button      { [self output:@"buttonTouchCancelAction"]; }
- (void)buttonTouchDragInsideAction:(UIButton *)button  { [self output:@"buttonTouchDragInsideAction"]; }
- (void)buttonTouchDragOutsideAction:(UIButton *)button { [self output:@"buttonTouchDragOutsideAction"]; }
- (void)buttonTouchDragEnterAction:(UIButton *)button   { [self output:@"buttonTouchDragEnterAction"]; }
- (void)buttonTouchDragExitAction:(UIButton *)button    { [self output:@"buttonTouchDragExitAction"]; }

#pragma mark - command system

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];
    
    if ([command isEqualToCommand:[Command dismissSampleView]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
