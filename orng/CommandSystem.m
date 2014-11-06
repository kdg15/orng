//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "CommandSystem.h"

@implementation Command

+ (Command *)listAllCommands { return [[Command alloc] initWithName:@"ls"]; }
+ (Command *)help { return [[Command alloc] initWithName:@"help" numberOfArguments:1]; }

+ (Command *)presentClockViewCommand { return [[Command alloc] initWithName:@"presentClockView"]; }
+ (Command *)dismissClockViewCommand { return [[Command alloc] initWithName:@"dismissClockView"]; }
+ (Command *)presentClockOptionsCommand { return [[Command alloc] initWithName:@"presentClockOptions"]; }
+ (Command *)dismissClockOptionsCommand { return [[Command alloc] initWithName:@"dismissClockOptions"]; }
+ (Command *)presentClockFontOptionsCommand { return [[Command alloc] initWithName:@"presentClockFontOptions"]; }
+ (Command *)dismissClockFontOptionsCommand { return [[Command alloc] initWithName:@"dismissClockFontOptions"]; }
+ (Command *)presentClockForegroundOptionsCommand { return [[Command alloc] initWithName:@"presentClockForegroundOptions"]; }
+ (Command *)dismissClockForegroundOptionsCommand { return [[Command alloc] initWithName:@"dismissClockForegroundOptions"]; }
+ (Command *)presentClockBackgroundOptionsCommand { return [[Command alloc] initWithName:@"presentClockBackgroundOptions"]; }
+ (Command *)dismissClockBackgroundOptionsCommand { return [[Command alloc] initWithName:@"dismissClockBackgroundOptions"]; }

+ (Command *)dimScreenBrightnessCommand     { return [[Command alloc] initWithName:@"dimScreenBrightness"]; }
+ (Command *)restoreScreenBrightnessCommand { return [[Command alloc] initWithName:@"restoreScreenBrightness"]; }

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

+ (Command *)setBackDoorPrompt { return [[Command alloc] initWithName:@"setBackDoorPrompt" numberOfArguments:1]; }
+ (Command *)setBackDoorBackgroundColor { return [[Command alloc] initWithName:@"setBackDoorBackgroundColor" numberOfArguments:4]; }

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
    [self registerCommand:[Command listAllCommands]];
    [self registerCommand:[Command help]];

    [self registerCommand:[Command presentClockViewCommand]];
    [self registerCommand:[Command dismissClockViewCommand]];
    [self registerCommand:[Command presentClockOptionsCommand]];
    [self registerCommand:[Command dismissClockOptionsCommand]];
    [self registerCommand:[Command presentClockFontOptionsCommand]];
    [self registerCommand:[Command dismissClockFontOptionsCommand]];
    [self registerCommand:[Command presentClockForegroundOptionsCommand]];
    [self registerCommand:[Command dismissClockForegroundOptionsCommand]];
    [self registerCommand:[Command presentClockBackgroundOptionsCommand]];
    [self registerCommand:[Command dismissClockBackgroundOptionsCommand]];

    [self registerCommand:[Command dimScreenBrightnessCommand]];
    [self registerCommand:[Command restoreScreenBrightnessCommand]];
    
    [self registerCommand:[Command presentListViewCommand]];
    [self registerCommand:[Command dismissListViewCommand]];
    
    [self registerCommand:[Command presentTestViewCommand]];
    [self registerCommand:[Command dismissTestViewCommand]];
    
    [self registerCommand:[Command presentDummyViewCommand]];
    [self registerCommand:[Command dismissDummyViewCommand]];

    [self registerCommand:[Command printLogCommand]];

    [self registerCommand:[Command setBackDoorPrompt]];
    [self registerCommand:[Command setBackDoorBackgroundColor]];
}

@end
