//
//  KDGCommandEngine.h
//  orng
//
//  Created by brian on 26.10.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDGCommand : NSObject

- (id)initWithName:(NSString *)name;

@property (nonatomic, readonly) NSString *name;

@end

@interface KDGCommandEngine : NSObject

- (void)registerCommand:(KDGCommand *)command;
- (NSArray *)getCommands;

- (void)executeCommand:(KDGCommand *)command;

@end
