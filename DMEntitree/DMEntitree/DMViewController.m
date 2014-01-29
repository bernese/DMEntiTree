//
//  DMViewController.m
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

#import "DMViewController.h"
#import "DMRandomHierarchyGenerator.h"
#import "DMTreeView.h"

@interface DMViewController ()

@property (nonatomic, strong) DMRandomHierarchyGenerator *hGen;
@property (nonatomic, strong) DMTreeView *treeView;

@end

@implementation DMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hGen = [[DMRandomHierarchyGenerator alloc] init];
    [_hGen randomizeWithMaxLevelWidth:5 maxDepth:5];
    
    _treeView = [[DMTreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_treeView setDataSource:self];
    [_treeView setDelegate:self];
    [self.view addSubview:_treeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DMTAdapterDataSource

- (NSArray *)topLevelItems
{
    return [_hGen topLevels];
}

#pragma mark - DMTAdapterDelegate

- (void)adapter:(DMTAdapter *)adapter selectItemAtPath:(NSIndexPath *)selectionPath depth:(NSUInteger)depth
{
    NSLog(@"selected path : %@", selectionPath);
}

- (void)adapter:(DMTAdapter *)adapter hitDisclosureButtonForItemAtPath:(NSIndexPath *)path
{
    NSString *disclosureString = [NSString stringWithFormat:@"Drive info disclosure or object nav here for index %i/%i.", path.section, path.row];
    UIAlertView *disclosure = [[UIAlertView alloc] initWithTitle:@"Disclose Something" message:disclosureString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [disclosure show];
}


- (void)adapter:(DMTAdapter *)adapter filterTier:(NSUInteger)tier
{
    UIAlertView *searchAlert = [[UIAlertView alloc] initWithTitle:@"Filter Not Enabled" message:@"Implement adapter:filterTier:withSearchTerm: to enable search." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [searchAlert show];
}

- (void)adapter:(DMTAdapter *)adapter addItemToTier:(NSUInteger)tier ofSelection:(DMTSelection *)selection
{
    [_hGen addObjectToSelection:selection.trail atLevel:tier];
    [_treeView reloadData];
}

@end
