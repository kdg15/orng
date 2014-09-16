//
//  ClockViewController.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ClockViewController.h"
#import "DataModel.h"

typedef NS_ENUM(NSInteger, SettingsMode)
{
    SettingsModeFont,
    SettingsModeTextColor,
    SettingsModeBackgroundColor
};

static CGFloat kFontSize = 256.0;

@interface ClockViewController ()

@property (nonatomic, assign) SettingsMode settingsMode;
@property (nonatomic, assign) CGFloat fontValue;
@property (nonatomic, assign) CGFloat textColorValue;
@property (nonatomic, assign) CGFloat backgroundColorValue;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *fontNames;

@end

@implementation ClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fontNames = @[@"AvenirNext-UltraLight",
                       @"Gruppo",
                       @"Iceland-Regular",
                       @"NixieOne-Regular",
                       @"Graduate-Regular",
                       @"Audiowide-Regular",
                       @"PoiretOne-Regular",
                       @"Righteous-Regular",
                       @"GillSans-Light",
                       @"Avenir-Light",
                       @"HelveticaNeue-UltraLight"];

    self.settingsMode = SettingsModeFont;
    self.fontValue = 0.0;
    self.textColorValue = 0.0;
    self.backgroundColorValue = 0.0;
    self.slider.value = self.fontValue;

    self.helpLabel.hidden = YES;
    self.backButton.hidden = YES;
    self.settingsButton.hidden = YES;
    self.slider.hidden = YES;

    [self setUpGestures];
    [self setUpFont];
    [self setUpColor];
    [self setUpDateFormatter];
    //[self printFonts];
}

- (void)viewDidUnload
{
    [self stopTimer];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateTimeDisplay];
    [self updateSettingsMode];
    [self startTimer];
    [self disableSleepMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
    [self enableSleepMode];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - set up

- (void)printFonts
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)setUpGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(singleTapAction:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)setUpFont
{
    UIFont *font = [UIFont fontWithName:self.fontNames[0] size:kFontSize];
    self.timeLabel.font = font;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.timeLabel.minimumScaleFactor = 0.1;
}

- (void)setUpColor
{
    UIColor *textColor = [DataModel clockTextColor];
    self.timeLabel.textColor = textColor;
    self.view.backgroundColor = [DataModel clockBackgroundColor];

    self.helpLabel.textColor = textColor;
    [self.backButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setUpDateFormatter
{
    BOOL use24HourDisplay = NO;
    BOOL showSeconds = NO;
    BOOL showAMPM = NO;

    self.dateFormatter = [[NSDateFormatter alloc] init];

    NSMutableString *dateFormat = [[NSMutableString alloc] initWithString:@""];

    if (use24HourDisplay) [dateFormat appendString:@"HH"];
    else                  [dateFormat appendString:@"h"];

    [dateFormat appendString:@":mm"];

    if (showSeconds) [dateFormat appendString:@":ss"];

    if (showAMPM) [dateFormat appendString:@" a"];

    [self.dateFormatter setDateFormat:dateFormat];
}

#pragma mark - sleep mode

- (void)disableSleepMode { [self setSleepMode:NO]; }
- (void)enableSleepMode  { [self setSleepMode:YES]; }

- (void)setSleepMode:(BOOL)enable
{
    UIApplication *app = [UIApplication sharedApplication];
    app.idleTimerDisabled = !enable;
}

#pragma mark - timer

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];

}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFired:(NSTimer *)timer
{
    [self updateTimeDisplay];
}

#pragma mark - ui

- (void)updateTimeDisplay
{
    NSDate *now = [NSDate date];
    NSString *time = [self.dateFormatter stringFromDate:now];
    self.timeLabel.text = time;
}

- (void)updateSettingsMode
{
    switch (self.settingsMode)
    {
        case SettingsModeFont:
            self.helpLabel.text = @"font";
            self.slider.value = self.fontValue;
            break;

        case SettingsModeTextColor:
            self.helpLabel.text = @"text color";
            self.slider.value = self.textColorValue;
           break;

        case SettingsModeBackgroundColor:
            self.helpLabel.text = @"background color";
            self.slider.value = self.backgroundColorValue;
            break;
    }
}

- (void)nextSettingsMode
{
    SettingsMode mode = self.settingsMode;

    switch (self.settingsMode)
    {
        case SettingsModeFont:            mode = SettingsModeTextColor;       break;
        case SettingsModeTextColor:       mode = SettingsModeBackgroundColor; break;
        case SettingsModeBackgroundColor: mode = SettingsModeFont;            break;
    }

    self.settingsMode = mode;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
    CGFloat value = self.slider.value;

    switch (self.settingsMode)
    {
        case SettingsModeFont:            self.fontValue = value;            break;
        case SettingsModeTextColor:       self.textColorValue = value;       break;
        case SettingsModeBackgroundColor: self.backgroundColorValue = value; break;
    }
    [self nextSettingsMode];
    [self updateSettingsMode];
}

- (IBAction)sliderChangedAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;

    switch (self.settingsMode)
    {
        case SettingsModeFont:
        {
            NSInteger fontCount = self.fontNames.count;
            NSInteger fontIndex = (fontCount - 1) * slider.value;
            NSString *fontName = self.fontNames[fontIndex];

            UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
            self.timeLabel.font = font;
            self.helpLabel.text = fontName;

            break;
        }

        case SettingsModeTextColor:
        case SettingsModeBackgroundColor:
        {
            UIColor *color;

            CGFloat whiteThreshold = 0.05;
            CGFloat blackThreshold = 0.05;

            if (slider.value < whiteThreshold)
            {
                color = [UIColor whiteColor];
            }
            else if (slider.value > 1.0 - blackThreshold)
            {
                color = [UIColor blackColor];
            }
            else
            {
                CGFloat hue;
                hue = (slider.value - whiteThreshold) / (1.0 - whiteThreshold - blackThreshold);
                color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
            }

            if (SettingsModeTextColor == self.settingsMode)
            {
                self.timeLabel.textColor = color;
            }
            else
            {
                self.view.backgroundColor = color;
            }

            break;
        }
    }
}

- (IBAction)singleTapAction:(id)sender
{
    if (self.backButton.hidden)
    {
        self.helpLabel.hidden = NO;
        self.backButton.hidden = NO;
        self.settingsButton.hidden = NO;
        self.slider.hidden = NO;
    }
    else
    {
        self.helpLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.settingsButton.hidden = YES;
        self.slider.hidden = YES;
    }
}

- (IBAction)doubleTapAction:(id)sender
{
    static BOOL sDimmed = NO;
    static CGFloat sOriginalBrightness = 0.0;

    UIScreen *screen = [UIScreen mainScreen];
    if (sDimmed)
    {
        screen.brightness = sOriginalBrightness;
    }
    else
    {
        sOriginalBrightness = screen.brightness;
        screen.brightness = 0;
    }

    sDimmed = !sDimmed;
}

@end
