//
//  DMTreeViewLayout.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 11/4/13.
/*
 Copyright (c) 2014 Dana Maher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/
//

#import "DMTreeViewLayout.h"
#import "DMTBranch.h"
#import "DMTLeaf.h"
#import "DMTConfigPanel.h"
#import "DMTStylePackage.h"

#define span_defaultInterCell 44.0
#define width_defaultCell 180.0
#define height_defaultCell 180.0

@interface DMTreeViewLayout()

@property (nonatomic) CGSize cellSize;
@property (nonatomic) CGFloat cellSeparation;
@property (nonatomic, strong) DMTAdapter *adapter;

@property (nonatomic, strong) NSArray *activeObjectIndexes;
@property (nonatomic, strong) NSArray *connectorIndexes;
@property (nonatomic, strong) NSArray *configPanelIndexes;

- (CGFloat)rowWidthInsetAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection;
- (NSUInteger)rowCountInsetAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection;
- (CGFloat)xOffsetForCellAtPath:(NSIndexPath *)indexPath;
- (CGRect)frameForCellAtPath:(NSIndexPath *)indexPath; //here we mean the simple index path of the grid of visible cells, not the compound index path of a selection.
- (CGRect)frameForConnectorAtPath:(NSIndexPath *)indexPath;
- (CGRect)frameForConfigAtPath:(NSIndexPath *)indexPath;

@end

@implementation DMTreeViewLayout

- (CGFloat)rowWidthInsetAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection
{
    /*
     CGFloat rowInset = 0.0;
     if ( tier < selection.depth && tier >= 1 )
     {
     NSUInteger oneUpPos = [selection indexAtTier:tier - 1] + 1;
     NSUInteger thisRowWidth = [_adapter widthOfTier:tier];
     NSInteger differential = oneUpPos - thisRowWidth;
     if ( differential > 0 )
     {
     rowInset = differential*_cellSeparation + differential*_cellSize.width;
     }
     }
     
     return rowInset;
     */
    
    CGFloat rowWidthInset = 0.0;
    NSUInteger rowCountInset = [self rowCountInsetAtTier:tier forSelection:selection];
    rowWidthInset = rowCountInset * _cellSeparation + rowCountInset* _cellSize.width;
    return rowWidthInset;
}

- (NSUInteger)rowCountInsetAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection
{
    NSUInteger rowInset = 0;
    if ( tier <= selection.depth && tier >= 1 )
    {
        NSUInteger oneUpPos = [selection indexAtTier:tier - 1] + 1;
        NSUInteger thisRowWidth = [_adapter widthOfTier:tier];
        NSInteger differential = oneUpPos - thisRowWidth;
        if ( differential > 0 )
        {
            rowInset = differential;
        }
    }
    
    return rowInset;
}

- (CGFloat)xOffsetForCellAtPath:(NSIndexPath *)indexPath
{
    NSUInteger xNum = indexPath.row;
    CGFloat rowInset = [self rowWidthInsetAtTier:indexPath.section forSelection:[_adapter selectedPath]];
    CGFloat xOffset = (xNum + 1)*_cellSeparation + xNum*_cellSize.width;
    return xOffset + rowInset;
}

- (CGRect)frameForCellAtPath:(NSIndexPath *)indexPath //here we mean the simple index path of the grid of visible cells, not the compound index path of a selection.
{
    NSUInteger yNum = indexPath.section;
    CGFloat yOffset = (yNum + 1)*_cellSeparation + yNum*_cellSize.height;
    
    CGFloat baseXOffset = 2 * span_defaultInterCell;
    CGFloat xOffset = baseXOffset + [self xOffsetForCellAtPath:indexPath];
    
    //NSLog(@"returning cell frame : %f/%f %f/%f", xOffset, yOffset, _cellSize.width, _cellSize.height);
    return CGRectMake(xOffset, yOffset, _cellSize.width, _cellSize.height);
}

- (CGRect)frameForConnectorAtPath:(NSIndexPath *)indexPath
{
    NSUInteger yNum = indexPath.section;
    CGFloat yOffset = yNum * ( _cellSize.height + _cellSeparation );
    
    NSUInteger xNum = indexPath.row;
    //CGFloat xOffset = (xNum )*_cellSeparation*.50 + (xNum -1)*_cellSize.width;
    CGFloat rowInset = [self rowWidthInsetAtTier:indexPath.section forSelection:[_adapter selectedPath]];
    CGFloat baseXOffset = 2 * span_defaultInterCell;
    CGFloat xOffset = baseXOffset + .5*_cellSeparation + xNum * (_cellSize.width + _cellSeparation);
    xOffset = xOffset + rowInset;
    
    //NSLog(@"calcing connector rect %f/%f and %f/%f", xOffset, yOffset, _cellSize.width, _cellSeparation);
    return CGRectMake(xOffset, yOffset, _cellSize.width + _cellSeparation, _cellSeparation);
}

- (CGRect)frameForConfigAtPath:(NSIndexPath *)indexPath
{
    NSUInteger yNum = indexPath.section;
    CGFloat yOffset = (yNum + 1)*_cellSeparation + yNum*_cellSize.height;
    
    return CGRectMake(span_defaultInterCell, yOffset, dim_cPanelWidth, _cellSize.height);
}

#pragma mark - Public

- (BOOL)isUnderneathUpstreamSelection:(NSIndexPath *)indexPath
{
    if ( indexPath.section > 0 )
    {
        NSUInteger upstreamPosition = [[_adapter selectedPath] indexAtTier:indexPath.section - 1];
        NSUInteger offsetPosition = [self rowCountInsetAtTier:indexPath.section forSelection:[_adapter selectedPath]] + indexPath.row;
        if ( upstreamPosition == offsetPosition )
        {
            return YES;
        }
    }
    
    return NO;
}

- (id)initWithAdapter:(DMTAdapter *)adapter
{
    self = [super init];
    if ( self )
    {
        _adapter = adapter;
        
        _cellSize = CGSizeMake(180.0, 180.0);
        _cellSeparation = span_defaultInterCell;
        
        self.headerReferenceSize = [DMTStylePackage headerSize];
        self.footerReferenceSize = [DMTStylePackage branchSize];
        
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
    NSMutableArray *aggregator = [[NSMutableArray alloc] init];
    NSMutableArray *connectorAggregator = [[NSMutableArray alloc] init];
    NSMutableArray *configPanelAggregator = [[NSMutableArray alloc] init];
    
    NSUInteger depth = [_adapter depth] + 1;
    //NSLog(@"depth : %i", depth);
    for ( int i = 0; i < depth; i++ )
    {
        NSMutableArray *tierAggregator = [[NSMutableArray alloc] init];
        NSMutableArray *connectorTierAggregator = [[NSMutableArray alloc] init];
        
        //lay out config panel
        NSIndexPath *configPath = [NSIndexPath indexPathForRow:0 inSection:i];
        UICollectionViewLayoutAttributes *config = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:configPath];
        [config setFrame:[self frameForConfigAtPath:configPath]];
        [configPanelAggregator addObject:config];
        
        //lay out cells and connectors
        NSUInteger widthThisLevel = [_adapter widthOfTier:i];
        //NSLog(@"at tier %i, width %i", i, widthThisLevel);
        for ( int j = 0; j < widthThisLevel; j++ )
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
            
            //cell layout
            UICollectionViewLayoutAttributes *lAtts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
            [lAtts setFrame:[self frameForCellAtPath:path]];
            //NSLog(@"for path %i/%i, calculated cell frame: x:%f y:%f w:%f h:%f", path.section, path.row, lAtts.frame.origin.x, lAtts.frame.origin.y, lAtts.frame.size.width, lAtts.frame.size.height);
            
            [tierAggregator addObject:lAtts];
            
            //connector layout
            UICollectionViewLayoutAttributes *connectorLayout = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:path];
            [connectorLayout setFrame:[self frameForConnectorAtPath:path]];
            //NSLog(@"for path %i/%i, calculated connector frame: x:%f y:%f w:%f h:%f", path.section, path.row, connectorLayout.frame.origin.x, connectorLayout.frame.origin.y, connectorLayout.frame.size.width, connectorLayout.frame.size.height );
            
            [connectorTierAggregator addObject:connectorLayout];
        }
        
        [aggregator addObject:tierAggregator];
        [connectorAggregator addObject:connectorTierAggregator];
    }
    
    _activeObjectIndexes = [NSArray arrayWithArray:aggregator];
    _connectorIndexes = [NSArray arrayWithArray:connectorAggregator];
    _configPanelIndexes = [NSArray arrayWithArray:configPanelAggregator];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(1200, 1200);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *agg = [[NSMutableArray alloc] init];
    for (NSArray *tier in _activeObjectIndexes)
    {
        [agg addObjectsFromArray:tier];
    }
    
    for (NSArray *connectorTier in _connectorIndexes)
    {
        [agg addObjectsFromArray:connectorTier];
    }
    
    [agg addObjectsFromArray:_configPanelIndexes];
    
    return agg;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *objectsThisTier = [_activeObjectIndexes objectAtIndex:indexPath.section];
    
    return [objectsThisTier objectAtIndex:indexPath.row];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"elements for view of kind %@ at path %i / %i", kind, indexPath.row, indexPath.section);
    
    NSArray *objectsThisTier = [_connectorIndexes objectAtIndex:indexPath.section];
    
    
    return [objectsThisTier objectAtIndex:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [DMTStylePackage branchSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [DMTStylePackage headerSize];
}


@end
