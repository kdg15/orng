//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackDoorViewController;

@protocol BackDoorViewControllerDelegate <NSObject>

- (void)backDoorViewControllerDidClose:(BackDoorViewController *)backDoorViewController;

- (NSString *)backDoorViewController:(BackDoorViewController *)backDoorViewController
                   didExecuteCommand:(NSString *)commandName
                       withArguments:(NSArray *)arguments
                             dismiss:(BOOL)dismiss;

@end

@interface BackDoorViewController : UIViewController

@property (nonatomic, weak) id<BackDoorViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *prompt;

@property (nonatomic, strong) IBOutlet UIButton *executeButton;
@property (nonatomic, strong) IBOutlet UIButton *executeAndCloseButton;
@property (nonatomic, strong) IBOutlet UITextField *inputField;
@property (nonatomic, strong) IBOutlet UITextView  *outputField;

- (IBAction)closeAction:(id)sender;

- (IBAction)executeAction:(id)sender;
- (IBAction)executeAndCloseAction:(id)sender;

@end
