//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BackDoorViewController.h"

@implementation BackDoorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - actions

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
