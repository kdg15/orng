//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "MainViewController.h"
#import "CommandSystem.h"
#import "DataModel.h"
#import "KDGBackDoorViewController.h"
#import "UIView+KDGAnimation.h"

static NSString * const kClockViewSegue   = @"ClockViewSegue";
static NSString * const kListViewSegue    = @"ListViewSegue";
static NSString * const kGridViewSegue    = @"GridViewSegue";
static NSString * const kSampleViewSegue  = @"SampleViewSegue";
static NSString * const kScratchViewSegue = @"ScratchViewSegue";

@interface MainViewController () <KDGCommandEngineResponder>

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[CommandEngine sharedInstance] addResponder:self];
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kClockViewSegue])
    {
    }
    else if ([segue.identifier isEqualToString:kListViewSegue])
    {
    }
    else if ([segue.identifier isEqualToString:kGridViewSegue])
    {
    }
    else if ([segue.identifier isEqualToString:kSampleViewSegue])
    {
    }
    else if ([segue.identifier isEqualToString:kScratchViewSegue])
    {
    }
}

#pragma mark - actions

- (IBAction)clockAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockView]];
}

- (IBAction)listAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentListView]];
}

- (IBAction)gridAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentGridView]];
}

- (IBAction)sampleAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentSampleView]];
}

- (IBAction)scratchAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentScratchView]];
}

- (void)sliderTouchDownAction:(id)sender { NSLog(@"sliderTouchDown"); }
- (void)sliderTouchUpInsideAction:(id)sender { NSLog(@"sliderTouchUpInside"); }
- (void)sliderTouchUpOutsideAction:(id)sender { NSLog(@"sliderTouchUpOutside"); }
- (void)sliderTouchCancelAction:(id)sender { NSLog(@"sliderTouchCancelAction"); }
- (void)sliderTouchDragInsideAction:(id)sender { NSLog(@"sliderTouchDragInside"); }
- (void)sliderTouchDragOutsideAction:(id)sender { NSLog(@"sliderTouchDragOutside"); }
- (void)sliderTouchDragEnterAction:(id)sender { NSLog(@"sliderTouchDragEnter"); }
- (void)sliderTouchDragExitAction:(id)sender { NSLog(@"sliderTouchDragExit"); }

#pragma mark - command system

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];
    NSArray *arguments = command.arguments;
    NSString *response = nil;

    if ([command isEqualToCommand:[Command listAllCommands]])
    {
        NSArray *allCommands = [commandEngine getCommands];
        response = [NSString stringWithFormat:@"available commands: %@", [allCommands  componentsJoinedByString:@", "]];
    }
    else if ([command isEqualToCommand:[Command log]])
    {
        if (arguments.count == 1)
        {
            NSString *arg = arguments[0];
            if ([arg isEqualToString:@"print"])
            {
                NSArray *log = [commandEngine getCommandLog];
                response = [NSString stringWithFormat:@"command log: %@", [log componentsJoinedByString:@", "]];
            }
            else if ([arg isEqualToString:@"clear"])
            {
                [commandEngine clearCommandLog];
                response = @"log cleared";
            }
            else if ([arg isEqualToString:@"play"])
            {
                NSArray *log = [commandEngine getCommandLog];
                [commandEngine clearCommandLog];
                [commandEngine executeCommands:log withInterval:0.8];
            }
        }
    }
    else if ([command isEqualToCommand:[Command presentClockView]])
    {
        [self performSegueWithIdentifier:kClockViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentListView]])
    {
        [self performSegueWithIdentifier:kListViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentGridView]])
    {
        [self performSegueWithIdentifier:kGridViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentSampleView]])
    {
        [self performSegueWithIdentifier:kSampleViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentScratchView]])
    {
        [self performSegueWithIdentifier:kScratchViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command setBackDoorPrompt]])
    {
        if (arguments.count == 1)
        {
            NSString *prompt = arguments[0];
            [DataModel setBackDoorPrompt:prompt];

            if (self.presentedViewController &&
                [self.presentedViewController isKindOfClass:[KDGBackDoorViewController class]])
            {
                KDGBackDoorViewController *backDoorViewController = (KDGBackDoorViewController *)self.presentedViewController;
                backDoorViewController.prompt = [NSString stringWithString:[DataModel backDoorPrompt]];
            }
        }
    }
    else if ([command isEqualToCommand:[Command setBackDoorBackgroundColor]])
    {
        if (arguments.count == 4)
        {
            CGFloat red   = [arguments[0] floatValue];
            CGFloat green = [arguments[1] floatValue];
            CGFloat blue  = [arguments[2] floatValue];
            CGFloat alpha = [arguments[3] floatValue];

            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            [DataModel setBackDoorBackgroundColor:color];

            if (self.presentedViewController &&
                [self.presentedViewController isKindOfClass:[KDGBackDoorViewController class]])
            {
                KDGBackDoorViewController *backDoorViewController = (KDGBackDoorViewController *)self.presentedViewController;
                backDoorViewController.backgroundColor = [DataModel backDoorBackgroundColor];
            }
        }
    }
    else if ([command isEqualToCommand:[Command setAnimationFactor]])
    {
        if (arguments.count == 1)
        {
            CGFloat factor = [arguments[0] floatValue];
            [UIView kdgSetAnimationDurationFactor:factor];
            response = [NSString stringWithFormat:@"animation scale factor is %.1f", factor];
        }
    }
    
    if (response)
    {
        [commandEngine setCommandResponse:response];
    }
}

@end
