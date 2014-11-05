//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine.h"

@interface Command : KDGCommand

+ (Command *)presentClockViewCommand;
+ (Command *)dismissClockViewCommand;
+ (Command *)presentClockOptionsCommand;
+ (Command *)dismissClockOptionsCommand;
+ (Command *)presentClockFontOptionsCommand;
+ (Command *)dismissClockFontOptionsCommand;
+ (Command *)presentClockForegroundOptionsCommand;
+ (Command *)dismissClockForegroundOptionsCommand;
+ (Command *)presentClockBackgroundOptionsCommand;
+ (Command *)dismissClockBackgroundOptionsCommand;
+ (Command *)dimScreenBrightnessCommand;
+ (Command *)restoreScreenBrightnessCommand;

+ (Command *)presentListViewCommand;
+ (Command *)dismissListViewCommand;

+ (Command *)presentTestViewCommand;
+ (Command *)dismissTestViewCommand;

+ (Command *)presentDummyViewCommand;
+ (Command *)dismissDummyViewCommand;

+ (Command *)printLogCommand;

+ (Command *)setBackDoorPrompt;
+ (Command *)setBackDoorBackgroundColor;

@end

@interface CommandEngine : KDGCommandEngine

+ (CommandEngine *)sharedInstance;
- (void)setUpCommands;

@end