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

typedef NS_ENUM(NSInteger, OptionsMode)
{
    OptionsModeFont,
    OptionsModeTextColor,
    OptionsModeBackgroundColor
};

static CGFloat kFontSize = 256.0;

static NSTimeInterval kTimerInterval        = 0.2;
static NSTimeInterval kOptionsTimerInterval = 3.0;

@interface ClockViewController () <KDGCommandEngineResponder>

@property (nonatomic, assign) OptionsMode optionsMode;

@property (nonatomic, assign) CGFloat     fontValue;
@property (nonatomic, assign) CGFloat     textColorValue;
@property (nonatomic, assign) CGFloat     backgroundColorValue;
@property (nonatomic, assign) CGFloat     originalValue;
@property (nonatomic, assign) CGFloat     originalBrightness;
@property (nonatomic, assign) BOOL        brightnessDimmed;

@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, strong) NSTimer     *optionsTimer;

@property (nonatomic, strong) NSArray     *fontNames;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;


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

    self.brightnessDimmed = NO;
    self.optionSlider.hidden = YES;

    [self setUpFont];
    [self setUpTextColor];
    [self setUpBackgroundColor];
    [self setUpDateFormatter];
    //[self printFonts];
    
    self.optionSlider.minimumValue = 0.0;
    self.optionSlider.maximumValue = 1.0;

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
    [self stopOptionsTimer];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateTimeDisplay];
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

- (void)setUpFont
{
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.timeLabel.minimumScaleFactor = 0.1;

    NSString *fontName = [DataModel clockFontName];
    self.fontValue = [self calculateValueFromFontName:fontName];
    UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
    [self updateDisplayFont:font];
}

- (void)setUpTextColor
{
    UIColor *textColor = [DataModel clockTextColor];
    self.textColorValue = [self calculateValueFromColor:textColor];
    [self updateTextColor:textColor];
}

- (void)setUpBackgroundColor
{
    UIColor *backgroundColor = [DataModel clockBackgroundColor];
    self.backgroundColorValue = [self calculateValueFromColor:backgroundColor];
    [self updateBackgroundColor:backgroundColor];
}

- (CGFloat)calculateValueFromFontName:(NSString *)fontName
{
    NSUInteger index = [self.fontNames indexOfObject:fontName];
    if (NSNotFound == index)
    {
        index = 0;
    }
    
    CGFloat value = (CGFloat)index / self.fontNames.count;
    
    return value;
}

- (NSString *)calculateFontNameFromValue:(CGFloat)value
{
    NSInteger fontCount = self.fontNames.count;
    NSInteger fontIndex = (fontCount - 1) * value;
    NSString *fontName = self.fontNames[fontIndex];
    
    return fontName;
}

- (CGFloat)calculateValueFromColor:(UIColor *)color
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

- (UIColor *)calculateColorFromValue:(CGFloat)value
{
    UIColor *color;
    
    if (value < kWhiteSliderThreshold)
    {
        color = [UIColor whiteColor];
    }
    else if (value > 1.0 - kBlackSliderThreshold)
    {
        color = [UIColor blackColor];
    }
    else
    {
        CGFloat hue;
        hue = (value - kWhiteSliderThreshold) / (1.0 - kWhiteSliderThreshold - kBlackSliderThreshold);
        color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
    }
    
    return color;
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

#pragma mark - options timer

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
    [self.backButton setTitleColor:color forState:UIControlStateNormal];
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

- (void)presentOptionsButton
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

- (void)dismissOptionsButton
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

//  todo: rename because same method used by font, foreground, and background options.
//
- (void)presentForegroundOptions
{
    NSTimeInterval interval = 0.3;
    NSTimeInterval delay = 0.0;
    
    CGPoint startPoint = self.foregroundButton.center;
    
    for (UIView *view in @[self.cancelButton,
                           self.okayButton])
    {
        CGPoint endPoint = view.center;
        
        CGAffineTransform endTransform = CGAffineTransformIdentity;
        CGAffineTransform startTransform = CGAffineTransformMakeTranslation(startPoint.x - endPoint.x,
                                                                            startPoint.y - endPoint.y);
        
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
                         }];
    }
    
    self.optionSlider.hidden = NO;
}

//  todo: rename because same method used by font, foreground, and background options.
//
- (void)dismissForegroundOptions
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
    
    self.optionSlider.hidden = YES;
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
    [commandEngine executeCommand:[Command presentClockFontOptionsCommand]];
}

- (IBAction)foregroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockForegroundOptionsCommand]];
}

- (IBAction)backgroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockBackgroundOptionsCommand]];
}

- (IBAction)brightnessAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];

    if (self.brightnessDimmed)
    {
        [commandEngine executeCommand:[Command restoreScreenBrightnessCommand]];
    }
    else
    {
        [commandEngine executeCommand:[Command dimScreenBrightnessCommand]];
    }

    [commandEngine executeCommand:[Command dismissClockOptionsCommand]];
}

- (IBAction)cancelAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockForegroundOptionsCommand]];
    
    if (OptionsModeFont == self.optionsMode)
    {
        self.fontValue = self.originalValue;
        NSString *fontName = [self calculateFontNameFromValue:self.fontValue];
        [DataModel setClockFontName:fontName];
        UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
        [self updateDisplayFont:font];
    }
    else if (OptionsModeTextColor == self.optionsMode)
    {
        self.textColorValue = self.originalValue;
        UIColor *color = [self calculateColorFromValue:self.textColorValue];
        [DataModel setClockTextColor:color];
        [self updateTextColor:color];
    }
    else if (OptionsModeBackgroundColor == self.optionsMode)
    {
        self.backgroundColorValue = self.originalValue;
        UIColor *color = [self calculateColorFromValue:self.backgroundColorValue];
        [DataModel setClockBackgroundColor:color];
        [self updateBackgroundColor:color];
    }
}

- (IBAction)okayAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockForegroundOptionsCommand]];
    
    CGFloat value = self.optionSlider.value;

    if (OptionsModeFont == self.optionsMode)
    {
        self.fontValue = value;
    }
    else if (OptionsModeTextColor == self.optionsMode)
    {
        self.textColorValue = value;
    }
    else if (OptionsModeBackgroundColor == self.optionsMode)
    {
        self.backgroundColorValue = value;
    }
}

- (IBAction)optionSliderChangedAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    switch (self.optionsMode)
    {
        case OptionsModeFont:
        {
            NSInteger fontCount = self.fontNames.count;
            NSInteger fontIndex = (fontCount - 1) * slider.value;
            NSString *fontName = self.fontNames[fontIndex];
            
            [DataModel setClockFontName:fontName];
            
            UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
            [self updateDisplayFont:font];

            break;
        }
        case OptionsModeTextColor:
        case OptionsModeBackgroundColor:
        {
            UIColor *color = [self calculateColorFromValue:slider.value];
            
            if (OptionsModeTextColor == self.optionsMode)
            {
                [DataModel setClockTextColor:color];
                [self updateTextColor:color];
            }
            else if (OptionsModeBackgroundColor == self.optionsMode)
            {
                [DataModel setClockBackgroundColor:color];
                [self updateBackgroundColor:color];
            }

            break;
        }
    }
}

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
        [self dismissOptionsButton];
    }
    else if ([command isEqualToCommand:[Command dismissClockOptionsCommand]])
    {
        [self dismissOptions];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockFontOptionsCommand]])
    {
        self.optionsMode = OptionsModeFont;
        [self dismissOptions];
        self.originalValue = self.fontValue;
        self.optionSlider.value = self.originalValue;
        [self presentForegroundOptions];
    }
    else if ([command isEqualToCommand:[Command dismissClockFontOptionsCommand]])
    {
        [self dismissForegroundOptions];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockForegroundOptionsCommand]])
    {
        self.optionsMode = OptionsModeTextColor;
        [self dismissOptions];
        self.originalValue = self.textColorValue;
        self.optionSlider.value = self.originalValue;
        [self presentForegroundOptions];
    }
    else if ([command isEqualToCommand:[Command dismissClockForegroundOptionsCommand]])
    {
        [self dismissForegroundOptions];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockBackgroundOptionsCommand]])
    {
        self.optionsMode = OptionsModeBackgroundColor;
        [self dismissOptions];
        self.originalValue = self.backgroundColorValue;
        self.optionSlider.value = self.originalValue;
        [self presentForegroundOptions];
    }
    else if ([command isEqualToCommand:[Command dismissClockBackgroundOptionsCommand]])
    {
        [self dismissForegroundOptions];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command dimScreenBrightnessCommand]])
    {
        self.brightnessDimmed = YES;
        UIScreen *screen = [UIScreen mainScreen];
        self.originalBrightness = screen.brightness;
        screen.brightness = 0.0;
        NSLog(@"dim: set brightness to %.1f", screen.brightness);
    }
    else if ([command isEqualToCommand:[Command restoreScreenBrightnessCommand]])
    {
        self.brightnessDimmed = NO;
        UIScreen *screen = [UIScreen mainScreen];
        screen.brightness = self.originalBrightness;
        NSLog(@"restore: set brightness to %.1f", screen.brightness);
    }
}

@end
