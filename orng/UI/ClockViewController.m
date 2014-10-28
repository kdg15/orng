//
//  ClockViewController.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ClockViewController.h"
#import "DataModel.h"
#import "CommandSystem.h"
#import "UIColor+KDGUtilities.h"
#import "KDGUtilities.h"

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
static NSTimeInterval kOptionsTimerInterval = 3.0;

@interface ClockViewController () <KDGCommandEngineResponder>

@property (nonatomic, assign) SettingsMode settingsMode;
@property (nonatomic, assign) CGFloat fontValue;
@property (nonatomic, assign) CGFloat textColorValue;
@property (nonatomic, assign) CGFloat backgroundColorValue;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *uiTimer;
@property (nonatomic, strong) NSTimer *optionsTimer;
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
    
    for (UIView *view in @[self.fontButton,
                           self.foregroundButton,
                           self.backgroundButton,
                           self.brightnessButton,
                           self.cancelButton,
                           self.okayButton])
    {
        view.hidden = YES;
        view.layer.cornerRadius = 0.5 * view.bounds.size.width;
    }
    
    [[CommandEngine sharedInstance] addResponder:self];
}

- (void)dealloc
{
    [[CommandEngine sharedInstance] removeResponder:self];
}

- (void)viewDidUnload
{
    [self stopTimer];
    [self stopUITimer];
    [self stopOptionsTimer];
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
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(doubleTapAction:)];
//    doubleTap.numberOfTapsRequired = 2;
//    doubleTap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:doubleTap];
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

#pragma mark - dismiss options timer

- (void)startOptionsTimer
{
    [self stopOptionsTimer];
    self.optionsTimer = [NSTimer scheduledTimerWithTimeInterval:kOptionsTimerInterval
                                                         target:self
                                                       selector:@selector(optionsTimerFired:)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)stopOptionsTimer
{
    [self.optionsTimer invalidate];
    self.optionsTimer = nil;
}

- (void)optionsTimerFired:(NSTimer *)timer
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
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
    [self.dimButton setTitleColor:color forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:color forState:UIControlStateNormal];
    [self.optionsButton setTitleColor:color forState:UIControlStateNormal];
    
    for (UIButton *button in @[self.fontButton,
                               self.foregroundButton,
                               self.backgroundButton,
                               self.brightnessButton,
                               self.cancelButton,
                               self.okayButton])
    {
        [button setBackgroundColor:color];
    }
}

- (void)updateBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;

    for (UIButton *button in @[self.fontButton,
                               self.foregroundButton,
                               self.backgroundButton,
                               self.brightnessButton,
                               self.cancelButton,
                               self.okayButton])
    {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
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

- (void)presentOptions
{
    //  Hide options button.
    //
    {
        NSTimeInterval interval = 0.2;
        NSTimeInterval delay = 0.0;

        [UIView animateWithDuration:interval
                              delay:delay
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.optionsButton.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             self.optionsButton.hidden = YES;
                             self.optionsButton.alpha = 1.0;
                         }];
    }
    
    //  Show options.
    //
    {
        NSTimeInterval interval = 0.7;
        
        CGPoint startPoint = self.optionsButton.center;
        
        for (UIView *view in @[self.fontButton,
                               self.foregroundButton,
                               self.backgroundButton,
                               self.brightnessButton])
        {
            NSTimeInterval delay = FloatRandomInRange(0.0, 0.2);
            
            CGPoint endPoint = view.center;
            
            CGAffineTransform endTransform = CGAffineTransformIdentity;
            CGAffineTransform startTransform = CGAffineTransformMakeTranslation(startPoint.x - endPoint.x,
                                                                                startPoint.y - endPoint.y);
            startTransform = CGAffineTransformScale(startTransform, 0.01, 0.01);
            
            view.transform = startTransform;
            view.hidden = NO;
            
            [UIView animateWithDuration:interval
                                  delay:delay
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:20.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 view.transform = endTransform;
                             } completion:^(BOOL finished) {
                                 [self startOptionsTimer];
                             }];
        }
    }
}

- (void)dismissOptions
{
    //  Show options button.
    //
    {
        NSTimeInterval interval = 0.3;
        NSTimeInterval delay = 0.0;

        self.optionsButton.alpha = 0.0;
        self.optionsButton.hidden = NO;
        
        [UIView animateWithDuration:interval
                              delay:delay
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.optionsButton.alpha = 1.0;
                         } completion:^(BOOL finished) {
                         }];
    }
    
    //  Hide options.
    //
    {
        NSTimeInterval interval = 0.3;
        
        CGAffineTransform startTransform = CGAffineTransformIdentity;
        CGAffineTransform endTransform = CGAffineTransformMakeScale(0.01, 0.01);
        
        for (UIView *view in @[self.fontButton,
                               self.foregroundButton,
                               self.backgroundButton,
                               self.brightnessButton])
        {
            NSTimeInterval delay = FloatRandomInRange(0.0, 0.1);
            
            view.transform = startTransform;
            
            [UIView animateWithDuration:interval
                                  delay:delay
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 view.transform = endTransform;
                             } completion:^(BOOL finished) {
                                 view.hidden = YES;
                             }];
        }
    }
}

- (void)presentForegroundOptions
{
    //  Show foreground options.
    //
    {
        NSTimeInterval interval = 0.3;//0.7;
        NSTimeInterval delay = 0.0;
        
        CGPoint startPoint = self.foregroundButton.center;
        
        for (UIView *view in @[self.cancelButton,
                               self.okayButton])
        {
            CGPoint endPoint = view.center;
            
            CGAffineTransform endTransform = CGAffineTransformIdentity;
            CGAffineTransform startTransform = CGAffineTransformMakeTranslation(startPoint.x - endPoint.x,
                                                                                startPoint.y - endPoint.y);
            //startTransform = CGAffineTransformScale(startTransform, 0.01, 0.01);
            
            view.transform = startTransform;
            view.hidden = NO;
            
            [UIView animateWithDuration:interval
                                  delay:delay
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:10.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 view.transform = endTransform;
                             } completion:^(BOOL finished) {
                                 [self startOptionsTimer];
                             }];
        }
    }
}

- (void)dismissForegroundOptions
{
    //  Hide options.
    //
    {
        NSTimeInterval interval = 0.3;
        
        CGAffineTransform startTransform = CGAffineTransformIdentity;
        CGAffineTransform endTransform = CGAffineTransformMakeScale(0.01, 0.01);
        
        for (UIView *view in @[self.cancelButton,
                               self.okayButton])
        {
            NSTimeInterval delay = FloatRandomInRange(0.0, 0.1);
            
            view.transform = startTransform;
            
            [UIView animateWithDuration:interval
                                  delay:delay
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 view.transform = endTransform;
                             } completion:^(BOOL finished) {
                                 view.hidden = YES;
                             }];
        }
    }
}

#pragma mark - actions

- (IBAction)optionsAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockOptionsCommand]];
}

- (IBAction)backAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockViewCommand]];
}

- (IBAction)fontAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
}

- (IBAction)foregroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
    [commandEngine executeCommand:[Command presentClockForegroundOptionsCommand]];
}

- (IBAction)backgroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
}

- (IBAction)brightnessAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
}

- (IBAction)cancelAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockForegroundOptionsCommand]];
}

- (IBAction)okayAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockForegroundOptionsCommand]];
}

- (IBAction)dimAction:(id)sender
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

//- (IBAction)doubleTapAction:(id)sender
//{
//    static BOOL sDimmed = NO;
//    static CGFloat sOriginalBrightness = 0.0;
//
//    UIScreen *screen = [UIScreen mainScreen];
//    if (sDimmed)
//    {
//        screen.brightness = sOriginalBrightness;
//    }
//    else
//    {
//        sOriginalBrightness = screen.brightness;
//        screen.brightness = 0;
//    }
//
//    sDimmed = !sDimmed;
//}

#pragma mark - command system

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];
    
    if ([command isEqualToCommand:[Command dismissClockViewCommand]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([command isEqualToCommand:[Command presentClockOptionsCommand]])
    {
        [self presentOptions];
    }
    else if ([command isEqualToCommand:[Command dismissClockOptionsCommand]])
    {
        [self dismissOptions];
    }
    else if ([command isEqualToCommand:[Command presentClockForegroundOptionsCommand]])
    {
        [self presentForegroundOptions];
    }
    else if ([command isEqualToCommand:[Command dismissClockForegroundOptionsCommand]])
    {
        [self dismissForegroundOptions];
    }
}

@end
