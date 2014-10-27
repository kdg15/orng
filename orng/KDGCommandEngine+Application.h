//
//  KDGCommandEngine+Application.h
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine.h"

@interface KDGCommand (Application)

+ (KDGCommand *)helloCommand;
+ (KDGCommand *)worldCommand;
+ (KDGCommand *)orangeCommand;
+ (KDGCommand *)yellowCommand;
+ (KDGCommand *)purpleCommand;

@end

@interface KDGCommandEngine (Application)

+ (KDGCommandEngine *)sharedInstance;
- (void)setUpCommands;

@end