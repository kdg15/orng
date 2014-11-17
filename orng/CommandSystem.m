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

+ (Command *)presentGridView { return [[Command alloc] initWithName:@"presentGridView"]; }
+ (Command *)dismissGridView { return [[Command alloc] initWithName:@"dismissGridView"]; }

+ (Command *)presentSampleView { return [[Command alloc] initWithName:@"presentSampleView"]; }
+ (Command *)dismissSampleView { return [[Command alloc] initWithName:@"dismissSampleView"]; }

+ (Command *)presentScratchView { return [[Command alloc] initWithName:@"presentScratchView"]; }
+ (Command *)dismissScratchView { return [[Command alloc] initWithName:@"dismissScratchView"]; }

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
    
    [self registerCommand:[Command presentGridView]];
    [self registerCommand:[Command dismissGridView]];
    
    [self registerCommand:[Command presentSampleView]];
    [self registerCommand:[Command dismissSampleView]];
    
    [self registerCommand:[Command presentScratchView]];
    [self registerCommand:[Command dismissScratchView]];
    
    [self registerCommand:[Command setBackDoorPrompt]];
    [self registerCommand:[Command setBackDoorBackgroundColor]];
}

@end
