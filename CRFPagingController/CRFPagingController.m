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

@property (nonatomic, assign) NSInteger  numberOfRows;
@property (nonatomic, assign) BOOL       hasNextPage;
@property (nonatomic, assign) BOOL       showTriggerCell;
@property (nonatomic, assign) BOOL       isLoading;

- (BOOL)isTriggerCellAtIndexPath:(NSIndexPath *)indexPath;

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

- (void)loadedNextPage:(NSUInteger)rows;
{
    assert(self.tableView != nil);
    
    self.isLoading = NO;
    [self.triggerCell setLoading:NO animated:YES];
    
    NSUInteger insertIdx = self.showTriggerCell ? self.numberOfRows-1 : self.numberOfRows;
    NSRange range = NSMakeRange(insertIdx, rows);
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSIndexPath indexPathsForRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark Private Methods

- (BOOL)isTriggerCellAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger triggerIndex = self.showTriggerCell ? self.numberOfRows-1 : -1;
    return indexPath.row == triggerIndex;
}

#pragma mark Override Synthesized Methods

- (UITableViewCell *)triggerCell;
{
    if (_triggerCell == nil)
    {
        _triggerCell = [[CRFPagingCellView alloc] initWithReuseIdentifier:kPagingCellReuseIdentifier];
    }
    
    return _triggerCell;
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
    //
    // Check if this is a trigger cell, if so, trigger a page load.
    //
    if (self.hasNextPage && !self.isLoading)
    {
        //
        // Users of this class should ensure the triggerCount is less than the
        // size of a page. To guard against this, default to using the trigger
        // cell as a trigger if triggerCount is too large.
        //
        NSInteger triggerIndex = self.numberOfRows-self.buffer;
        if (triggerIndex < indexPath.row)
        {
            triggerIndex = self.numberOfRows-1;
        }
        
        if (triggerIndex == indexPath.row)
        {
            self.isLoading = YES;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.triggerCell setLoading:YES animated:YES];
                
                NSLog(@"Buffering page at index %d", triggerIndex);
                
                [self.delegate pagingControllerBufferNeedsNextPage:self];
            }];
        }
    }

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
    self.numberOfRows = [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
    self.hasNextPage = [self.delegate pagingControllerDoesHaveNextPage:self];
    self.numberOfRows += self.showTriggerCell ? 1 : 0;
    
    NSLog(@"\tself.numberOfRows = %d", self.numberOfRows);
    
    //
    // Display the trigger cell if necessary. Do this after numberOfRowsInSection
    // has completed (hence the need to append it to the main operation queue).
    //
    if (self.hasNextPage != self.showTriggerCell && !self.isLoading)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [tableView beginUpdates];
            
            if (self.hasNextPage)
            {
                self.showTriggerCell = YES;
                NSArray *paths = [NSIndexPath indexPathsForRange:NSMakeRange(self.numberOfRows, 1)];
                [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if (self.showTriggerCell)
            {
                self.showTriggerCell = NO;
                NSArray *paths = [NSIndexPath indexPathsForRange:NSMakeRange(self.numberOfRows-1, 1)];
                [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [tableView endUpdates];
        }];
    }
    
    return self.numberOfRows;
}

#pragma mark UITableViewDelegate Methods

//
// These methods from UITableViewDelegate are OPTIONAL so don't forget to check
// if the target responds to the selector before sending a message.
//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isTriggerCellAtIndexPath:indexPath] && !self.isLoading)
    {
        self.isLoading = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.triggerCell setLoading:YES animated:YES];
        [self.delegate pagingControllerDidTriggerNextPage:self];
    }
    else
    {
        if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
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
