//
//  ClockViewController.h
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;

- (IBAction)backAction:(id)sender;

@end
