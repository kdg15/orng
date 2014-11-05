//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDGBackDoorViewController;

@protocol BackDoorViewControllerDelegate <NSObject>

- (void)backDoorViewControllerDidClose:(KDGBackDoorViewController *)backDoorViewController;

- (NSString *)backDoorViewController:(KDGBackDoorViewController *)backDoorViewController
                   didExecuteCommand:(NSString *)commandName
                       withArguments:(NSArray *)arguments
                             dismiss:(BOOL)dismiss;

@end

@interface KDGBackDoorViewController : UIViewController

@property (nonatomic, weak) id<BackDoorViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) UIColor  *backgroundColor;

@property (nonatomic, strong) IBOutlet UIView      *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton    *executeButton;
@property (nonatomic, strong) IBOutlet UIButton    *executeAndCloseButton;
@property (nonatomic, strong) IBOutlet UITextField *inputField;
@property (nonatomic, strong) IBOutlet UITextView  *outputField;

- (IBAction)closeAction:(id)sender;

- (IBAction)executeAction:(id)sender;
- (IBAction)executeAndCloseAction:(id)sender;

@end

