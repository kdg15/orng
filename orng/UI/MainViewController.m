//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "MainViewController.h"
#import "CommandSystem.h"
#import "DataModel.h"
#import "DummyViewController.h"
#import "KDGBackDoorViewController.h"

static NSString * const kClockViewSegue = @"ClockViewSegue";
static NSString * const kListViewSegue  = @"ListViewSegue";
static NSString * const kTestViewSegue  = @"TestViewSegue";
static NSString * const kDummyViewSegue = @"DummyViewSegue";

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
    // Dispose of any resources that can be recreated.
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
    else if ([segue.identifier isEqualToString:kTestViewSegue])
    {
    }
    else if ([segue.identifier isEqualToString:kDummyViewSegue])
    {
    }
}

#pragma mark - actions

- (IBAction)clockAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentClockViewCommand]];
}

- (IBAction)listAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentListViewCommand]];
}

- (IBAction)testAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentTestViewCommand]];
}

- (IBAction)dummyAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command presentDummyViewCommand]];
}

- (IBAction)logAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine executeCommand:[Command printLogCommand]];
}

- (IBAction)clearLogAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine clearCommandLog];
}

- (IBAction)playAction:(id)sender
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    
    NSArray *commands = [commandEngine getCommandLog];
    
    /*
    Command *presentClockViewCommand = [commandEngine getCommandWithName:@"presentClockView"];
    Command *dismissClockViewCommand = [commandEngine getCommandWithName:@"dismissClockView"];
    Command *presentListViewCommand = [commandEngine getCommandWithName:@"presentListView"];
    Command *dismissListViewCommand = [commandEngine getCommandWithName:@"dismissListView"];
    Command *presentTestViewCommand = [commandEngine getCommandWithName:@"presentTestView"];
    Command *dismissTestViewCommand = [commandEngine getCommandWithName:@"dismissTestView"];
    Command *presentDummyViewCommand = [commandEngine getCommandWithName:@"presentDummyView"];
    Command *dismissDummyViewCommand = [commandEngine getCommandWithName:@"dismissDummyView"];
    
    NSArray *commands = @[presentClockViewCommand,
                          dismissClockViewCommand,
                          presentListViewCommand,
                          dismissListViewCommand,
                          presentTestViewCommand,
                          dismissTestViewCommand,
                          presentDummyViewCommand,
                          dismissDummyViewCommand];
     */
    
    //[commandEngine executeCommands:commands withInterval:0.8];
    [commandEngine clearCommandLog];
    [commandEngine executeCommands:commands withInterval:0.8];
}

#pragma mark - command system

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];

    if ([command isEqualToCommand:[Command presentClockViewCommand]])
    {
        [self performSegueWithIdentifier:kClockViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentListViewCommand]])
    {
        [self performSegueWithIdentifier:kListViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentTestViewCommand]])
    {
        [self performSegueWithIdentifier:kTestViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command presentDummyViewCommand]])
    {
        [self performSegueWithIdentifier:kDummyViewSegue sender: self];
    }
    else if ([command isEqualToCommand:[Command setBackDoorPrompt]])
    {
        //  todo: should be handled in derived class of KDGBackDoorViewController

        NSArray *arguments = command.arguments;
        if (arguments.count == 1)
        {
            NSString *prompt = arguments[0];
            [DataModel setBackDoorPrompt:prompt];
        }
        else
        {
            NSLog(@"# error: '%@' has wrong number of arguments", command.name);
        }
    }
    else if ([command isEqualToCommand:[Command setBackDoorBackgroundColor]])
    {
        //  todo: should be handled in derived class of KDGBackDoorViewController

        NSArray *arguments = command.arguments;
        if (arguments.count == 4)
        {
            CGFloat red = [arguments[0] floatValue];
            CGFloat green = [arguments[1] floatValue];
            CGFloat blue = [arguments[2] floatValue];
            CGFloat alpha = [arguments[3] floatValue];

            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            [DataModel setBackDoorBackgroundColor:color];
        }
        else
        {
            NSLog(@"# error: '%@' has wrong number of arguments", command.name);
        }
    }
}

@end
