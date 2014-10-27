//
//  KDGCommandEngine+Application.m
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine+Application.h"

@implementation KDGCommand (Application)

+ (KDGCommand *)helloCommand { return [[KDGCommand alloc] initWithName:@"hello"]; }
+ (KDGCommand *)worldCommand { return [[KDGCommand alloc] initWithName:@"world"]; }
+ (KDGCommand *)orangeCommand { return [[KDGCommand alloc] initWithName:@"orange"]; }
+ (KDGCommand *)yellowCommand { return [[KDGCommand alloc] initWithName:@"yellow"]; }
+ (KDGCommand *)purpleCommand { return [[KDGCommand alloc] initWithName:@"purple"]; }

@end

@implementation KDGCommandEngine (Application)

+ (KDGCommandEngine *)sharedInstance
{
    static KDGCommandEngine *s_sharedCommandEngine = nil;

    if (s_sharedCommandEngine == nil)
    {
        s_sharedCommandEngine = [[KDGCommandEngine alloc] init];
    }

    return s_sharedCommandEngine;
}

- (void)setUpCommands
{
    NSLog(@"KDGCommandEngine setUpCommands");

    [self registerCommand:[KDGCommand helloCommand]];
    [self registerCommand:[KDGCommand worldCommand]];
    [self registerCommand:[KDGCommand orangeCommand]];
    [self registerCommand:[KDGCommand yellowCommand]];
    [self registerCommand:[KDGCommand purpleCommand]];
}

@end
