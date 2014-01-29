//
//  DMRandomHierarchyGenerator.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 10/30/13.
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

#import "DMRandomHierarchyGenerator.h"
#import "DMThing.h"
#import <stdlib.h>

#define kMinDepth 2
#define kMinWidth 2

@interface DMRandomHierarchyGenerator()

@property (nonatomic, strong) NSArray *topLevelObjects;
@property (nonatomic, strong) NSArray *images;

- (void)selfSetup;
- (UIImage *)randomImageFromImagesArray:(NSArray *)imagesArray;
- (NSString *)nameForPosition:(NSUInteger)position andDepth:(NSUInteger)depth;
- (void)recursivelyPopulateObjects:(NSArray *)lastTier toDepth:(NSUInteger)finalDepth lastDepth:(NSUInteger)lastDepth withMaxWidth:(NSUInteger)maxWidth;
- (DMThing *)randomThingWithChildren:(NSUInteger)tier index:(NSUInteger)index;

@end

@implementation DMRandomHierarchyGenerator

- (void)selfSetup
{
    NSMutableArray *aggregator = [[NSMutableArray alloc] init];
    [aggregator addObject:[UIImage imageNamed:@"tileBeach.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileDesert.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileForest.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileGlacier.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileGlen.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileLava.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileMtn.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileOcean.jpg"]];
    [aggregator addObject:[UIImage imageNamed:@"tileSavannah.jpg"]];

    _images = [NSArray arrayWithArray:aggregator];
}

- (UIImage *)randomImageFromImagesArray:(NSArray *)imagesArray
{
    NSUInteger arraySize = imagesArray.count - 1;
    NSUInteger randomIndex = arc4random_uniform(arraySize);
    return [imagesArray objectAtIndex:randomIndex];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self selfSetup];
    }
    return self;
}

- (NSString *)nameForPosition:(NSUInteger)position andDepth:(NSUInteger)depth
{
    return [NSString stringWithFormat:@"Block: %lu / %lu", (unsigned long)position, (unsigned long)depth];
}

- (void)randomizeWithMaxLevelWidth:(NSUInteger)lWidth maxDepth:(NSUInteger)mDepth
{
    //calculate depth
    if (mDepth < kMinDepth)
    {
        mDepth = kMinDepth;
    }
    if (lWidth < kMinWidth)
    {
        lWidth = kMinWidth;
    }
    
    NSMutableArray *aggregator = [[NSMutableArray alloc] init];
    //create top level
    NSUInteger topLevelWidth = kMinWidth + arc4random() % (lWidth - kMinWidth + 1);
    for ( int i = 0; i < topLevelWidth; i++ )
    {
        NSUInteger thisDepth = kMinDepth + arc4random() % (mDepth - kMinDepth + 1);
        
        DMThing *thing = [[DMThing alloc] init];
        [thing setThingTitle:[self nameForPosition:i andDepth:0]];
        UIImage *thingImage = [self randomImageFromImagesArray:_images];
        [thing setImage:thingImage];
        [aggregator addObject:thing];
        
        [self recursivelyPopulateObjects:aggregator toDepth:thisDepth lastDepth:0 withMaxWidth:lWidth];
    }
    
    //NSLog(@"randomized: %@", aggregator);
    _topLevelObjects = [NSArray arrayWithArray:aggregator];
}

- (void)recursivelyPopulateObjects:(NSArray *)lastTier toDepth:(NSUInteger)finalDepth lastDepth:(NSUInteger)lastDepth withMaxWidth:(NSUInteger)maxWidth;
{
    for ( DMThing *thing in lastTier )
    {
        NSUInteger thisLevelWidth = kMinWidth + arc4random() % (maxWidth - kMinWidth + 1);
        NSMutableArray *aggregator = [[NSMutableArray alloc] init];
        for ( int i = 0; i < thisLevelWidth; i++ )
        {
            DMThing *nextThing = [[DMThing alloc] init];
            nextThing.thingTitle = [self nameForPosition:i andDepth:finalDepth + 1];
            [aggregator addObject:nextThing];
            [nextThing setOwningThing:thing];
        }
        
        //
        [thing setSubThings:aggregator];
        for ( DMThing * thing in aggregator )
        {
            UIImage *thingImage = [self randomImageFromImagesArray:_images];
            [thing setImage:thingImage];
            if ( lastDepth <= finalDepth )
            {
                lastDepth++;
                [self recursivelyPopulateObjects:aggregator toDepth:finalDepth lastDepth:lastDepth withMaxWidth:maxWidth];
            }
        }
    }
}

- (DMThing *)randomThingWithChildren:(NSUInteger)tier index:(NSUInteger)index
{
    DMThing *thing = [[DMThing alloc] init];
    [thing setThingTitle:[self nameForPosition:index andDepth:tier]];
    UIImage *thingImage = [self randomImageFromImagesArray:_images];
    [thing setImage:thingImage];
    
    NSUInteger thisLevelWidth = kMinWidth + arc4random() % (2*kMinWidth - kMinWidth + 1);
    for ( int i = 0; i < thisLevelWidth; i++ )
    {
        DMThing *nextThing = [[DMThing alloc] init];
        nextThing.thingTitle = [self nameForPosition:i andDepth:tier + 1];
        [thing addSubThing:nextThing];
        [nextThing setOwningThing:thing];
    }
    
    return thing;
}

- (NSArray *)topLevels
{
    return _topLevelObjects;
}

- (NSString *)currentRandomizationDescription
{
    NSString *topLevelDesc = [NSString stringWithFormat:@"%lu top level objects", (unsigned long)_topLevelObjects.count];
    return topLevelDesc;
}

- (void)addObjectToSelection:(NSIndexPath *)selection atLevel:(NSUInteger)level
{
    NSLog(@"\n \n \n adding at level %i of selection %@", level, selection );
    NSArray *currentTier = [self topLevels];
    DMThing *thingAtTier;
    for ( int i = 0; i < selection.length; i ++ )
    {
        thingAtTier = [currentTier objectAtIndex:[selection indexAtPosition:0]];
        currentTier = [thingAtTier children];
    }
    
    DMThing *randomizedSubThing = [self randomThingWithChildren:level index:currentTier.count];
    [thingAtTier addSubThing:randomizedSubThing];
}

@end
