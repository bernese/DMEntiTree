//
//  DMTLeaf.m
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

#import "DMTLeaf.h"
#import "DMTStylePackage.h"
#import <QuartzCore/QuartzCore.h>

@interface DMTLeaf()

@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIView *descriptionBacker;
@property (nonatomic, strong) UILabel *description;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *disclosureButton;

- (void)buildSelf;
- (void)hitDisclosure;

@end

@implementation DMTLeaf

- (void)buildSelf
{
    //border
    self.layer.borderColor = [DMTStylePackage outlineColor].CGColor;
    self.layer.borderWidth = [DMTStylePackage outlineWidth];
    self.layer.cornerRadius = [DMTStylePackage outlineWidth];
    
    //image
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_imageView];
    
    //title
    _titleView = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, 44)];
    [_titleView setTextColor:[UIColor whiteColor]];
    [_titleView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
    [_titleView setNumberOfLines:2];
    [_titleView setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_titleView];
    
    //description
    CGFloat descHeight = 50.0;
    
    //backer
    CGFloat backerHeight = descHeight + 10;
    _descriptionBacker = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - backerHeight, self.frame.size.width - 10, backerHeight)];
    _descriptionBacker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [_descriptionBacker setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.50]];
    [self addSubview:_descriptionBacker];
    
    //button
    _disclosureButton = [[UIButton alloc] initWithFrame:CGRectMake( _descriptionBacker.frame.size.width - descHeight - 5, 5, descHeight, descHeight)];
    [_disclosureButton setImage:[UIImage imageNamed:@"icon_discloseDefault.png"] forState:UIControlStateNormal];
    [_disclosureButton setImage:[UIImage imageNamed:@"icon_discloseSelected.png"] forState:UIControlStateHighlighted];
    [_disclosureButton setImage:[UIImage imageNamed:@"icon_discloseSelected.png"] forState:UIControlStateSelected];
    [_disclosureButton addTarget:self action:@selector(hitDisclosure) forControlEvents:UIControlEventTouchUpInside];
    [_descriptionBacker addSubview:_disclosureButton];
    
    //text
    _description = [[UILabel alloc] initWithFrame:CGRectMake(5, (_descriptionBacker.frame.size.height - descHeight)/2, _descriptionBacker.frame.size.width - 15 - descHeight, descHeight)];
    _description.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    //[_description setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.50]];
    [_description setNumberOfLines:4];
    [_description setTextAlignment:NSTextAlignmentLeft];
    [_description setTextColor:[UIColor whiteColor]];
    [_descriptionBacker addSubview:_description];
}

- (void)hitDisclosure
{
    [_del strikeDisclosure:_drawingIndex];
}

- (void)updateSelf
{
    [_titleView setText:[_backer thingTitle]];
    [_description setText:[_backer description]];
    UIImage *theImage = [_backer image];
    if ( theImage )
    {
        [_imageView setImage:theImage];
    }
    else
    {
        [_imageView setImage:nil];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self buildSelf];
    }
    return self;
}

@end
