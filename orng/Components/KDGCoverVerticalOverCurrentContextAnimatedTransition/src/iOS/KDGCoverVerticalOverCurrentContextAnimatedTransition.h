//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 In iOS 8 there is a new view controller presentation style UIModalPresentationOverCurrentContext.
 A presentation style where the content is displayed over only the parent view controller’s content.
 
 Since this is not available in iOS 7 you can use this class to achieve the same
 presentation style.

 To use this class you'll need to make your presenting view controller adhere to the
 UIViewControllerTransitioningDelegate protocol and implement the following two methods:
 
 @code
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
 {
     KDGCoverVerticalOverCurrentContextAnimatedTransition *transition = [[KDGCoverVerticalOverCurrentContextAnimatedTransition alloc] init];
     transition.duration = 0.2;
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
 @endcode

 When you present your view use the following code:
 
 @code
 - (void)showView
 {
     YourViewController *yourViewController = [[YourViewController alloc] init];
     yourViewController.delegate = self;

     NSInteger iOSVersion = [UIDevice kdgMajorVersion];
     if (iOSVersion <= 7)
     {
         yourViewController.modalPresentationStyle = UIModalPresentationCustom;
         yourViewController.transitioningDelegate = self;
     }
     else
     {
         yourViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
         yourViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
     }

     [self presentViewController:feedViewController animated:YES completion:^{
     }];
 }
 @endcode
 */
@interface KDGCoverVerticalOverCurrentContextAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, assign) NSTimeInterval duration;

@end
