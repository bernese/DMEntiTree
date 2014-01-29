//
//  DMTAdapter.h
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

#import <Foundation/Foundation.h>
#import "DMTLeaf.h"
#import "DMTSelection.h"

@protocol DMTAdapterDataSource;
@protocol DMTAdapterDelegate;

@interface DMTAdapter : NSObject

@property (nonatomic, strong) id<DMTAdapterDataSource> dataSource;
@property (nonatomic, strong) id<DMTAdapterDelegate> delegate;

//query

//all of these methods are contextual by the current selection
- (DMTSelection *)selectedPath;
- (id<DMTLeafAdapter>)selectedLeafAdapter; //at the tip
- (id<DMTLeafAdapter>)selectedLeafAdapterAtTier:(NSUInteger)tier; //pass-through selection
- (id<DMTLeafAdapter>)leafAdapterAtTier:(NSUInteger)tier andPosition:(NSUInteger)position;
- (NSUInteger)depth;
- (NSUInteger)widthOfTier:(NSUInteger)tier;
- (NSArray *)activeObjects;
- (NSArray *)activeObjectsAtTier:(NSUInteger)tier;
- (BOOL)canAddTier:(NSUInteger)proposedSelection; //check if the propogated selection at the top tier has objects below it
- (NSIndexPath *)positionalIndexPathOfAdapter:(id<DMTLeafAdapter>)leaf;
- (void)selectLeafAdapter:(id<DMTLeafAdapter>)adapter;
- (void)selectIndex:(DMTSelection *)selection;

//all of these methods take a selection to determine context
- (NSArray *)activeObjectsForSelection:(DMTSelection *)selection;
- (NSArray *)activeObjectsAtTier:(NSUInteger)tier forSelection:(DMTSelection *)selection;
- (NSUInteger)widthOfTier:(NSUInteger)tier forSelection:(DMTSelection *)selection;
- (id<DMTLeafAdapter>)leafAdapterAtTier:(NSUInteger)tier andPosition:(NSUInteger)position forSelection:(DMTSelection *)selection;

//interact
- (void)selectObjectAtPositionalIndex:(NSIndexPath *)pIndex;

@end

@protocol DMTAdapterDataSource

- (NSArray *)topLevelItems; //array of DMTLeafAdapter implementers
/*
- (DMTLeaf *)adapter:(DMTAdapter *)adapter leafAtIndexPath:(NSIndexPath *)iPath;
- (NSUInteger)adapter:(DMTAdapter *)adapter numberOfTiersForSelectedIndex:(NSIndexPath *)selected;
- (NSUInteger)adapter:(DMTAdapter *)adapter numberOfEntriesInTier:(NSUInteger)tier forSelectedIndex:(NSIndexPath *)selected;
*/

@end


@protocol DMTAdapterDelegate

- (void)adapter:(DMTAdapter *)adapter selectItemAtPath:(NSIndexPath *)selectionPath depth:(NSUInteger)depth;
- (void)adapter:(DMTAdapter *)adapter hitDisclosureButtonForItemAtPath:(NSIndexPath *)path;
- (void)adapter:(DMTAdapter *)adapter filterTier:(NSUInteger)tier;;
- (void)adapter:(DMTAdapter *)adapter addItemToTier:(NSUInteger)tier ofSelection:(DMTSelection *)selection;

@end
