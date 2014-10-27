//
//  KDGCommandEngine.h
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KDGCommandExecutedNotification;

@interface KDGCommand : NSObject

- (id)initWithName:(NSString *)name;
- (BOOL)isEqualToCommand:(KDGCommand *)command;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, assign) BOOL log;

@end

@class KDGCommandEngine;

@protocol KDGCommandEngineResponder <NSObject>

- (void)executedCommand:(NSNotification *)notification;

@end

@interface KDGCommandEngine : NSObject

- (void)registerCommand:(KDGCommand *)command;
- (id)getCommandWithName:(NSString *)name;

- (NSArray *)getCommands;
- (NSArray *)getCommandLog;
- (void)clearCommandLog;

- (void)executeCommand:(KDGCommand *)command;
- (void)executeCommands:(NSArray *)commands withInterval:(NSTimeInterval)interval;

- (id)getCommandFromNotification:(NSNotification *)notification;

- (void)addResponder:(NSObject *)responder;
- (void)removeResponder:(NSObject *)responder;

@end
