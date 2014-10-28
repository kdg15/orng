//
//  KDGCommandEngine+Application.m
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "CommandSystem.h"

@implementation Command

+ (Command *)presentClockViewCommand { return [[Command alloc] initWithName:@"presentClockView"]; }
+ (Command *)dismissClockViewCommand { return [[Command alloc] initWithName:@"dismissClockView"]; }
+ (Command *)presentClockOptionsCommand { return [[Command alloc] initWithName:@"presentClockOptions"]; }
+ (Command *)dismissClockOptionsCommand { return [[Command alloc] initWithName:@"dismissClockOptions"]; }
+ (Command *)presentClockForegroundOptionsCommand { return [[Command alloc] initWithName:@"presentClockForegroundOptions"]; }
+ (Command *)dismissClockForegroundOptionsCommand { return [[Command alloc] initWithName:@"dismissClockForegroundOptions"]; }

+ (Command *)presentListViewCommand { return [[Command alloc] initWithName:@"presentListView"]; }
+ (Command *)dismissListViewCommand { return [[Command alloc] initWithName:@"dismissListView"]; }

+ (Command *)presentTestViewCommand { return [[Command alloc] initWithName:@"presentTestView"]; }
+ (Command *)dismissTestViewCommand { return [[Command alloc] initWithName:@"dismissTestView"]; }

+ (Command *)presentDummyViewCommand { return [[Command alloc] initWithName:@"presentDummyView"]; }
+ (Command *)dismissDummyViewCommand { return [[Command alloc] initWithName:@"dismissDummyView"]; }

+ (Command *)printLogCommand
{
    Command *command = [[Command alloc] initWithName:@"printLog"];
    command.log = NO;
    return command;
}

@end

@implementation CommandEngine

+ (CommandEngine *)sharedInstance
{
    static CommandEngine *s_sharedCommandEngine = nil;

    if (s_sharedCommandEngine == nil)
    {
        s_sharedCommandEngine = [[CommandEngine alloc] init];
    }

    return s_sharedCommandEngine;
}

- (void)setUpCommands
{
    NSLog(@"CommandEngine setUpCommands");

    [self registerCommand:[Command presentClockViewCommand]];
    [self registerCommand:[Command dismissClockViewCommand]];
    [self registerCommand:[Command presentClockOptionsCommand]];
    [self registerCommand:[Command dismissClockOptionsCommand]];
    [self registerCommand:[Command presentClockForegroundOptionsCommand]];
    [self registerCommand:[Command dismissClockForegroundOptionsCommand]];
    
    [self registerCommand:[Command presentListViewCommand]];
    [self registerCommand:[Command dismissListViewCommand]];
    
    [self registerCommand:[Command presentTestViewCommand]];
    [self registerCommand:[Command dismissTestViewCommand]];
    
    [self registerCommand:[Command presentDummyViewCommand]];
    [self registerCommand:[Command dismissDummyViewCommand]];

    [self registerCommand:[Command printLogCommand]];
}

@end
