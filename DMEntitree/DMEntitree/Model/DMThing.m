//
//  DMThing.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 10/29/13.
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

#import "DMThing.h"

@implementation DMThing : NSObject 

- (BOOL)canPush
{
    if ( _subThings.count > 0 )
    {
        return YES;
    }
    else
        return NO;
}

- (BOOL)canEdit
{
    return NO;
}

- (BOOL)canDock
{
    return NO;
}

- (NSString *)title
{
    return _thingTitle;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%i children", _subThings.count];
}

- (UIImage *)image
{
    return _image;
}

- (NSArray *)children
{
    return _subThings;
}

- (void)addSubThing:(DMThing *)subThing
{
    NSMutableArray *adder = [[NSMutableArray alloc] initWithArray:_subThings];
    [adder addObject:subThing];
    _subThings = [NSArray arrayWithArray:adder];
}

@end
