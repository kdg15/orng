//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "CommandSystem.h"
#import "DataModel.h"
#import "KDGBackDoorViewController.h"
#import "KDGCoverVerticalOverCurrentContextAnimatedTransition.h"
#import "UIView+KDGAnimation.h"

@interface BaseViewController () <UIViewControllerTransitioningDelegate,
                                  BackDoorViewControllerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpBackDoorGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setUpBackDoorGesture
{
    UITapGestureRecognizer *backDoorGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(backDoorAction:)];
    backDoorGesture.numberOfTapsRequired = 3;
    backDoorGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:backDoorGesture];
}

#pragma mark - back door

- (void)backDoorAction:(id)sender
{
//    static BOOL on = NO;
//    on = !on;
//    CGFloat factor = on ? 4.0 : 1.0;
//    [UIView kdgSetGlobalAnimationDurationFactor:factor];

    KDGBackDoorViewController *viewController = [[KDGBackDoorViewController alloc] init];
    viewController.delegate = self;
    viewController.prompt = [NSString stringWithString:[DataModel backDoorPrompt]];
    viewController.backgroundColor = [DataModel backDoorBackgroundColor];

    //  Get a blurred version of current view and use as background image.
    //UIImage *image = [UIScreen kdgCaptureScreen];
    //UIImage *blurredImage = [image applyDarkEffect];
    //viewController.backgroundImage = blurredImage;
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;

    [self presentViewController:viewController
                       animated:YES
                     completion:^{
    }];
}

- (void)backDoorViewControllerDidClose:(KDGBackDoorViewController *)backDoorViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (NSString *)backDoorViewController:(KDGBackDoorViewController *)backDoorViewController
             didExecuteCommand:(NSString *)commandName
                 withArguments:(NSArray *)arguments
                       dismiss:(BOOL)dismiss
{
    __block NSString *result = nil;
    NSError *error = nil;

    CommandEngine *commandEngine = [CommandEngine sharedInstance];
    Command *command = [commandEngine getCommandWithName:commandName
                                               arguments:arguments
                                                   error:&error];

    if (command)
    {
        command.arguments = [NSArray arrayWithArray:arguments];

        if (dismiss)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                NSString *response = [commandEngine executeCommand:command];
                result = [self getCommandResult:response name:commandName arguments:arguments];
            }];
        }
        else
        {
            NSString *response = [commandEngine executeCommand:command];
            result = [self getCommandResult:response name:commandName arguments:arguments];
        }
    }
    else
    {
        result = [NSString stringWithFormat:@"# error: %@", error.localizedDescription];
    }

    return result;
}

- (NSString *)getCommandResult:(NSString *)response name:(NSString *)name arguments:(NSArray *)arguments
{
    NSString *result = nil;

    if (response)
    {
        result = response;
    }
    else
    {
        result = [NSString stringWithFormat:@"executed %@", name];

        if (arguments)
        {
            result = [NSString stringWithFormat:@"executed %@ with args: %@", name, [arguments componentsJoinedByString:@" "]];
        }
    }

    return result;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    KDGCoverVerticalOverCurrentContextAnimatedTransition *transition = [[KDGCoverVerticalOverCurrentContextAnimatedTransition alloc] init];
    transition.duration = 0.4;
    transition.presenting = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    KDGCoverVerticalOverCurrentContextAnimatedTransition *transition = [[KDGCoverVerticalOverCurrentContextAnimatedTransition alloc] init];
    transition.duration = 0.2;
    transition.presenting = NO;
    return transition;
}

@end
