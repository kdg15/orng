//
//  ViewController.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "MainViewController.h"
#import "CommandSystem.h"
#import "DummyViewController.h"

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
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(executedCommand:)
                                                 name:KDGCommandExecutedNotification
                                               object:nil];
     */
    [[CommandEngine sharedInstance] addResponder:self];
}

- (void)dealloc
{
    [[CommandEngine sharedInstance] removeResponder:self];
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KDGCommandExecutedNotification
                                                  object:nil];
     */
    
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
}

@end
