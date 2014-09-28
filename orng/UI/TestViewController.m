//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <KDGGridViewDataSource, KDGGridViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.gridView.itemSize = CGSizeMake(200, 70);
    self.gridView.itemSpace = 2;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - grid view


- (void)gridView:(KDGGridView *)gridView didSelectCellAtIndex:(NSUInteger)index
{
    NSLog(@"gridView didSelectCellAtIndex:%d", index);
}

- (NSInteger)numberOfItemsInGridView:(KDGGridView *)gridView
{
    NSInteger numberOfItems = 23;
    return numberOfItems;
}

- (KDGGridViewCell *)gridView:(KDGGridView *)gridView cellAtIndex:(NSUInteger)index
{
    static NSString *CellIdentifier = @"GridCell";

    TestViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSString *nibName = @"GridCell_iPad";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) nibName = @"GridCell_iPhone";

        [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];

        _gridCell.reuseIdentifier = CellIdentifier;
        cell = _gridCell;
        self.gridCell = nil;
    }

    cell.label.text = [NSString stringWithFormat:@"cell %d", index];

    return cell;
}

#pragma mark - actions

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
