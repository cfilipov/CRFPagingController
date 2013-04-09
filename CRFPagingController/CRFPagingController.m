//
//  CRFPagingController
//
//  Copyright (c) 2013, Cristian Filipov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the Cristian Filipov nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
//  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "CRFPagingController.h"
#import "CRFPagingCellView.h"

#define kPagingCellReuseIdentifier @"PagingCell"

///////////////////////////////////////////////////////////////////////////////

@implementation NSIndexPath (CRFExtension)

+ (NSArray *)indexPathsForRange:(NSRange)range;
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:range.length];
 
    for (int i = range.location; i < range.location+range.length; i++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    return indexPaths;
}

@end

///////////////////////////////////////////////////////////////////////////////

@interface CRFPagingController ()

@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger numberOfDataRows;
@property (nonatomic, assign) BOOL      hasNextPage;
@property (nonatomic, assign) BOOL      showTriggerCell;
@property (nonatomic, assign) BOOL      isLoading;

- (BOOL)isTriggerCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)bufferNeedsData;
- (void)loadNextPage;
- (void)showOrHideTriggerCell;

@end

///////////////////////////////////////////////////////////////////////////////

@implementation CRFPagingController

- (void)dealloc
{
    self.delegate = nil;
    self.tableViewDelegate = nil;
    self.tableViewDataSource = nil;
    self.tableView = nil;
}

#pragma mark Public Methods

- (void)nextPageIsReady:(NSRange)rangeOfNextPage;
{
    assert(self.tableView != nil);
    
    NSLog(@"Loaded %d items.", rangeOfNextPage.length);
    
    NSArray *indexPaths = [NSIndexPath indexPathsForRange:rangeOfNextPage];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark Private Methods

- (BOOL)isTriggerCellAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger triggerIndex = self.showTriggerCell ? self.numberOfRows-1 : -1;
    return indexPath.row == triggerIndex;
}

- (BOOL)bufferNeedsData;
{
    if (self.bufferSize == 0 || !self.autoLoad || !self.hasNextPage)
    {
        return NO;
    }
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *indexPath = visibleIndexPaths.lastObject;
    NSInteger buffer = self.numberOfDataRows-indexPath.row;
    
    return buffer < self.bufferSize;
}

- (void)loadNextPage;
{
    if (self.isLoading)
    {
        return;
    }
    
    self.isLoading = YES;
    [self.triggerCell setLoading:YES animated:YES];
    [self.delegate pagingControllerLoadNextPage:self];
}

- (void)showOrHideTriggerCell;
{
    [self.tableView beginUpdates];
    
    if (self.hasNextPage)
    {
        NSRange range = NSMakeRange(self.numberOfRows, 1);
        self.showTriggerCell = YES;
        NSArray *paths = [NSIndexPath indexPathsForRange:range];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (self.showTriggerCell)
    {
        NSRange range = NSMakeRange(self.numberOfRows-1, 1);
        self.showTriggerCell = NO;
        NSArray *paths = [NSIndexPath indexPathsForRange:range];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView endUpdates];
}

#pragma mark Override Synthesized Methods

- (UITableViewCell *)triggerCell
{
    if (_triggerCell == nil)
    {
        _triggerCell = [[CRFPagingCellView alloc] initWithReuseIdentifier:kPagingCellReuseIdentifier];
    }
    
    return _triggerCell;
}

- (NSInteger)numberOfRows
{
    return self.showTriggerCell ? self.numberOfDataRows+1 : self.numberOfDataRows;
}

#pragma mark UITableViewDataSource Optional Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    // This data controller only supports single-section tables.
    return 1;
}

#pragma mark UITableViewDataSource Required Methods

//
// These methods from UITableViewDataSource are REQUIRED so no need to check if
// the target responds to the selector.
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return self.triggerCell;
    }
    else
    {
        return [self.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView = tableView;
    self.numberOfDataRows = [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
    self.hasNextPage = [self.delegate pagingControllerDoesHaveNextPage:self];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.hasNextPage != self.showTriggerCell)
        {
            [self showOrHideTriggerCell];
        }
        
        if ([self bufferNeedsData])
        {
            [self loadNextPage];
        }
    }];

    [self.triggerCell setLoading:NO animated:YES];
    self.isLoading = NO;
    
    return self.numberOfRows;
}

#pragma mark UITableViewDelegate Methods

//
// These methods from UITableViewDelegate are OPTIONAL so don't forget to check
// if the target responds to the selector before sending a message.
//

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self bufferNeedsData])
    {
        [self loadNextPage];
    }
    else if ([self isTriggerCellAtIndexPath:indexPath] && self.autoLoad)
    {
        [self loadNextPage];
    }
    else if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return tableView.rowHeight;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return YES;
    }
    
    if ([self.tableView respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return indexPath;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return indexPath;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self loadNextPage];
    }
    else if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [self.tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return 0;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath])
    {
        return NO;
    }
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
    {
        return [self.tableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    
    return NO;
}

#pragma mark Forward SEL Targets

// Forward calls to UITableViewDataSource and UITableViewDelegate
- (BOOL)respondsToSelector:(SEL)sel
{
    if ([self.tableViewDataSource respondsToSelector:sel])
    {
        return YES;
    }
    
    if ([self.tableViewDelegate respondsToSelector:sel])
    {
        return YES;
    }
    
    return [super respondsToSelector:sel];
}

// Forward calls to UITableViewDataSource and UITableViewDelegate
- (id)forwardingTargetForSelector:(SEL)sel
{
    if ([self.tableViewDataSource respondsToSelector:sel])
    {
        return self.tableViewDataSource;
    }
    
    if ([self.tableViewDelegate respondsToSelector:sel])
    {
        return self.tableViewDelegate;
    }
    
    return [super forwardingTargetForSelector:sel];
}

@end
