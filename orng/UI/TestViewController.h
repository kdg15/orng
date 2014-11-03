//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"
#import "KDGGridView.h"
#import "TestViewCell.h"

@interface TestViewController : BaseViewController

@property (nonatomic, strong) IBOutlet KDGGridView *gridView;
@property (nonatomic, strong) IBOutlet TestViewCell *gridCell;

- (IBAction)backAction:(id)sender;

@end
