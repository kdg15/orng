//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "DummyViewController.h"
#import "CommandSystem.h"
#import "UIColor+KDGUtilities.h"

static const CGSize kButtonSize = { 40.0, 40.0 };

typedef NS_ENUM(NSInteger, ActiveSetting)
{
    ActiveSettingBorderWidth,
    ActiveSettingCornerRadius,
    ActiveSettingShadowOpacity,
    ActiveSettingBackgroundColor
};

@interface DummyViewController ()

@property (nonatomic, strong) NSArray *samples;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, assign) ActiveSetting activeSetting;

@end

@implementation DummyViewController

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
        backgroundColorButton.swatchColor = button0.backgroundColor;
        position.x += buttonSize.width + space.width;
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGColorSwatchButton *highlightColorButton = [[KDGColorSwatchButton alloc] initWithFrame:buttonFrame];
        highlightColorButton.swatchColor = button0.highlightColor;
        position.x += buttonSize.width + space.width;
        
        buttonFrame = CGRectMake(position.x, position.y, buttonSize.width, buttonSize.height);
        KDGColorSwatchButton *borderColorButton = [[KDGColorSwatchButton alloc] initWithFrame:buttonFrame];
        borderColorButton.swatchColor = button0.borderColor;
        position.x += buttonSize.width + space.width;
        
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

//        [self.settingsView addSubview:borderWidthButton];
//        [self.settingsView addSubview:cornerRadiusButton];
//        [self.settingsView addSubview:shadowOpacityButton];
//        [self.settingsView addSubview:backgroundColorButton];
//        [self.settingsView addSubview:backgroundColorButton];
//        [self.settingsView addSubview:backgroundColorButton];
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
    self.slider.hidden = NO;
    self.okayButton.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (void)dismissSlider
{
    self.slider.hidden = YES;
    self.okayButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (void)output:(NSString *)string
{
    self.label.text = string;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissDummyView]];
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
    self.activeSetting = ActiveSettingBackgroundColor;
    
    KDGButton *button = self.samples[0];
    
    self.label.text = @"background color";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.0;
    self.slider.value = 0.0;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)highlightColorAction:(id)sender
{
    self.activeSetting = ActiveSettingBackgroundColor;
    
    KDGButton *button = self.samples[0];
    
    self.label.text = @"highlight color";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.0;
    self.slider.value = 0.0;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)borderColorAction:(id)sender
{
    self.activeSetting = ActiveSettingBackgroundColor;
    
    KDGButton *button = self.samples[0];
    
    self.label.text = @"border color";
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.0;
    self.slider.value = 0.0;
    
    [self dismissSettings];
    [self presentSlider];
}

- (void)sliderChangedAction:(id)sender
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
        {
            /*
            for (KDGButton *button in self.samples)
            {
                button.shadowOpacity = slider.value;
            }
             */
            break;
        }
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
    
    if ([command isEqualToCommand:[Command dismissDummyView]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
