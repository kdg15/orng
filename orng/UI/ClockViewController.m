//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ClockViewController.h"
#import "DataModel.h"
#import "CommandSystem.h"
#import "NSString+AppStrings.h"
#import "UIColor+AppColors.h"
#import "KDGUtilities.h"
#import "KDGBackDoorViewController.h"
#import "UIColor+KDGUtilities.h"
#import "UIView+KDGAnimation.h"
#import "UIDevice+KDGUtilities.h"
#import "NSObject+KDGBlocks.h"

static const BOOL kUseUIViewAnimation = NO;

static const CGFloat kWhiteSliderThreshold = 0.05;
static const CGFloat kBlackSliderThreshold = 0.05;

static const NSTimeInterval kAnimationDuration = 0.15;
static const NSTimeInterval kAnimationDelay    = 0.1;

typedef NS_ENUM(NSInteger, OptionsMode)
{
    OptionsModeFont,
    OptionsModeTextColor,
    OptionsModeBackgroundColor
};

static CGFloat kFontSize = 256.0;

static NSTimeInterval kTimerInterval           = 0.2;
static NSTimeInterval kOptionsTimerInterval    = 3.0;
static NSTimeInterval kBrightnessTimerInterval = 3.0;

@interface ClockViewController () <KDGCommandEngineResponder>

@property (nonatomic, assign) OptionsMode optionsMode;

@property (nonatomic, assign) CGFloat     fontValue;
@property (nonatomic, assign) CGFloat     textColorValue;
@property (nonatomic, assign) CGFloat     backgroundColorValue;
@property (nonatomic, assign) CGFloat     originalValue;
@property (nonatomic, assign) CGFloat     originalBrightness;
@property (nonatomic, assign) BOOL        brightnessDimmed;
@property (nonatomic, assign) BOOL        brightnessTemporarilyRestored;

@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, strong) NSTimer     *optionsTimer;
@property (nonatomic, strong) NSTimer     *brightnessTimer;

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
    self.brightnessTemporarilyRestored = NO;
    self.optionSlider.hidden = YES;

    [self setUpGestures];
    [self setUpFont];
    [self setUpTextColor];
    [self setUpBackgroundColor];
    [self setUpDateFormatter];
    //[self printFonts];

    [self.backButton setTitle:[NSString backString] forState:UIControlStateNormal];
    [self.optionsButton setTitle:[NSString moreString] forState:UIControlStateNormal];

    self.optionSlider.minimumValue = 0.0;
    self.optionSlider.maximumValue = 1.0;

    self.backButton.hidden = YES;

    for (KDGButton *button in @[self.fontButton,
                                self.foregroundButton,
                                self.backgroundButton,
                                self.brightnessButton,
                                self.okayButton,
                                self.cancelButton])
    {
        button.hidden = YES;
        button.backgroundColor = [UIColor appLightBlueColor];
        button.highlightColor = [button.backgroundColor kdgDarkerColor];
        button.shadowOpacity = 1.0;
        button.shadowOffset = CGSizeMake(0, 0);
        button.shadowRadius = 0.5;
    }

    self.brightnessButton.selectionColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    self.fontButton.text = [NSString fontString];
    self.brightnessButton.text = [NSString brightnessString];
    self.okayButton.text = [NSString okayString];
    self.cancelButton.text = [NSString cancelString];

    /*
    //  save the desired constraint constants.
    //
    NSArray *constraints = @[self.constraintFontButtonX,
                             self.constraintFontButtonY,
                             self.constraintForegroundButtonX,
                             self.constraintForegroundButtonY,
                             self.constraintBackgroundButtonX,
                             self.constraintBackgroundButtonY,
                             self.constraintBrightnessButtonX,
                             self.constraintBrightnessButtonY];
    
    NSMutableDictionary *constraintDictionary = [NSMutableDictionary dictionaryWithCapacity:constraints.count];
    for (NSLayoutConstraint *constraint in constraints)
    {
        //[constraintDictionary setObject:[NSNumber numberWithFloat:constraint.constant] forKey:(id <NSCopying>)constraint];
        constraintDictionary[(id <NSCopying>)constraint] = [NSNumber numberWithFloat:constraint.constant];
    }

    NSLog(@"constraintDictionary = %@", constraintDictionary);
     */

    if (kUseUIViewAnimation)
    {
        self.constraintFontButtonX.constant = 0.0;
        self.constraintFontButtonY.constant = 0.0;
        
        self.constraintForegroundButtonX.constant = 0.0;
        self.constraintForegroundButtonY.constant = 0.0;
        
        self.constraintBackgroundButtonX.constant = 0.0;
        self.constraintBackgroundButtonY.constant = 0.0;
        
        self.constraintBrightnessButtonX.constant = 0.0;
        self.constraintBrightnessButtonY.constant = 0.0;
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
    [self stopBrightnessTimer];
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
    [super viewWillAppear:animated];
    
    [self updateTimeDisplay];
    [self startTimer];
    [self disableSleepMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self stopTimer];
    [self enableSleepMode];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

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
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(singleTapAction:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.timeLabel addGestureRecognizer:singleTapGesture];
}

- (void)setUpFont
{
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.timeLabel.minimumScaleFactor = 12.0 / kFontSize;

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
    NSInteger fontIndex = ceilf((fontCount - 1) * value);
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
    [commandEngine executeCommand:[Command dismissClockOptions]];
}

#pragma mark - brightness timer

- (void)startBrightnessTimer
{
    [self stopBrightnessTimer];
    self.brightnessTimer = [NSTimer scheduledTimerWithTimeInterval:kBrightnessTimerInterval
                                                         target:self
                                                       selector:@selector(brightnessTimerFired:)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)stopBrightnessTimer
{
    [self.brightnessTimer invalidate];
    self.brightnessTimer = nil;
}

- (void)brightnessTimerFired:(NSTimer *)timer
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dimScreenBrightness]];
    self.brightnessTimer = nil;
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
    self.foregroundButton.swatchColor = color;
}

- (void)updateBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.backgroundButton.swatchColor = color;
}

- (void)presentBackButton
{
    self.backButton.hidden = NO;
}

- (void)dismissBackButton
{
    self.backButton.hidden = YES;
}

- (void)presentOptionsButton
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.4];
    NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:0.0];
    
    self.optionsButton.alpha = 0.0;
    self.optionsButton.hidden = NO;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.optionsButton.alpha = 1.0;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)dismissOptionsButton
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.2];
    NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:0.0];
    
    [UIView animateWithDuration:duration
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
    if (kUseUIViewAnimation)
    {
        NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:kAnimationDuration];
        
        NSArray *views = @[self.fontButton,
                           self.foregroundButton,
                           self.backgroundButton,
                           self.brightnessButton];
        
        NSInteger iOSVersion = [UIDevice kdgMajorVersion];
        if (iOSVersion <= 7)
        {
            [self.view layoutIfNeeded];
            
            self.constraintFontButtonX.constant = 72.0;
            self.constraintFontButtonY.constant = 20.0;
            
            self.constraintForegroundButtonX.constant = 24.0;
            self.constraintForegroundButtonY.constant = 20.0;
            
            self.constraintBackgroundButtonX.constant = -24.0;
            self.constraintBackgroundButtonY.constant = 20.0;
            
            self.constraintBrightnessButtonX.constant = -72.0;
            self.constraintBrightnessButtonY.constant = 20.0;
            
            __block NSInteger counter = views.count;
            
            for (UIView *view in views)
            {
                view.hidden = NO;
                
                //CATransform3D fromTransform = view.layer.transform;//CATransform3DMakeScale(0.1, 0.1, 1.0);
                //fromTransform = CATransform3DScale(fromTransform, 0.1, 0.1, 1.0);
                //CATransform3D toTransform = view.layer.transform;//CATransform3DMakeScale(1.0, 1.0, 1.0);
                
                //view.layer.transform = fromTransform;
                
                NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, kAnimationDelay)];
                
                [UIView animateWithDuration:duration
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [view layoutIfNeeded];
                                     //view.layer.transform = toTransform;
                                 } completion:^(BOOL finished) {
                                     counter--;
                                     if (counter == 0)
                                     {
                                         [self startOptionsTimer];
                                     }
                                 }];
            }
            
            //[self startOptionsTimer];
            //[self.view layoutIfNeeded];
        }
        else
        {
            [self.view layoutIfNeeded];
            
            self.constraintFontButtonX.constant = 72.0;
            self.constraintFontButtonY.constant = 20.0;
            
            self.constraintForegroundButtonX.constant = 24.0;
            self.constraintForegroundButtonY.constant = 20.0;
            
            self.constraintBackgroundButtonX.constant = -24.0;
            self.constraintBackgroundButtonY.constant = 20.0;
            
            self.constraintBrightnessButtonX.constant = -72.0;
            self.constraintBrightnessButtonY.constant = 20.0;
            
            __block NSInteger counter = views.count;
            
            for (UIView *view in views)
            {
                view.hidden = NO;
                
                CATransform3D fromTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);
                CATransform3D toTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                
                view.layer.transform = fromTransform;
                
                NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, kAnimationDelay)];
                
                [UIView animateWithDuration:duration
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [view layoutIfNeeded];
                                     view.layer.transform = toTransform;
                                 } completion:^(BOOL finished) {
                                     counter--;
                                     if (counter == 0)
                                     {
                                         [self startOptionsTimer];
                                     }
                                 }];
            }
        }
    }
    else
    {
        CFTimeInterval duration = [UIView kdgAdjustAnimationDuration:kAnimationDuration];

        NSArray *views = @[self.fontButton,
                           self.foregroundButton,
                           self.backgroundButton,
                           self.brightnessButton];
        
        for (UIView *view in views)
        {
            view.hidden = NO;
        }
        
        [CATransaction begin];
        {
            [CATransaction setCompletionBlock:^{
                [self startOptionsTimer];
            }];
            
            for (UIView *view in views)
            {
                CFTimeInterval delay = KDGRandomFloatInRange(0.0, kAnimationDelay);
                
                CGPoint fromPoint = self.optionsButton.center;
                CGPoint toPoint = view.center;
                
                [view kdgAddAnimateTransform:duration
                                       delay:delay
                                   fromPoint:fromPoint
                                     toPoint:toPoint
                                   fromScale:CGSizeMake(0.1, 0.1)
                                     toScale:CGSizeMake(1.0, 1.0)];
                
                //[view kdgAddAnimateFadeIn:duration delay:0.0];
            }
        }
        [CATransaction commit];
    }
}

- (void)dismissOptions
{
    if (kUseUIViewAnimation)
    {
        NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:kAnimationDuration];
        
        NSArray *views = @[self.fontButton,
                           self.foregroundButton,
                           self.backgroundButton,
                           self.brightnessButton];
        
        NSInteger iOSVersion = [UIDevice kdgMajorVersion];
        if (iOSVersion <= 7)
        {
            [self.view layoutIfNeeded];
            
            self.constraintFontButtonX.constant = 0.0;
            self.constraintFontButtonY.constant = 0.0;
            
            self.constraintForegroundButtonX.constant = 0.0;
            self.constraintForegroundButtonY.constant = 0.0;
            
            self.constraintBackgroundButtonX.constant = 0.0;
            self.constraintBackgroundButtonY.constant = 0.0;
            
            self.constraintBrightnessButtonX.constant = 0.0;
            self.constraintBrightnessButtonY.constant = 0.0;
            
            for (UIView *view in views)
            {
                //CATransform3D fromTransform = view.layer.transform;//CATransform3DMakeScale(1.0, 1.0, 1.0);
                //CATransform3D toTransform = view.layer.transform;//CATransform3DMakeScale(0.1, 0.1, 1.0);
                //toTransform = CATransform3DScale(toTransform, 0.1, 0.1, 1.0);
                
                //CATransform3D transform = view.layer.transform;
                //view.layer.transform = fromTransform;
                
                NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, kAnimationDelay)];
                
                [UIView animateWithDuration:duration
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [view layoutIfNeeded];
                                     //view.layer.transform = toTransform;
                                 } completion:^(BOOL finished) {
                                     view.hidden = YES;
                                     //view.layer.transform = fromTransform;
                                 }];
            }
        }
        else
        {
            [self.view layoutIfNeeded];
            
            self.constraintFontButtonX.constant = 0.0;
            self.constraintFontButtonY.constant = 0.0;
            
            self.constraintForegroundButtonX.constant = 0.0;
            self.constraintForegroundButtonY.constant = 0.0;
            
            self.constraintBackgroundButtonX.constant = 0.0;
            self.constraintBackgroundButtonY.constant = 0.0;
            
            self.constraintBrightnessButtonX.constant = 0.0;
            self.constraintBrightnessButtonY.constant = 0.0;
            
            for (UIView *view in views)
            {
                CATransform3D fromTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                CATransform3D toTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);
                
                view.layer.transform = fromTransform;
                
                NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, kAnimationDelay)];
                
                [UIView animateWithDuration:duration
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [view layoutIfNeeded];
                                     view.layer.transform = toTransform;
                                 } completion:^(BOOL finished) {
                                     view.hidden = YES;
                                     view.layer.transform = fromTransform;
                                 }];
            }
        }
    }
    else
    {
        CFTimeInterval duration = [UIView kdgAdjustAnimationDuration:kAnimationDuration];

        NSArray *views = @[self.fontButton,
                           self.foregroundButton,
                           self.backgroundButton,
                           self.brightnessButton];
        
        [CATransaction begin];
        {
            [CATransaction setCompletionBlock:^{
                for (UIView *view in views)
                {
                    view.hidden = YES;
                }
            }];
            
            for (UIView *view in views)
            {
                CFTimeInterval delay = KDGRandomFloatInRange(0.0, kAnimationDelay);
                
                CGPoint fromPoint = view.center;
                CGPoint toPoint = self.optionsButton.center;
                
                [view kdgAddAnimateTransform:duration
                                       delay:delay
                                   fromPoint:fromPoint
                                     toPoint:toPoint
                                   fromScale:CGSizeMake(1.0, 1.0)
                                     toScale:CGSizeMake(0.1, 0.1)];
                
                //[view kdgAddAnimateFadeOut:duration delay:0.0];
            }
        }
        [CATransaction commit];
    }
}

- (void)presentOptionSlider
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.4];

    NSArray *views = @[self.cancelButton,
                       self.okayButton,
                       self.optionSlider];

    CGPoint fromPoint = self.optionSlider.center;

    for (UIView *view in views)
    {
        BOOL animate = YES;
        if (animate)
        {
            CGPoint toPoint = view.center;

            CATransform3D fromTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);
            CATransform3D toTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);

            view.center = fromPoint;
            view.layer.transform = fromTransform;
            view.hidden = NO;

            NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, 0.15)];

            [UIView animateWithDuration:duration
                                  delay:delay
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:20.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 view.center = toPoint;
                                 view.layer.transform = toTransform;
                             } completion:^(BOOL finished) {
                             }];
        }
        else
        {
            view.hidden = NO;

        }
    }
}

- (void)dismissOptionSlider
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.2];
    NSTimeInterval midDuration = [UIView kdgAdjustAnimationDuration:0.05];

    NSArray *views = @[self.cancelButton,
                       self.okayButton,
                       self.optionSlider];

    CGPoint toPoint = self.optionsButton.center;

    for (UIView *view in views)
    {
        CGPoint fromPoint = view.center;
        CGPoint midPoint = view.center;

        CATransform3D fromTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        CATransform3D midTransform = CATransform3DMakeScale(1.2, 1.2, 1.0);
        CATransform3D toTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);

        view.center = fromPoint;
        view.layer.transform = fromTransform;

        NSTimeInterval delay = [UIView kdgAdjustAnimationDuration:KDGRandomFloatInRange(0.0, 0.05)];

        [UIView animateWithDuration:midDuration
                              delay:delay
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             view.center = midPoint;
                             view.layer.transform = midTransform;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:duration - midDuration
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  view.center = toPoint;
                                                  view.layer.transform = toTransform;
                                              } completion:^(BOOL finished) {
                                                  // hide it and then restore to original state.
                                                  view.hidden = YES;
                                                  view.center = fromPoint;
                                                  view.layer.transform = fromTransform;
                                              }];
                         }];
    }
}

- (void)shrinkTimeView
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.2];

    self.timeViewBottomConstraint.constant = 120.0;

    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)restoreTimeView
{
    NSTimeInterval duration = [UIView kdgAdjustAnimationDuration:0.2];

    self.timeViewBottomConstraint.constant = 40.0;

    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)restoreScreenBrightness
{
    if (self.brightnessDimmed)
    {
        [self startBrightnessTimer];
        CommandEngine *commandEngine = [CommandEngine sharedInstance];
        [commandEngine executeCommand:[Command restoreScreenBrightness]];
    }
}

#pragma mark - actions

- (void)singleTapAction:(id)sender
{
    [self restoreScreenBrightness];
}

- (IBAction)optionsAction:(id)sender
{
    [self restoreScreenBrightness];

    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockOptions]];
}

- (IBAction)backAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockView]];
    
    if (self.brightnessDimmed)
    {
        [commandEngine executeCommand:[Command restoreScreenBrightness]];
    }
}

- (IBAction)fontAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockFontOptions]];
}

- (IBAction)foregroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockForegroundOptions]];
}

- (IBAction)backgroundAction:(id)sender
{
    [self stopOptionsTimer];
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockBackgroundOptions]];
}

- (IBAction)brightnessAction:(id)sender
{
    KDGButton *button = (KDGButton *)sender;
    button.selected = !button.selected;

    [self stopOptionsTimer];

    [self kdgPerformBlock:^{
        CommandEngine *commandEngine = [CommandEngine sharedInstance];

        if (self.brightnessTemporarilyRestored)
        {
            [self stopBrightnessTimer];
            self.brightnessTemporarilyRestored = NO;
            [commandEngine executeCommand:[Command restoreScreenBrightness]];
        }
        else
        {
            if (self.brightnessDimmed)
            {
                [commandEngine executeCommand:[Command restoreScreenBrightness]];
            }
            else
            {
                [commandEngine executeCommand:[Command dimScreenBrightness]];
            }
        }
        
        [commandEngine executeCommand:[Command dismissClockOptions]];
    } afterDelay:self.brightnessButton.selectionDuration];
}

- (IBAction)cancelAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command dismissClockForegroundOptions]];
    
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
    [commandEngine executeCommand:[Command dismissClockForegroundOptions]];
    
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
            NSString *fontName = [self calculateFontNameFromValue:slider.value];
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
    
    if ([command isEqualToCommand:[Command dismissClockView]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([command isEqualToCommand:[Command presentClockOptions]])
    {
        [self presentBackButton];
        [self presentOptions];
        [self shrinkTimeView];
        [self dismissOptionsButton];
    }
    else if ([command isEqualToCommand:[Command dismissClockOptions]])
    {
        [self dismissBackButton];
        [self dismissOptions];
        [self restoreTimeView];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockFontOptions]])
    {
        self.optionsMode = OptionsModeFont;
        [self dismissOptions];
        self.originalValue = self.fontValue;
        self.optionSlider.value = self.originalValue;
        [self presentOptionSlider];
    }
    else if ([command isEqualToCommand:[Command dismissClockFontOptions]])
    {
        [self dismissBackButton];
        [self dismissOptionSlider];
        [self restoreTimeView];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockForegroundOptions]])
    {
        self.optionsMode = OptionsModeTextColor;
        [self dismissOptions];
        self.originalValue = self.textColorValue;
        self.optionSlider.value = self.originalValue;
        [self presentOptionSlider];
    }
    else if ([command isEqualToCommand:[Command dismissClockForegroundOptions]])
    {
        [self dismissBackButton];
        [self dismissOptionSlider];
        [self restoreTimeView];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command presentClockBackgroundOptions]])
    {
        self.optionsMode = OptionsModeBackgroundColor;
        [self dismissOptions];
        self.originalValue = self.backgroundColorValue;
        self.optionSlider.value = self.originalValue;
        [self presentOptionSlider];
    }
    else if ([command isEqualToCommand:[Command dismissClockBackgroundOptions]])
    {
        [self dismissBackButton];
        [self dismissOptionSlider];
        [self restoreTimeView];
        [self presentOptionsButton];
    }
    else if ([command isEqualToCommand:[Command dimScreenBrightness]])
    {
        self.brightnessDimmed = YES;
        UIScreen *screen = [UIScreen mainScreen];
        self.originalBrightness = screen.brightness;
        screen.brightness = 0.0;
    }
    else if ([command isEqualToCommand:[Command restoreScreenBrightness]])
    {
        if (self.brightnessTimer)
        {
            self.brightnessTemporarilyRestored = YES;
        }
        self.brightnessDimmed = NO;
        UIScreen *screen = [UIScreen mainScreen];
        screen.brightness = self.originalBrightness;
    }
}

@end
