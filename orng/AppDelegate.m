//
//  AppDelegate.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "AppDelegate.h"
#import "CommandSystem.h"

@interface AppDelegate () <KDGCommandEngineResponder>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(executedCommand:)
                                                 name:KDGCommandExecutedNotification
                                               object:nil];
     */

    NSLog(@"setUpCommandSystem");
    [self setUpCommandSystem];
    NSLog(@"done");

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return [self.window.rootViewController supportedInterfaceOrientations];
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    //NSLog(@"PlayWithWSWithLibAppDelegate -- supportedInterfaceOrientationsForWindow");
//    if([UICommonUtils isiPad]){
//        return UIInterfaceOrientationMaskAll;
//    }else if(flagOrientationAll == YES){
//        return UIInterfaceOrientationMaskAll;
//    } else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

#pragma mark - command system

- (void)setUpCommandSystem
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    [commandEngine setUpCommands];

    NSArray *commands = [commandEngine getCommands];
    for (Command *command in commands)
    {
        NSLog(@"command = %@", command);
    }
    
    [commandEngine addResponder:self];
}

- (void)executedCommand:(NSNotification *)notification
{
    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandFromNotification:notification];

    if ([command isEqualToCommand:[Command printLogCommand]])
    {
        NSLog(@"logged commands:\n%@", [commandEngine getCommandLog]);
    }
}

@end
