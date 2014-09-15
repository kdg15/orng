//
//  ClockViewController.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "ClockViewController.h"
#import "DataModel.h"

@interface ClockViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpGestures];
    [self setUpFont];
    [self setUpColor];
    [self setUpDateFormatter];
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
    [self updateUI];
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

- (void)setUpGestures
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)setUpFont
{
    //UIFont *font = [UIFont fontWithName:@"Noteworthy-Light" size:256.0];
    //UIFont *font = [UIFont fontWithName:@"GillSans-Light" size:256.0];
    //UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:256.0];
    UIFont *font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:256.0];
    //UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:256.0];
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
    self.backButton.titleLabel.textColor = textColor;
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
    [self updateUI];
}

#pragma mark - ui

- (void)updateUI
{
    NSDate *now = [NSDate date];
    NSString *time = [self.dateFormatter stringFromDate:now];
    self.timeLabel.text = time;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doubleTapAction:(id)sender
{
    NSLog(@"doubleTapAction");

    static BOOL sDimmed = NO;
    static CGFloat sOriginalBrightness = 0.0;

    UIScreen *screen = [UIScreen mainScreen];
    if (sDimmed)
    {
        screen.brightness = sOriginalBrightness;
    }
    else
    {
        screen.brightness = 0.0;
    }

    sDimmed = !sDimmed;
}

@end
