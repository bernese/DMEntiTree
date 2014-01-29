//
//  DMTreeView.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 11/3/13.
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

#import "DMTreeView.h"
#import "DMTreeViewLayout.h"
#import "DMTBranch.h"
#import "DMTStylePackage.h"

@interface DMTreeView()

//model
@property (nonatomic, strong) id<DMTAdapterDelegate> delegate;

//controller
@property (nonatomic, strong) DMTAdapter *adapter;
@property (nonatomic, strong) DMTreeViewLayout *layout;

//view
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)buildSelf;
- (BOOL)connectorIsDownpipe:(NSIndexPath *)path;
- (BranchType)branchTypeForConnectorAtPath:(NSIndexPath *)path;

@end

@implementation DMTreeView

- (void)buildSelf
{
    //controllers
    _adapter = [[DMTAdapter alloc] init];
    _layout = [[DMTreeViewLayout alloc] initWithAdapter:_adapter];
    
    //self properties
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    //collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[DMTLeaf class] forCellWithReuseIdentifier:kLeaf_ReuseIdent];
    [_collectionView registerClass:[DMTBranch class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kBranch];
    [_collectionView registerClass:[DMTConfigPanel class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kConfigPanel];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
        
    [self addSubview:_collectionView];
}

- (BOOL)connectorIsDownpipe:(NSIndexPath *)path
{
    return NO;
}

- (BranchType)branchTypeForConnectorAtPath:(NSIndexPath *)path
{
    BranchType bType = Branch_Connector;
    NSUInteger rowWidth = [_adapter widthOfTier:path.section];
    BOOL isDownpipe = [_layout isUnderneathUpstreamSelection:path];
    
    if ( path.row == 0 && !isDownpipe )
    {
        bType = Branch_LeftCap;
    }
    else if (path.row == 0 && isDownpipe )
    {
        bType = Branch_SingleDown_LeftCap;
    }
    else if ( path.row == rowWidth - 1 && !isDownpipe )
    {
        bType = Branch_RightCap;
    }
    else if ( path.row == rowWidth - 1 && isDownpipe )
    {
        bType = Branch_SingleDown_RightCap;
    }
    else if ( isDownpipe )
    {
        bType =Branch_SingleDown;
    }
    
    return bType;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSelf];
    }
    return self;
}

- (void)setDataSource:(id<DMTAdapterDataSource>)dataSource
{
    [_adapter setDataSource:dataSource];
}

- (void)setDelegate:(id<DMTAdapterDelegate>)delegate
{
    _delegate = delegate;
}

- (DMTAdapter *)treeAdapter
{
    return _adapter;
}

- (void)reloadData
{
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = [_adapter widthOfTier:section];
    //NSLog(@"for section %i, number of items: %i", section, itemCount);
    return itemCount;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DMTSelection *selection = [_adapter selectedPath];
    //NSLog(@"DMTreeView: number of sections: %i", [selection depth] + 1);
    return [selection depth] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<DMTLeafAdapter> objectForIndex = [_adapter leafAdapterAtTier:indexPath.section andPosition:indexPath.row];
    
    DMTLeaf *thisLeaf = [collectionView dequeueReusableCellWithReuseIdentifier:kLeaf_ReuseIdent forIndexPath:indexPath];
    [thisLeaf setDrawingIndex:indexPath];
    [thisLeaf setBacker:objectForIndex];
    [thisLeaf updateSelf];
    [thisLeaf setDel:self];
    //thisLeaf.frame = CGRectMake(thisLeaf.frame.origin.x, thisLeaf.frame.origin.y, 120.0, 120.0);
    
    //NSLog(@"leaf frame : %f/%f %f/%f", thisLeaf.frame.origin.x, thisLeaf.frame.origin.y, thisLeaf.frame.size.width, thisLeaf.frame.size.height);
    
    return thisLeaf;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ( kind == UICollectionElementKindSectionFooter) {
        
        DMTBranch *thisBranch = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kBranch forIndexPath:indexPath];
        thisBranch.branchType = [self branchTypeForConnectorAtPath:indexPath];
        [thisBranch refresh];
        
        return thisBranch;
        
    }
    else if ( kind == UICollectionElementKindSectionHeader )
    {
        DMTConfigPanel *thisPanel = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kConfigPanel forIndexPath:indexPath];
        [thisPanel setTier:indexPath.section];
        [thisPanel setDelegate:self];
        return thisPanel;
    }
    else
        return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //get prior attributes
    NSUInteger depthBefore = [_adapter depth];
    
    //can we select?
    BOOL canSelect = YES;
    if ( indexPath.section == depthBefore && ![_adapter canAddTier:indexPath.row] )
    {
        canSelect = NO;
    }
    
    //drive selection if allowed
    if ( canSelect )
    {
        [_adapter selectObjectAtPositionalIndex:indexPath];
        [_delegate adapter:_adapter selectItemAtPath:indexPath depth:[_adapter depth]];
        
        //get post attributes
        NSUInteger depthAfter = [_adapter depth];
        //NSLog(@"depth before: %i / depth after: %i", depthBefore, depthAfter);
        
        [collectionView reloadData];
        
        /*
         if ( depthBefore == depthAfter )
         {
         [collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(depthBefore - 1, 1)]];
         
         }
         else
         {
         [collectionView reloadData];
         }
         
         
         [collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
         */
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [DMTStylePackage branchSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [DMTStylePackage headerSize];
}

#pragma mark - DMTConfigPanelDel

- (void)addButtonPressedAtTier:(NSUInteger)tier
{
    [_delegate adapter:_adapter addItemToTier:tier ofSelection:[_adapter selectedPath]];
}

- (void)filterButtonPressedAtTier:(NSUInteger)tier
{
    
    [_delegate adapter:_adapter filterTier:tier];
}

#pragma mark - DMTLeafAdapterDel

- (void)strikeDisclosure:(NSIndexPath *)leafIndex
{
    NSLog(@"disclose");
    [_delegate adapter:_adapter hitDisclosureButtonForItemAtPath:leafIndex];
}


@end
