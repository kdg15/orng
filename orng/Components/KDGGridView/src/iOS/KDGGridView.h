//
//  KDGGridView.h
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDGGridViewCell.h"

//  The KDGGridView class provides support for displaying a list of items
//  in a grid layout.
//
//  The grid view arranges its items in a grid of rows and columns. KDGGridView
//  is a subclass of UIScrollView which allows the user to scroll through the
//  content. The grid view may have a vertical orientation (the default) or
//  a horizontal orientation.
//
//  In a vertical orientation content is arranged left to right in a row and
//  additional rows are added to accommodate more content. The user scrolls up
//  and down to see the additional content.
//
//  In a horizontal orientation content is arranged top to bottom in a column
//  and additional columns are added to accommodate more content. The user
//  scrolls left and right to see the additional content.
//
//  A KDGGridView object must have an object that acts as a data source and an
//  object that acts as a delegate. The data source must adopt the
//  KDGGridViewDataSource protocol and the delegate must adopt the
//  KDGGridViewDelegate protocol.
//
//  KDGGridView only displays visible cells (KDGGridViewCell). Non-visible cells
//  are cached for reuse.
//
//  The gridView:cellAtIndex delegate method requires you to instantiate and
//  return an KDGGridViewCell object. For example:
//
//    - (KDGGridViewCell *)gridView:(KDGGridView *)gridView cellAtIndex:(NSUInteger)index
//    {
//        static NSString *CellIdentifier = @"GridCell";
//        
//        KDGGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil)
//        {
//            NSString *nibName = @"GridCell_iPad";
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) nibName = @"GridCell_iPhone";
//                
//            [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
//            _gridCell.reuseIdentifier = CellIdentifier;
//            cell = _gridCell;
//            self.gridCell = nil;
//        }
//        
//        ...
//        
//        return cell;
//    }
//
//  KDGGridView supports a selection mode where tapping on an item will draw it
//  with a selection view if you provide one on KDGGridViewCell.

@protocol KDGGridViewDelegate;
@protocol KDGGridViewDataSource;

enum KDGGridViewOrientation
{
    KDGGridViewOrientationVertical,
    KDGGridViewOrientationHorizontal
};

@interface KDGGridView : UIScrollView

//  The size of cell items.
//
@property (nonatomic) CGSize itemSize;

//  The space between cell items.
//
@property (nonatomic) CGFloat itemSpace;

//  A vertical orientation is the default.
//
@property (nonatomic) enum KDGGridViewOrientation orientation;

//  A Boolean value that determines whether the receiver is in selection mode.
//
//  When this property is YES, the view is in selection mode. While in selection
//  tapping on an unselected cell will select it. Conversely, tapping a selected
//  cell with deselect it.
//
@property (nonatomic) BOOL selecting;

@property (nonatomic, assign) IBOutlet id <KDGGridViewDelegate> gridViewDelegate;
@property (nonatomic, assign) IBOutlet id <KDGGridViewDataSource> dataSource;

- (void)reloadData;

- (KDGGridViewCell *)cellAtIndex:(NSUInteger)index;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

//  While in selection mode call indicesForSelectedCells to return an array
//  identifying the selected cells. Returns nil if there are no selected cells.
//
- (NSArray *)indicesForSelectedCells;

@end

@protocol KDGGridViewDelegate <NSObject>

@optional

//  Called whenever a cell is tapped, regardless of selecting property value.
//
- (void)gridView:(KDGGridView *)gridView didSelectCellAtIndex:(NSUInteger)index;

@end

@protocol KDGGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInGridView:(KDGGridView *)gridView;
- (KDGGridViewCell *)gridView:(KDGGridView *)gridView cellAtIndex:(NSUInteger)index;

@end

