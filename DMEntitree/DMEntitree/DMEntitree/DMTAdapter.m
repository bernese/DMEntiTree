//
//  DMTAdapter.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 11/1/13.
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

#import "DMTAdapter.h"

@interface DMTAdapter()

@property (nonatomic, strong) DMTSelection *currentSelection;
@property (nonatomic, strong) NSMutableArray *leaves;

@end

@implementation DMTAdapter

- (id)init
{
    self = [super init];
    if ( self )
    {
        _leaves = [[NSMutableArray alloc] init];
        _currentSelection = [[DMTSelection alloc] init];
    }
    return self;
}

#pragma - Contextual by Current Selection

- (DMTSelection *)selectedPath
{
    return _currentSelection;
}

- (id<DMTLeafAdapter>)selectedLeafAdapter
{
    return [self selectedLeafAdapterAtTier:[self depth] - 1];
}

//TODO: write
- (id<DMTLeafAdapter>)selectedLeafAdapterAtTier:(NSUInteger)tier
{
    NSArray *actives = [self activeObjectsAtTier:tier];
    NSUInteger selectionAtTier = [[self currentSelection] indexAtTier:tier];
    if ( selectionAtTier < actives.count )
    {
        return [actives objectAtIndex:selectionAtTier];
    }
    else
        return nil;
}

- (id<DMTLeafAdapter>)leafAdapterAtTier:(NSUInteger)tier andPosition:(NSUInteger)position
{
    DMTSelection *selection = [self selectedPath];
    return [self leafAdapterAtTier:tier andPosition:position forSelection:selection];
}

- (NSUInteger)widthOfTier:(NSUInteger)tier
{
    return [self widthOfTier:tier forSelection:[self selectedPath]];
}

- (NSUInteger)depth
{
    return [_currentSelection depth];
}

- (NSArray *)activeObjects
{
    return [self activeObjectsForSelection:[self selectedPath]];
}

- (NSArray *)activeObjectsAtTier:(NSUInteger)tier
{
    return [self activeObjectsAtTier:tier forSelection:[self selectedPath]];
}

- (BOOL)canAddTier:(NSUInteger)proposedSelection //check if the propogated selection at the top tier has objects below it
{
    if ( [self depth] == 0 ) //no selection yet
    {
        NSArray *topLevels = [_dataSource topLevelItems];
        if ( proposedSelection <= topLevels.count )
        {
            return YES;
        }
    }
    else
    {
        id<DMTLeafAdapter> selected = [self selectedLeafAdapter];
        
        NSArray *children = [selected children];
        if ( proposedSelection < children.count )
        {
            id<DMTLeafAdapter> child = [children objectAtIndex:proposedSelection];
            return [child children] > 0;
        }
    }

    return NO;
}

- (NSIndexPath *)positionalIndexPathOfAdapter:(id<DMTLeafAdapter>)leaf;
{
    
    NSUInteger depth = _currentSelection.depth;
    for ( int i = 0; i < depth; i++ )
    {
        NSArray *tierJects  = [self activeObjectsAtTier:i];
        NSInteger indexOfObject = [tierJects indexOfObject:leaf];
        if ( indexOfObject != NSNotFound )
        {
            return [NSIndexPath indexPathForRow:indexOfObject inSection:i];
        }
    }
    
    return [NSIndexPath indexPathWithIndex:0];
}

- (void)selectLeafAdapter:(id<DMTLeafAdapter>)adapter
{
    
}

- (void)selectIndex:(DMTSelection *)selection
{
    _currentSelection = selection;
}

#pragma mark - Contextual by Provided Selecion

- (NSArray *)activeObjectsForSelection:(DMTSelection *)selection
{
    NSArray *topLevel = [_dataSource topLevelItems];
    NSUInteger depth = [selection depth];
    
    NSMutableArray *aggregator = [[NSMutableArray alloc] init];
    
    //zeroth... we always see the first tier
    [aggregator addObjectsFromArray:topLevel];
    
    //the rest
    if (depth > 0)
    {
        id<DMTLeafAdapter> parent = [topLevel objectAtIndex:[[self selectedPath] indexAtTier:0]];
        for ( int i = 1; i < depth; i++ )
        {
            NSArray *children = [parent children];
            [aggregator addObjectsFromArray:children];
            parent = [children objectAtIndex:[[self selectedPath] indexAtTier:i]];
        }
    }
    
    return [NSArray arrayWithArray:aggregator];
}

- (NSArray *)activeObjectsAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection
{
    NSArray *topLevel = [_dataSource topLevelItems];
    NSUInteger depth = [selection depth];
    if ( depth == 0 || tier == 0 )
    {
        return topLevel;
    }
    else if (depth > 0 && tier > 0 && tier <= depth)
    {
        id<DMTLeafAdapter> parent = [topLevel objectAtIndex:[[self selectedPath] indexAtTier:0]];
        for ( int i = 1; i < tier; i++ )
        {
            NSArray *children = [parent children];
            parent = [children objectAtIndex:[[self selectedPath] indexAtTier:i]];
            
        }
        return [parent children];
    }
    else
        return [NSArray array];
}

- (NSUInteger)widthOfTier:(NSUInteger)tier forSelection:(DMTSelection *)selection
{
    NSArray *tierObjects = [self activeObjectsAtTier:tier forSelection:selection];
    return tierObjects.count;
}

- (id<DMTLeafAdapter>)leafAdapterAtTier:(NSUInteger)tier andPosition:(NSUInteger)position forSelection:(DMTSelection *)selection
{
    NSArray *objectsAtTier = [self activeObjectsAtTier:tier forSelection:selection];
    if ( objectsAtTier.count > position )
    {
        return [objectsAtTier objectAtIndex:position];
    }
    else
    {
        NSLog(@"ERROR: DMTAdapter: leafAdapterAtTier:andPosition:forSelection: position requested (%i) is greater than tier width (%i) ", position, objectsAtTier.count);
        return nil;
    }
}

- (void)setDataSource:(id<DMTAdapterDataSource>)dataSource
{
    [_leaves addObjectsFromArray:[dataSource topLevelItems]];
    _dataSource = dataSource;
}

#pragma mark - Interact

- (void)selectObjectAtPositionalIndex:(NSIndexPath *)pIndex;
{
    NSUInteger currentDepth = [_currentSelection depth];
    if ( pIndex.section == currentDepth )
    {
        [_currentSelection addTier:pIndex.row];
    }
    else if ( pIndex.section < currentDepth )
    {
        NSUInteger selectionAtTier = [_currentSelection indexAtTier:pIndex.section];
        if ( selectionAtTier == pIndex.row )
        {
            while ( [_currentSelection depth] > pIndex.section ) {
                [_currentSelection stripTopTier];
            }
            
        }
        else
        {
            [_currentSelection dropToTier:pIndex.section selection:pIndex.row];
        }
    }
}

@end
