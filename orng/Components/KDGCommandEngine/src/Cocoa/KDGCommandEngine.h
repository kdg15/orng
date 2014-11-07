//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KDGCommandErrorDomain;

NS_ENUM(NSInteger, KDGCommandError)
{
    KDGCommandDoesNotExistError,
    KDGCommandWrongNumberOfArgumentsError
};

extern NSString * const KDGCommandExecutedNotification;

@interface KDGCommand : NSObject

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name numberOfArguments:(NSInteger)numberOfArguments;
- (id)initWithName:(NSString *)name numberOfArguments:(NSInteger)numberOfArguments log:(BOOL)log;

- (BOOL)isEqualToCommand:(KDGCommand *)command;

@property (nonatomic, readonly) NSString  *name;
@property (nonatomic, readonly) NSInteger numberOfArguments;
@property (nonatomic, strong)   NSArray   *arguments;
@property (nonatomic, assign)   BOOL      log;

@end

@class KDGCommandEngine;

@protocol KDGCommandEngineResponder <NSObject>

- (void)executedCommand:(NSNotification *)notification;

@end

@interface KDGCommandEngine : NSObject

@property (nonatomic, strong) NSString *commandResponse;

- (void)registerCommand:(KDGCommand *)command;

- (id)getCommandWithName:(NSString *)name
               arguments:(NSArray *)arguments
                   error:(NSError **)error;

- (NSArray *)getCommands;
- (NSArray *)getCommandLog;
- (void)clearCommandLog;

- (NSString *)executeCommand:(KDGCommand *)command;
- (void)executeCommands:(NSArray *)commands withInterval:(NSTimeInterval)interval;

- (id)getCommandFromNotification:(NSNotification *)notification;

- (void)addResponder:(NSObject *)responder;
- (void)removeResponder:(NSObject *)responder;

@end
