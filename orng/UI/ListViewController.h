//
//  ListViewController.h
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "BaseViewController.h"

@interface ListViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel *summaryLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITableViewCell *tableViewCell;

- (IBAction)backAction:(id)sender;

@end
