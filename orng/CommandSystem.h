//
//  KDGCommandEngine+Application.h
//  orng
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

+ (Command *)presentListViewCommand;
+ (Command *)dismissListViewCommand;

+ (Command *)presentTestViewCommand;
+ (Command *)dismissTestViewCommand;

+ (Command *)presentDummyViewCommand;
+ (Command *)dismissDummyViewCommand;

+ (Command *)printLogCommand;

@end

@interface CommandEngine : KDGCommandEngine

+ (CommandEngine *)sharedInstance;
- (void)setUpCommands;

@end