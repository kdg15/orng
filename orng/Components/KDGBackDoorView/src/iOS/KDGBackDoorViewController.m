//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGBackDoorViewController.h"

static NSString * const kDefaultPrompt = @"%ld:";

@interface KDGBackDoorViewController ()

@property (nonatomic, assign) NSInteger counter;

@end

@implementation KDGBackDoorViewController

- (id)init
{
    return [self initWithNibName:@"KDGBackDoorView" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.counter = 0;
        self.prompt = kDefaultPrompt;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backgroundView.layer.cornerRadius = 8.0;
    self.backgroundView.backgroundColor = self.backgroundColor;
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.backgroundView.backgroundColor = backgroundColor;
}

#pragma mark - actions

- (IBAction)closeAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backDoorViewControllerDidClose:)])
    {
        [self.delegate backDoorViewControllerDidClose:self];
    }
}

- (IBAction)executeAction:(id)sender
{
    [self.inputField resignFirstResponder];
    [self execute:self.inputField.text dismiss:NO];
}

- (IBAction)executeAndCloseAction:(id)sender
{
    [self.inputField resignFirstResponder];
    [self execute:self.inputField.text dismiss:YES];
}

#pragma mark - execute command

- (void)execute:(NSString *)commandInput dismiss:(BOOL)dismiss
{
    NSArray *array = [commandInput componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (array.count > 0)
    {
        NSString *commandName = [array objectAtIndex:0];
        if (commandName.length > 0)
        {
            NSArray *args = nil;
            if (array.count > 1)
            {
                NSRange range = NSMakeRange(1, array.count - 1);
                args = [array subarrayWithRange:range];
            }
            
            NSString *result = nil;

            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(backDoorViewController:
                                                            didExecuteCommand:
                                                            withArguments:
                                                            dismiss:)])
            {
                result = [self.delegate backDoorViewController:self
                                             didExecuteCommand:commandName
                                                 withArguments:args
                                                       dismiss:dismiss];
            }

            [self outputResult:result];
        }
    }
}

#pragma mark - output

- (void)outputResult:(NSString *)result
{
    if (result)
    {
        NSString *text = self.outputField.text;
        NSString *prompt = [NSString stringWithFormat:self.prompt, (long)self.counter++];
        NSString *modifiedResult = [NSString stringWithFormat:@"%@ %@\n", prompt, result];
        NSString *newText = [text stringByAppendingString:modifiedResult];
        self.outputField.text = newText;
        
        NSRange range = NSMakeRange([newText length] - [modifiedResult length], [modifiedResult length]);
        [self.outputField scrollRangeToVisible:range];
    }
}

@end
