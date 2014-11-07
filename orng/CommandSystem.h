//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine.h"

@interface Command : KDGCommand

+ (Command *)listAllCommands;
+ (Command *)help;

+ (Command *)log;

+ (Command *)setAnimationFactor;

+ (Command *)presentClockView;
+ (Command *)dismissClockView;
+ (Command *)presentClockOptions;
+ (Command *)dismissClockOptions;
+ (Command *)presentClockFontOptions;
+ (Command *)dismissClockFontOptions;
+ (Command *)presentClockForegroundOptions;
+ (Command *)dismissClockForegroundOptions;
+ (Command *)presentClockBackgroundOptions;
+ (Command *)dismissClockBackgroundOptions;
+ (Command *)dimScreenBrightness;
+ (Command *)restoreScreenBrightness;

+ (Command *)presentListView;
+ (Command *)dismissListView;

+ (Command *)presentTestView;
+ (Command *)dismissTestView;

+ (Command *)presentDummyView;
+ (Command *)dismissDummyView;

+ (Command *)setBackDoorPrompt;
+ (Command *)setBackDoorBackgroundColor;

@end

@interface CommandEngine : KDGCommandEngine

+ (CommandEngine *)sharedInstance;
- (void)setUpCommands;

@end