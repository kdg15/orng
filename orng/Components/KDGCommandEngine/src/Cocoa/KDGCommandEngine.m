//
//  KDGCommandEngine.m
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCommandEngine.h"

@implementation KDGCommand

- (id)initWithName:(NSString *)name
{
    self = [super init];

    if (self)
    {
        _name = [NSString stringWithString:name];
    }

    return self;
}

- (NSString *)description
{
    return self.name;
}

@end

@interface KDGCommandEngine ()

@property (nonatomic, strong) NSMutableArray *commands;

@end

@implementation KDGCommandEngine

- (id)init
{
    NSLog(@"*** KDGCommandEngine init ***");
    self = [super init];

    if (self)
    {
        _commands = [NSMutableArray array];
    }

    return self;
}

- (void)registerCommand:(KDGCommand *)command
{
    if ([self.commands containsObject:command])
    {
        //  Already contains command.
    }
    else
    {
        [self.commands addObject:command];
    }
}

- (NSArray *)getCommands
{
    return [NSArray arrayWithArray:self.commands];
}

- (void)executeCommand:(KDGCommand *)command
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"executedCommand"
                                                        object:self
                                                      userInfo:nil];

}

@end
