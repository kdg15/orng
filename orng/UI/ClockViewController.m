//
//  ClockViewController.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ClockViewController.h"
#import "DataModel.h"
#import "UIColor+KDGUtilities.h"

static const CGFloat kWhiteSliderThreshold = 0.05;
static const CGFloat kBlackSliderThreshold = 0.05;

typedef NS_ENUM(NSInteger, SettingsMode)
{
    SettingsModeFont,
    SettingsModeTextColor,
    SettingsModeBackgroundColor
};

static CGFloat kFontSize = 256.0;

static NSTimeInterval kTimerInterval   = 0.2;
static NSTimeInterval kUITimerInterval = 2.0;

@interface ClockViewController ()

@property (nonatomic, assign) SettingsMode settingsMode;
@property (nonatomic, assign) CGFloat fontValue;
@property (nonatomic, assign) CGFloat textColorValue;
@property (nonatomic, assign) CGFloat backgroundColorValue;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *uiTimer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *fontNames;

@end

@implementation ClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fontNames = @[@"Avenir-Light",
                       @"AvenirNext-UltraLight",
                       @"GillSans-Light",
                       @"HelveticaNeue-UltraLight",
                       @"Gruppo",
                       @"Iceland-Regular",
                       @"NixieOne-Regular",
                       @"Graduate-Regular",
                       @"Audiowide-Regular",
                       @"PoiretOne-Regular",
                       @"Righteous-Regular"];

    self.settingsMode = SettingsModeFont;

    self.helpLabel.hidden = YES;
    self.settingsButton.hidden = NO;
    self.slider.hidden = YES;

    [self setUpGestures];
    [self setUpFont];
    [self setUpTextColor];
    [self setUpBackgroundColor];
    [self setUpDateFormatter];
    //[self printFonts];
}

- (void)viewDidUnload
{
    [self stopTimer];
    [self stopUITimer];
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
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)setUpFont
{
    NSString *fontName = [DataModel clockFontName];
    NSUInteger index = [self.fontNames indexOfObject:fontName];
    if (NSNotFound == index)
    {
        index = 0;
    }

    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.timeLabel.minimumScaleFactor = 0.1;

    self.fontValue = (CGFloat)index / self.fontNames.count;

    UIFont *font = [UIFont fontWithName:self.fontNames[index] size:kFontSize];
    [self updateDisplayFont:font];
}

- (void)setUpTextColor
{
    UIColor *textColor = [DataModel clockTextColor];
    self.textColorValue = [self calculateValue:textColor];
    [self updateTextColor:textColor];
}

- (void)setUpBackgroundColor
{
    UIColor *backgroundColor = [DataModel clockBackgroundColor];
    self.backgroundColorValue = [self calculateValue:backgroundColor];
    [self updateBackgroundColor:backgroundColor];
}

- (CGFloat)calculateValue:(UIColor *)color
{
    CGFloat value = 0.0;

    if ([color kdgIsEqualToColor:[UIColor whiteColor]])
    {
        value = 0.0;
    }
    else if ([color kdgIsEqualToColor:[UIColor blackColor]])
    {
        value = 1.0;
    }
    else
    {
        CGFloat hue, saturation, brightness, alpha;
        [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        value = kWhiteSliderThreshold + hue * (1.0 - kWhiteSliderThreshold - kBlackSliderThreshold);
    }

    return value;
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
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

#pragma mark - ui timer

- (void)startUITimer
{
    [self stopUITimer];
    self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:kUITimerInterval
                                                  target:self
                                                selector:@selector(uiTimerFired:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)stopUITimer
{
    [self.uiTimer invalidate];
    self.uiTimer = nil;
}

- (void)uiTimerFired:(NSTimer *)timer
{
    [self showSettingUI:NO];
}

#pragma mark - ui

- (void)updateTimeDisplay
{
    NSDate *now = [NSDate date];
    NSString *time = [self.dateFormatter stringFromDate:now];
    self.timeLabel.text = time;
}

- (void)updateDisplayFont:(UIFont *)font
{
    self.timeLabel.font = font;
}

- (void)updateTextColor:(UIColor *)color
{
    self.timeLabel.textColor = color;
    self.helpLabel.textColor = color;
    [self.backButton setTitleColor:color forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)updateBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)updateHelpLabel:(NSString *)string
{
    self.helpLabel.text = string;
}

- (void)updateSettingsMode
{
    switch (self.settingsMode)
    {
        case SettingsModeFont:
        {
            NSString *fontName = [DataModel clockFontName];
            [self updateHelpLabel:fontName];
            self.slider.value = self.fontValue;
            break;
        }

        case SettingsModeTextColor:
            [self updateHelpLabel:@"text color"];
            self.slider.value = self.textColorValue;
           break;

        case SettingsModeBackgroundColor:
            [self updateHelpLabel:@"background color"];
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

- (void)showSettingUI:(BOOL)show
{
    self.helpLabel.hidden = !show;
    self.slider.hidden = !show;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
    if (self.helpLabel.hidden)
    {
        [self showSettingUI:YES];
        [self updateSettingsMode];
        [self startUITimer];
    }
    else
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
        [self startUITimer];
    }
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

            [DataModel setClockFontName:fontName];

            UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
            [self updateDisplayFont:font];
            [self updateHelpLabel:fontName];

            break;
        }

        case SettingsModeTextColor:
        case SettingsModeBackgroundColor:
        {
            UIColor *color;

            if (slider.value < kWhiteSliderThreshold)
            {
                color = [UIColor whiteColor];
            }
            else if (slider.value > 1.0 - kBlackSliderThreshold)
            {
                color = [UIColor blackColor];
            }
            else
            {
                CGFloat hue;
                hue = (slider.value - kWhiteSliderThreshold) / (1.0 - kWhiteSliderThreshold - kBlackSliderThreshold);
                color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
            }

            if (SettingsModeTextColor == self.settingsMode)
            {
                [DataModel setClockTextColor:color];
                [self updateTextColor:color];
            }
            else
            {
                [DataModel setClockBackgroundColor:color];
                [self updateBackgroundColor:color];
            }

            break;
        }
    }

    [self startUITimer];
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
