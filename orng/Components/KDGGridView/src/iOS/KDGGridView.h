/********************************************************************
 * (C) Copyright 2011 by Autodesk, Inc. All Rights Reserved. By using
 * this code,  you  are  agreeing  to the terms and conditions of the
 * License  Agreement  included  in  the documentation for this code.
 * AUTODESK  MAKES  NO  WARRANTIES,  EXPRESS  OR  IMPLIED,  AS TO THE
 * CORRECTNESS OF THIS CODE OR ANY DERIVATIVE WORKS WHICH INCORPORATE
 * IT.  AUTODESK PROVIDES THE CODE ON AN 'AS-IS' BASIS AND EXPLICITLY
 * DISCLAIMS  ANY  LIABILITY,  INCLUDING CONSEQUENTIAL AND INCIDENTAL
 * DAMAGES  FOR ERRORS, OMISSIONS, AND  OTHER  PROBLEMS IN THE  CODE.
 *
 * Use, duplication,  or disclosure by the U.S. Government is subject
 * to  restrictions  set forth  in FAR 52.227-19 (Commercial Computer
 * Software Restricted Rights) as well as DFAR 252.227-7013(c)(1)(ii)
 * (Rights  in Technical Data and Computer Software),  as applicable.
 *******************************************************************/

#import <UIKit/UIKit.h>
#import "awGridViewCell.h"

//  The awGridView class provides support for displaying a list of items
//  in a grid layout.
//
//  The grid view arranges its items in a grid of rows and columns. awGridView
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
//  A awGridView object must have an object that acts as a data source and an
//  object that acts as a delegate. The data source must adopt the
//  awGridViewDataSource protocol and the delegate must adopt the
//  awGridViewDelegate protocol.
//
//  awGridView only displays visible cells (awGridViewCell). Non-visible cells
//  are cached for reuse.
//
//  The gridView:cellAtIndex delegate method requires you to instantiate and
//  return an awGridViewCell object. For example:
//
//    - (awGridViewCell *)gridView:(awGridView *)gridView cellAtIndex:(NSUInteger)index
//    {
//        static NSString *CellIdentifier = @"GridCell";
//        
//        awGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
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
//  awGridView supports a selection mode where tapping on an item will draw it
//  with a selection view if you provide one on awGridViewCell.

@protocol awGridViewDelegate;
@protocol awGridViewDataSource;

enum awGridViewOrientation
{
    awGridViewOrientationVertical,
    awGridViewOrientationHorizontal
};

@interface awGridView : UIScrollView

//  The size of cell items.
//
@property (nonatomic) CGSize itemSize;

//  The space between cell items.
//
@property (nonatomic) CGFloat itemSpace;

//  A vertical orientation is the default.
//
@property (nonatomic) enum awGridViewOrientation orientation;

//  A Boolean value that determines whether the receiver is in selection mode.
//
//  When this property is YES, the view is in selection mode. While in selection
//  tapping on an unselected cell will select it. Conversely, tapping a selected
//  cell with deselect it.
//
@property (nonatomic) BOOL selecting;

@property (nonatomic, assign) IBOutlet id <awGridViewDelegate> gridViewDelegate;
@property (nonatomic, assign) IBOutlet id <awGridViewDataSource> dataSource;

- (void)reloadData;

- (awGridViewCell *)cellAtIndex:(NSUInteger)index;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

//  While in selection mode call indicesForSelectedCells to return an array
//  identifying the selected cells. Returns nil if there are no selected cells.
//
- (NSArray *)indicesForSelectedCells;

@end

@protocol awGridViewDelegate <NSObject>

@optional

//  Called whenever a cell is tapped, regardless of selecting property value.
//
- (void)gridView:(awGridView *)gridView didSelectCellAtIndex:(NSUInteger)index;

@end

@protocol awGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInGridView:(awGridView *)gridView;
- (awGridViewCell *)gridView:(awGridView *)gridView cellAtIndex:(NSUInteger)index;

@end

