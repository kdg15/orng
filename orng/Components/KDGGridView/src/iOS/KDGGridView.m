//
//  KDGGridView.m
//  orng
//
//  Created by Brian Kramer on 12.09.14.
//  Copyright (c) 2014 mitchkram. All rights reserved.
//

#import "KDGGridView.h"

#pragma mark - Private Interface

@interface KDGGridView ()

@property (nonatomic) NSInteger  numberOfRows;
@property (nonatomic) NSInteger  numberOfColumns;
@property (nonatomic) CGFloat    extraSpace;
@property (nonatomic) CGRect     previousFrame;
@property (nonatomic) NSRange    visibleCellRange;
@property (nonatomic) NSUInteger touchedIndex;
@property (nonatomic) BOOL       haveTouchedIndex;

@property (nonatomic, retain) NSMutableDictionary *visibleCells;
@property (nonatomic, retain) NSMutableArray      *reuseQueue;
@property (nonatomic, retain) NSMutableArray      *selectedIndices;

- (NSInteger)_numberOfItems;
- (void)_configureLayout;
- (void)_repositionCells;
- (CGRect)_getCellRect:(NSInteger)index;
- (void)_updateCellVisibility:(BOOL)reloadData;

- (void)_showCell:(NSInteger)index;
- (void)_hideCell:(NSInteger)index;
- (void)_updateCell:(NSInteger)index;

- (void)_showCellsInRange:(NSRange)range;
- (void)_hideCellsInRange:(NSRange)range;
- (void)_updateCellsInRange:(NSRange)range;

- (NSInteger)_endLocationInRange:(NSRange)range;

- (void)_resetTouchedIndex;

- (void)_addSelectedViewToCell:(KDGGridViewCell *)cell;
- (void)_removeSelectedViewFromCell:(KDGGridViewCell *)cell;

@end

#pragma mark - Implementation

@implementation KDGGridView

@synthesize itemSize=_itemSize;
@synthesize itemSpace=_itemSpace;
@synthesize orientation=_orientation;
@synthesize selecting=_selecting;
@synthesize gridViewDelegate;
@synthesize dataSource;

@synthesize numberOfRows;
@synthesize numberOfColumns;
@synthesize extraSpace;
@synthesize previousFrame;
@synthesize visibleCellRange;
@synthesize touchedIndex=_touchedIndex;
@synthesize haveTouchedIndex=_haveTouchedIndex;

@synthesize visibleCells=_visibleCells;
@synthesize reuseQueue=_reuseQueue;
@synthesize selectedIndices=_selectedIndices;

#pragma mark - Memory Management

#if !__has_feature(objc_arc)

- (void)dealloc
{
    NSArray *cells = [_visibleCells allValues];
    for (UIView *cell in cells) [cell removeFromSuperview];
    [_visibleCells removeAllObjects];
    [_visibleCells release];
    [_reuseQueue removeAllObjects];
    [_reuseQueue release];
    [_selectedIndices removeAllObjects];
    [_selectedIndices release];

    [super dealloc];
}

#endif

#pragma mark - Initialization

- (void)initialize
{
    self.itemSize = CGSizeMake(64.0f, 64.0f);
    self.itemSpace = 18.0f;
    self.orientation = KDGGridViewOrientationVertical;
    self.selecting = NO;

    self.visibleCellRange = NSMakeRange(0, 0);

    self.previousFrame = CGRectMake(0, 0, 0, 0);

    [self _resetTouchedIndex];

    self.visibleCells = [[NSMutableDictionary alloc] init];
    self.reuseQueue = [[NSMutableArray alloc] init];

    self.clipsToBounds = YES;

    self.selectedIndices = [NSMutableArray arrayWithCapacity:0];

    [self _configureLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self initialize];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        [self initialize];        
    }

    return self;
}

#pragma mark - Configuring a Grid View

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self _configureLayout];
}

- (void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    [self _configureLayout];
}

- (void)setOrientation:(enum KDGGridViewOrientation)orientation
{
    _orientation = orientation;
    [self _configureLayout];
    [self _repositionCells];
    [self _updateCellVisibility:NO];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    if (self.hidden)
    {
        return;
    }

    if (CGRectEqualToRect(self.frame, self.previousFrame))
    {
        [self _updateCellVisibility:NO];
    }
    else
    {
        [self _configureLayout];
        [self _repositionCells];
        [self _updateCellVisibility:NO];
        self.previousFrame = self.frame;
    }

    [super layoutSubviews];
}

- (NSInteger)_numberOfItems
{
    return [self.dataSource numberOfItemsInGridView:self];
}

- (void)_configureLayout
{
    NSInteger itemCount = [self _numberOfItems];
    CGSize size = self.bounds.size;

    if (self.orientation == KDGGridViewOrientationVertical)
    {        
        self.numberOfColumns = (size.width - self.itemSpace) / (self.itemSize.width + self.itemSpace);
        self.extraSpace = size.width - self.itemSpace - self.numberOfColumns * (self.itemSize.width + self.itemSpace);

        if (itemCount == 0)
        {
            self.numberOfRows = 0;
            self.contentSize = size;
            [self setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
        }
        else
        {
            self.numberOfRows = ceilf((CGFloat) itemCount / self.numberOfColumns);
            NSAssert(self.numberOfRows > 0, @"Not enough space for a single column!");

            CGFloat contentHeight = self.itemSpace + self.numberOfRows * (self.itemSize.height + self.itemSpace);
            
            //  Content height can't be less that the view's height.
            //
            if (contentHeight < size.height) contentHeight = size.height;
            
            CGSize contentSize = CGSizeMake(size.width, contentHeight);
            self.contentSize = contentSize;
            
            //  Adjust the content offset if necessary.
            //
            if (self.contentOffset.y + size.height > self.contentSize.height)
            {
                [self setContentOffset:CGPointMake(0.0, self.contentSize.height - size.height) animated:NO];
            }
        }
    }
    else
    {
        self.numberOfRows = (size.height - self.itemSpace) / (self.itemSize.height + self.itemSpace);
        self.extraSpace = size.height - self.itemSpace - self.numberOfRows * (self.itemSize.height + self.itemSpace);

        if (itemCount == 0)
        {
            self.numberOfColumns = 0;
            self.contentSize = size;
            [self setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
        }
        else
        {
            self.numberOfColumns = ceilf((CGFloat) itemCount / self.numberOfRows);
            NSAssert(self.numberOfColumns > 0, @"Not enough space for a single row!");

            CGFloat contentWidth = self.itemSpace + self.numberOfColumns * (self.itemSize.width + self.itemSpace);
            
            //  Content width can't be less that the view's width.
            //
            if (contentWidth < size.width) contentWidth = size.width;
            
            CGSize contentSize = CGSizeMake(contentWidth, size.height);
            self.contentSize = contentSize;
            
            //  Adjust the content offset if necessary.
            //
            if (self.contentOffset.x + size.width > self.contentSize.width)
            {
                [self setContentOffset:CGPointMake(self.contentSize.width - size.width, 0.0) animated:NO];
            }
        }
    }
}

- (void)_repositionCells
{
    [self.visibleCells enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, KDGGridViewCell *cell, BOOL *stop) {
        CGRect cellRect = [self _getCellRect:[key integerValue]];
        cell.frame = cellRect;
    }];
}

- (CGRect)_getCellRect:(NSInteger)index
{
    CGRect rect;

    if (self.orientation == KDGGridViewOrientationVertical)
    {
        NSInteger row = index / self.numberOfColumns;
        NSInteger column = index % self.numberOfColumns;
        
        CGFloat x = self.extraSpace / 2.0 + self.itemSpace + column * (self.itemSize.width + self.itemSpace);
        CGFloat y = self.itemSpace + row * (self.itemSize.height + self.itemSpace);
        
        rect = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    }
    else
    {
        NSInteger column = index / self.numberOfRows;
        NSInteger row = index % self.numberOfRows;
        
        CGFloat y = self.extraSpace / 2.0 + self.itemSpace + row * (self.itemSize.height + self.itemSpace);
        CGFloat x = self.itemSpace + column * (self.itemSize.width + self.itemSpace);
        
        rect = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    }
    
    return rect;
}

- (void)_showCell:(NSInteger)index
{
    KDGGridViewCell *cell = [self.dataSource gridView:self cellAtIndex:index];
    NSAssert(cell != nil, @"### ASSERT: dataSource must return a cell!");
    cell.frame = [self _getCellRect:index];
    [self addSubview:cell];
    
    if (self.selecting && self.selectedIndices.count > 0)
    {
        NSNumber *cellIndex = [NSNumber numberWithInteger:index];
        if ([self.selectedIndices containsObject:cellIndex])
        {
            [self _addSelectedViewToCell:cell];
        }
    }

    [self.visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
}

- (void)_hideCell:(NSInteger)index
{
    NSNumber *key = [NSNumber numberWithUnsignedInteger:index];
    KDGGridViewCell *cell = [self.visibleCells objectForKey:key];
    if (cell)
    {
        if (self.selecting)
        {
            [self _removeSelectedViewFromCell:cell];
        }

        if (cell.reuseIdentifier)
        {
            [self.reuseQueue addObject:cell];
        }
        else
        {
            //  Hiding cell that does not have reuse identifier. Don't add it
            //  to the reuse queue.
        }
        [self.visibleCells removeObjectForKey:key];
        [cell removeFromSuperview];
    }
}

- (void)_updateCell:(NSInteger)index
{
    [self _hideCell:index];
    [self _showCell:index];
}

- (void)_showCellsInRange:(NSRange)range
{
    if (range.length == 0) return;

    for (NSInteger location = range.location;
         location <= [self _endLocationInRange:range];
         location++)
    {
        [self _showCell:location];
    }
}

- (void)_hideCellsInRange:(NSRange)range
{
    if (range.length == 0) return;
    
    for (NSInteger location = range.location;
         location <= [self _endLocationInRange:range];
         location++)
    {
        [self _hideCell:location];
    }
}

- (void)_updateCellsInRange:(NSRange)range
{
    if (range.length == 0) return;
    
    for (NSInteger location = range.location;
         location <= [self _endLocationInRange:range];
         location++)
    {
        [self _updateCell:location];
    }
}

- (NSInteger)_endLocationInRange:(NSRange)range
{
    NSInteger endLocation = range.location;
    if (range.length > 1) endLocation += range.length - 1;
    return endLocation;
}

- (void)_updateCellVisibility:(BOOL)reloadData
{
    NSInteger itemCount = [self _numberOfItems];
    
    //  Determine index of first visible cell.
    //
    NSInteger startIndex = 0, endIndex = 0;
    NSRange newVisibleCellRange = NSMakeRange(0, 0);

    if (self.orientation == KDGGridViewOrientationVertical)
    {
        CGRect visibleRect = CGRectMake(0,
                                        self.contentOffset.y,
                                        self.bounds.size.width,
                                        self.bounds.size.height);
        
        if (itemCount > 0)
        {
            NSInteger firstRow = self.contentOffset.y / (self.itemSize.height + self.itemSpace);
            
            NSInteger lastRow = (self.contentOffset.y + visibleRect.size.height) / (self.itemSize.height + self.itemSpace);
            
            CGFloat y = self.itemSpace + lastRow * (self.itemSize.height + self.itemSpace);
            
            //  Adjust for item space before last row...
            //
            if (self.contentOffset.y + visibleRect.size.height <= y)
            {
                lastRow--;
            }
            
            //  Note that the user can scroll beyond the actual visible rows of cells.
            //  We could get negative rows or row numbers beyond the actual number
            //  of rows.
            //
            if (firstRow < 0) firstRow = 0;
            if (lastRow >= self.numberOfRows) lastRow = self.numberOfRows - 1;
            NSInteger numberOfVisibleRows;
            if (lastRow >= firstRow)
            {
                numberOfVisibleRows = lastRow - firstRow + 1;
            }
            else
            {
                numberOfVisibleRows = 0;
            }
            
            if (numberOfVisibleRows > 0)
            {
                startIndex = firstRow * self.numberOfColumns;
                endIndex = startIndex + self.numberOfColumns * numberOfVisibleRows - 1;
                if (endIndex >= itemCount - 1) endIndex = itemCount - 1;
                newVisibleCellRange.location = startIndex;
                newVisibleCellRange.length = endIndex - startIndex + 1;
            }
        }
    }
    else
    {
        CGRect visibleRect = CGRectMake(self.contentOffset.x,
                                        0,
                                        self.bounds.size.width,
                                        self.bounds.size.height);
        
        if (itemCount > 0)
        {
            NSInteger firstColumn = self.contentOffset.x / (self.itemSize.width + self.itemSpace);
            
            NSInteger lastColumn = (self.contentOffset.x + visibleRect.size.width) / (self.itemSize.width + self.itemSpace);
            
            CGFloat x = self.itemSpace + lastColumn * (self.itemSize.width + self.itemSpace);
            
            //  Adjust for item space before last column...
            //
            if (self.contentOffset.x + visibleRect.size.width <= x)
            {
                lastColumn--;
            }
            
            //  Note that the user can scroll beyond the actual visible columns of cells.
            //  We could get negative columns or columns numbers beyond the actual number
            //  of columns.
            //
            if (firstColumn < 0) firstColumn = 0;
            if (lastColumn >= self.numberOfColumns) lastColumn = self.numberOfColumns - 1;
            NSInteger numberOfVisibleColumns;
            if (lastColumn >= firstColumn)
            {
                numberOfVisibleColumns = lastColumn - firstColumn + 1;
            }
            else
            {
                numberOfVisibleColumns = 0;
            }
            
            if (numberOfVisibleColumns > 0)
            {
                startIndex = firstColumn * self.numberOfRows;
                endIndex = startIndex + self.numberOfRows * numberOfVisibleColumns - 1;
                if (endIndex >= itemCount - 1) endIndex = itemCount - 1;
                newVisibleCellRange.location = startIndex;
                newVisibleCellRange.length = endIndex - startIndex + 1;
            }
        }
    }


    if (newVisibleCellRange.length > 0)
    {
        if (!NSEqualRanges(self.visibleCellRange, newVisibleCellRange))
        {
        }
    }
    else
    {
    }

    if (self.visibleCellRange.length == 0)
    {
        if (newVisibleCellRange.length == 0)
        {
            //  Nothing to hide. Nothing to show.
        }
        else
        {
            //  Nothing to hide. Show new cells.
            //
            [self _showCellsInRange:newVisibleCellRange];
        }
    }
    else
    {
        if (newVisibleCellRange.length == 0)
        {
            //  Hide old cells. Nothing to show.
            //
            [self _hideCellsInRange:self.visibleCellRange];
        }
        else
        {
            if (NSEqualRanges(self.visibleCellRange, newVisibleCellRange))
            {
                //  No change in visible cells. Nothing to hide. Nothing to show.
                //  However, if the data was reloaded then the cell must be updated.
                //
                if (reloadData)
                {
                    [self _updateCellsInRange:self.visibleCellRange];
                }
            }
            else
            {
                NSRange intersection = NSIntersectionRange(self.visibleCellRange, newVisibleCellRange);
                
                if (intersection.length > 0)
                {
                    NSRange unionRange = NSUnionRange(self.visibleCellRange, newVisibleCellRange);
                    
                    for (NSInteger location = unionRange.location;
                         location <= [self _endLocationInRange:unionRange];
                         location++)
                    {
                        if (NSLocationInRange(location, intersection))
                        {
                            //  Nothing to do. This cell is was visible and is
                            //  still visible. However, if the data was reloaded
                            //  the cell must be updated.
                            //
                            if (reloadData)
                            {
                                [self _updateCell:location];
                            }
                        }
                        else
                        {
                            if (NSLocationInRange(location, newVisibleCellRange))
                            {
                                //  Cell is now visible.
                                //
                                [self _showCell:location];
                                
                            }
                            else
                            {
                                //  Cell is no longer visible.
                                //
                                [self _hideCell:location];
                            }
                        }
                    }
                }
                else
                {
                    //  No intersection between old visible cells and new visible cells.
                    //  Hide all the old cells and show all the new ones.
                    //
                    [self _hideCellsInRange:self.visibleCellRange];
                    [self _showCellsInRange:newVisibleCellRange];
                }

            }
        }
    }
    self.visibleCellRange = newVisibleCellRange;
}

#pragma mark - Public Interface

- (void)reloadData
{
    [self _configureLayout];
    if (!self.hidden) [self _updateCellVisibility:YES];
}

- (KDGGridViewCell *)cellAtIndex:(NSUInteger)index
{
    KDGGridViewCell *cell = nil;

    if (NSLocationInRange(index, self.visibleCellRange))
    {
        NSNumber *key = [NSNumber numberWithUnsignedInteger:index];
        cell = [self.visibleCells objectForKey:key];
    }

    return cell;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    //  TODO: Will need a queue for each identifier. Currently assuming only
    //  only cell identifier.
    //
    KDGGridViewCell *cell = [self.reuseQueue lastObject];
    if (cell)
    {
#if !__has_feature(objc_arc)
        [cell retain];
#endif
        [self.reuseQueue removeLastObject];
    }
#if __has_feature(objc_arc)
    return cell;
#else
    return [cell autorelease];
#endif
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden)
    {
        [self setNeedsLayout];
    }
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self _resetTouchedIndex];

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    if (self.orientation == KDGGridViewOrientationVertical)
    {
        NSUInteger row = touchPoint.y / (self.itemSize.height + self.itemSpace);
        NSUInteger column = (touchPoint.x - self.extraSpace / 2.0) / (self.itemSize.width + self.itemSpace);

        if (row < self.numberOfRows && column < self.numberOfColumns)
        {
            CGFloat x = column * (self.itemSize.width + self.itemSpace) + self.itemSpace + self.extraSpace / 2.0;
            CGFloat y = row * (self.itemSize.height + self.itemSpace) + self.itemSpace;
            CGRect cellRect = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
            if (CGRectContainsPoint(cellRect, touchPoint))
            {
                NSUInteger index = row * self.numberOfColumns + column;
                if (index < [self _numberOfItems])
                {
                    [self setTouchedIndex:index];
                }
            }
        }
    }
    else
    {
        NSUInteger column = touchPoint.x / (self.itemSize.width + self.itemSpace);
        NSUInteger row = (touchPoint.y - self.extraSpace / 2.0) / (self.itemSize.height + self.itemSpace);
        
        if (column < self.numberOfColumns && row < self.numberOfRows)
        {
            CGFloat y = row * (self.itemSize.height + self.itemSpace) + self.itemSpace + self.extraSpace / 2.0;
            CGFloat x = column * (self.itemSize.width + self.itemSpace) + self.itemSpace;
            CGRect cellRect = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
            if (CGRectContainsPoint(cellRect, touchPoint))
            {
                NSUInteger index = column * self.numberOfRows + row;
                if (index < [self _numberOfItems])
                {
                    [self setTouchedIndex:index];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self _resetTouchedIndex];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    if (self.haveTouchedIndex)
    {
        if (self.selecting)
        {
            NSNumber *cellIndex = [NSNumber numberWithUnsignedInteger:self.touchedIndex];
            KDGGridViewCell *cell = [self.visibleCells objectForKey:cellIndex];

            NSUInteger index = [self.selectedIndices indexOfObject:cellIndex];

            if (NSNotFound == index)
            {
                [self.selectedIndices addObject:cellIndex];
                [self _addSelectedViewToCell:cell];
            }
            else
            {
                [self.selectedIndices removeObjectAtIndex:index];
                [self _removeSelectedViewFromCell:cell];
            }
        }

        if ([self.gridViewDelegate respondsToSelector:@selector(gridView:didSelectCellAtIndex:)])
        {
            [self.gridViewDelegate gridView:self didSelectCellAtIndex:self.touchedIndex];
        }

        [self _resetTouchedIndex];
    }
}

#pragma mark - Selection

- (void)setSelecting:(BOOL)selecting
{
    if (selecting != _selecting)
    {
        _selecting = selecting;
        
        if (!_selecting)
        {
            //  Remove selection indicator from visible cells.
            //  Clear selection.
            //
            for (NSNumber *cellIndex in self.selectedIndices)
            {
                KDGGridViewCell *cell = [self.visibleCells objectForKey:cellIndex];
                [self _removeSelectedViewFromCell:cell];
            }
            [self.selectedIndices removeAllObjects];
        }
    }
}

- (NSArray *)indicesForSelectedCells
{
    return self.selectedIndices;
}

- (void)setTouchedIndex:(NSUInteger)touchedIndex
{
    _touchedIndex = touchedIndex;
    self.haveTouchedIndex = YES;
}

- (void)_resetTouchedIndex
{
    self.haveTouchedIndex = NO;
}

- (void)_addSelectedViewToCell:(KDGGridViewCell *)cell
{
    if (cell)
    {
        UIView *selectedView = cell.selectedView;
        if (selectedView)
        {
            [cell addSubview:selectedView];
        }
    }
}

- (void)_removeSelectedViewFromCell:(KDGGridViewCell *)cell
{
    if (cell)
    {
        UIView *selectedView = cell.selectedView;
        if (selectedView)
        {
            [selectedView removeFromSuperview];
        }
    }
}

@end
