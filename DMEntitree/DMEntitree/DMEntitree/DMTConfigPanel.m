//
//  DMTConfigPanel.m
//  DMEntitree
//
//  Created by Dana Craig Maher on 1/19/14.
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

#import "DMTConfigPanel.h"
#import "DMTStylePackage.h"

#define dim_buttonSize 44.0

@interface DMTConfigPanel()

@property (nonatomic) id<DMTConfigPanelDel> del;
@property (nonatomic) NSUInteger tier;

@property (nonatomic, strong) UIButton *addItem;
@property (nonatomic, strong) UIButton *searchItems;

- (void)buildSelf;
- (void)triggerAdd;
- (void)triggerFilter;

@end

@implementation DMTConfigPanel

- (void)buildSelf
{
    self.layer.borderColor = [DMTStylePackage outlineColor].CGColor;
    self.layer.borderWidth = [DMTStylePackage outlineWidth];
    
    CGFloat vertSpacing = (self.frame.size.height - 2*dim_buttonSize)/3;
    
    _addItem = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - dim_buttonSize)/2, vertSpacing, dim_buttonSize, dim_buttonSize)];
    [_addItem setImage:[UIImage imageNamed:@"icon_addDefault.png"] forState:UIControlStateNormal];
    [_addItem setImage:[UIImage imageNamed:@"icon_addSelected.png"] forState:UIControlStateHighlighted];
    [_addItem setImage:[UIImage imageNamed:@"icon_addSelected.png"] forState:UIControlStateSelected];
    [_addItem addTarget:self action:@selector(triggerAdd) forControlEvents:UIControlEventTouchUpInside];
    //[_addItem setTitle:@"add" forState:UIControlStateNormal];
    [self addSubview:_addItem];
    
    _searchItems = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - dim_buttonSize)/2, 2*vertSpacing + dim_buttonSize, dim_buttonSize, dim_buttonSize)];
    [_searchItems setImage:[UIImage imageNamed:@"icon_searchDefault.png"] forState:UIControlStateNormal];
    [_searchItems setImage:[UIImage imageNamed:@"icon_searchSelected.png"] forState:UIControlStateHighlighted];
    [_searchItems setImage:[UIImage imageNamed:@"icon_searchSelected.png"] forState:UIControlStateSelected];
    [_searchItems addTarget:self action:@selector(triggerFilter) forControlEvents:UIControlEventTouchUpInside];
    //[_searchItems setTitle:@"filter" forState:UIControlStateNormal];
    [self addSubview:_searchItems];
}

- (void)triggerAdd
{
    [_del addButtonPressedAtTier:_tier];
}

- (void)triggerFilter
{
    [_del filterButtonPressedAtTier:_tier];
}

#pragma mark - Self Creation and Managment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildSelf];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setDelegate:(id<DMTConfigPanelDel>)del
{
    _del = del;
}

- (void)setTier:(NSUInteger)tier
{
    _tier = tier;
}

@end
