//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "CommandSystem.h"

@implementation Command

+ (Command *)listAllCommands { return [[Command alloc] initWithName:@"ls"]; }
+ (Command *)help { return [[Command alloc] initWithName:@"help" numberOfArguments:1]; }

+ (Command *)log { return [[Command alloc] initWithName:@"log" numberOfArguments:1 log:NO]; }

+ (Command *)setAnimationFactor { return [[Command alloc] initWithName:@"setAnimationFactor" numberOfArguments:1]; }

+ (Command *)presentClockView { return [[Command alloc] initWithName:@"presentClockView"]; }
+ (Command *)dismissClockView { return [[Command alloc] initWithName:@"dismissClockView"]; }
+ (Command *)presentClockOptions { return [[Command alloc] initWithName:@"presentClockOptions"]; }
+ (Command *)dismissClockOptions { return [[Command alloc] initWithName:@"dismissClockOptions"]; }
+ (Command *)presentClockFontOptions { return [[Command alloc] initWithName:@"presentClockFontOptions"]; }
+ (Command *)dismissClockFontOptions { return [[Command alloc] initWithName:@"dismissClockFontOptions"]; }
+ (Command *)presentClockForegroundOptions { return [[Command alloc] initWithName:@"presentClockForegroundOptions"]; }
+ (Command *)dismissClockForegroundOptions { return [[Command alloc] initWithName:@"dismissClockForegroundOptions"]; }
+ (Command *)presentClockBackgroundOptions { return [[Command alloc] initWithName:@"presentClockBackgroundOptions"]; }
+ (Command *)dismissClockBackgroundOptions { return [[Command alloc] initWithName:@"dismissClockBackgroundOptions"]; }

+ (Command *)dimScreenBrightness     { return [[Command alloc] initWithName:@"dimScreenBrightness"]; }
+ (Command *)restoreScreenBrightness { return [[Command alloc] initWithName:@"restoreScreenBrightness"]; }

+ (Command *)presentListView { return [[Command alloc] initWithName:@"presentListView"]; }
+ (Command *)dismissListView { return [[Command alloc] initWithName:@"dismissListView"]; }

+ (Command *)presentTestView { return [[Command alloc] initWithName:@"presentTestView"]; }
+ (Command *)dismissTestView { return [[Command alloc] initWithName:@"dismissTestView"]; }

+ (Command *)presentDummyView { return [[Command alloc] initWithName:@"presentDummyView"]; }
+ (Command *)dismissDummyView { return [[Command alloc] initWithName:@"dismissDummyView"]; }

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

    [self registerCommand:[Command log]];

    [self registerCommand:[Command setAnimationFactor]];

    [self registerCommand:[Command presentClockView]];
    [self registerCommand:[Command dismissClockView]];
    [self registerCommand:[Command presentClockOptions]];
    [self registerCommand:[Command dismissClockOptions]];
    [self registerCommand:[Command presentClockFontOptions]];
    [self registerCommand:[Command dismissClockFontOptions]];
    [self registerCommand:[Command presentClockForegroundOptions]];
    [self registerCommand:[Command dismissClockForegroundOptions]];
    [self registerCommand:[Command presentClockBackgroundOptions]];
    [self registerCommand:[Command dismissClockBackgroundOptions]];

    [self registerCommand:[Command dimScreenBrightness]];
    [self registerCommand:[Command restoreScreenBrightness]];
    
    [self registerCommand:[Command presentListView]];
    [self registerCommand:[Command dismissListView]];
    
    [self registerCommand:[Command presentTestView]];
    [self registerCommand:[Command dismissTestView]];
    
    [self registerCommand:[Command presentDummyView]];
    [self registerCommand:[Command dismissDummyView]];

    [self registerCommand:[Command setBackDoorPrompt]];
    [self registerCommand:[Command setBackDoorBackgroundColor]];
}

@end
