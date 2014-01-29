//
//  DMTSelection.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 11/6/13.
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

#import "DMTSelection.h"

@interface DMTSelection()

@property (nonatomic, strong) NSIndexPath *iPath;

@end

@implementation DMTSelection

- (id)init
{
    self = [super init];
    if ( self )
    {
        _iPath = [[NSIndexPath alloc] init];
    }
    return self;
}

- (NSUInteger)depth
{
   return _iPath.length;
}

- (NSUInteger)indexAtTier:(NSUInteger)tier
{
    return [_iPath indexAtPosition:tier];
}

- (NSIndexPath *)trail
{
    return _iPath;
}

- (void)addTier:(NSUInteger)selection
{
    _iPath = [_iPath indexPathByAddingIndex:selection];
    NSLog(@"tier added, path is now %@", _iPath);
}

- (void)stripTopTier
{
    _iPath = [_iPath indexPathByRemovingLastIndex];
}

- (void)dropToTier:(NSUInteger)tier selection:(NSUInteger)selection
{
    while ( _iPath.length > tier )
    {
      _iPath = [_iPath indexPathByRemovingLastIndex];
    }
    
    NSLog(@"selection on drop : %i", selection);
    _iPath = [_iPath indexPathByAddingIndex:selection];
}

@end
