//
//  KDGCommandEngine.m
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine.h"

NSString * const KDGCommandExecutedNotification = @"KDGCommandExecutedNotification";

static NSString * const UserInfoCommandKey = @"UserInfoCommandKey";

@implementation KDGCommand

- (id)initWithName:(NSString *)name
{
    self = [super init];

    if (self)
    {
        _name = [NSString stringWithString:name];
        _log = YES;
    }

    return self;
}

- (NSString *)description
{
    return self.name;
}

- (BOOL)isEqualToCommand:(KDGCommand *)command
{
    return [self.name isEqualToString:command.name];
}

@end

@interface KDGCommandEngine ()

@property (nonatomic, strong) NSMutableDictionary *commands;
@property (nonatomic, strong) NSMutableArray *commandLog;
@property (nonatomic, assign) NSTimeInterval  commandTimerInterval;
@property (nonatomic, strong) NSTimer        *commandTimer;
@property (nonatomic, strong) NSMutableArray *playbackCommands;

@end

@implementation KDGCommandEngine

- (id)init
{
    self = [super init];

    if (self)
    {
        _commands = [NSMutableDictionary dictionary];
        _commandLog = [NSMutableArray array];
        _playbackCommands = nil;
        _commandTimerInterval = 0.2;
    }

    return self;
}

- (void)dealloc
{
    [self stopCommandTimer];
}

- (void)registerCommand:(KDGCommand *)command
{
    id object = [self.commands objectForKey:command.name];
    if (object)
    {
        NSLog(@"# error: command '%@' already registered", command);
    }
    else
    {
        self.commands[command.name] = command;
    }
}

- (id)getCommandWithName:(NSString *)name
{
    return self.commands[name];
}

- (NSArray *)getCommands
{
    return [self.commands allValues];
}

- (NSArray *)getCommandLog
{
    return [NSArray arrayWithArray:self.commandLog];
}

- (void)clearCommandLog
{
    [self.commandLog removeAllObjects];
}

- (void)executeCommand:(KDGCommand *)command
{
    if (command == nil) return;

    id object = [self.commands objectForKey:command.name];
    if (object)
    {
        if (command.log)
        {
            [self.commandLog addObject:command];
        }
        
        NSDictionary *userInfo = @{ UserInfoCommandKey : command };
        
        //NSLog(@"--- execute command: %@", command);
        [[NSNotificationCenter defaultCenter] postNotificationName:KDGCommandExecutedNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        NSLog(@"# error: can't execute command '%@' because it is not registered", command);
    }
}

- (void)executeCommands:(NSArray *)commands withInterval:(NSTimeInterval)interval
{
    NSLog(@"start command playback");
    self.playbackCommands = [NSMutableArray arrayWithArray:commands];
    self.commandTimerInterval = interval;
    [self startCommandTimer];
}

- (id)getCommandFromNotification:(NSNotification *)notification
{
    return notification.userInfo[UserInfoCommandKey];
}

- (void)addResponder:(NSObject *)responder
{
    [[NSNotificationCenter defaultCenter] addObserver:responder
                                             selector:@selector(executedCommand:)
                                                 name:KDGCommandExecutedNotification
                                               object:nil];
}

- (void)removeResponder:(NSObject *)responder
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KDGCommandExecutedNotification
                                                  object:nil];
}

#pragma mark - timer

- (void)startCommandTimer
{
    [self stopCommandTimer];
    self.commandTimer = [NSTimer scheduledTimerWithTimeInterval:self.commandTimerInterval
                                                    target:self
                                                  selector:@selector(commandTimerFired:)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)stopCommandTimer
{
    [self.commandTimer invalidate];
    self.commandTimer = nil;
}

- (void)commandTimerFired:(NSTimer *)timer
{
    if (self.playbackCommands == nil)
    {
        NSLog(@"no playback commands");
        [self stopCommandTimer];
    }
    else
    {
        if (0 == self.playbackCommands.count)
        {
            [self stopCommandTimer];
            NSLog(@"done command playback");
        }
        else
        {
            id command = [self.playbackCommands objectAtIndex:0];
            [self.playbackCommands removeObjectAtIndex:0];
            NSLog(@"execute command %@", command);
            [self executeCommand:command];
        }
    }
}

@end
