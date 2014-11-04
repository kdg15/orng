//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGCoverVerticalOverCurrentContextAnimatedTransition.h"

@implementation KDGCoverVerticalOverCurrentContextAnimatedTransition

- (id)init
{
    self = [super init];
    if (self)
    {
        _duration = 0.2;
        _presenting = YES;
    }
    return self;
}

- (CGRect)rectForDismissedState:(id)transitionContext
{
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];

    NSString *viewControllerKey = (self.presenting ?
                                   UITransitionContextFromViewControllerKey :
                                   UITransitionContextToViewControllerKey);

    fromViewController = [transitionContext viewControllerForKey:viewControllerKey];

    CGSize size = containerView.bounds.size;
    CGRect rect = CGRectZero;

    switch (fromViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
        {
            return CGRectMake(-size.width, 0, size.width, size.height);
            break;
        }

        case UIInterfaceOrientationLandscapeLeft:
        {
            return CGRectMake(size.width, 0, size.width, size.height);
            break;
        }

        case UIInterfaceOrientationPortraitUpsideDown:
        {
            return CGRectMake(0, -size.height, size.width, size.height);
            break;
        }

        case UIInterfaceOrientationPortrait:
        {
            return CGRectMake(0, size.height, size.width, size.height);
            break;
        }

        case UIInterfaceOrientationUnknown:
        {
            break;
        }
    }

    return rect;
}

- (CGRect)rectForPresentedState:(id)transitionContext
{
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];

    NSString *viewControllerKey = (self.presenting ?
                                   UITransitionContextFromViewControllerKey :
                                   UITransitionContextToViewControllerKey);

    fromViewController = [transitionContext viewControllerForKey:viewControllerKey];

    CGSize size = containerView.bounds.size;
    CGRect rect = CGRectZero;

    switch (fromViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
        {
            rect = CGRectOffset([self rectForDismissedState:transitionContext], size.width, 0);
            break;
        }

        case UIInterfaceOrientationLandscapeLeft:
        {
            rect = CGRectOffset([self rectForDismissedState:transitionContext], -size.width, 0);
            break;
        }

        case UIInterfaceOrientationPortraitUpsideDown:
        {
            rect = CGRectOffset([self rectForDismissedState:transitionContext], 0, size.height);
            break;
        }

        case UIInterfaceOrientationPortrait:
        {
            rect = CGRectOffset([self rectForDismissedState:transitionContext], 0, -size.height);
            break;
        }

        case UIInterfaceOrientationUnknown:
        {
            break;
        }
    }

    return rect;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    if (self.presenting)
    {
        toViewController.view.frame = [self rectForDismissedState:transitionContext];
        [containerView addSubview:toViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = [self rectForPresentedState:transitionContext];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.frame = [self rectForDismissedState:transitionContext];
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             [fromViewController.view removeFromSuperview];
                         }];
    }
}

@end
