//
//  BaseViewController.m
//  orng
//
//  Created by Brian Kramer on 03.11.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "BackDoorViewController.h"
#import "UIView+KDGAnimation.h"

@interface BaseViewController ()

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
    static BOOL on = NO;
    on = !on;
    CGFloat factor = on ? 4.0 : 1.0;
    [UIView kdgSetGlobalAnimationDurationFactor:factor];
    
    BackDoorViewController *viewController = [[BackDoorViewController alloc] initWithNibName:@"BackDoorView" bundle:nil];
    
    [self presentViewController:viewController
                       animated:YES
                     completion:^{
                         //
                     }];
}


@end
