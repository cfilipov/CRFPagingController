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
//  ////////////////////////////////////////////////////////////////////////////
//
//  CRFPagingController adds paging functionality to UITableViews.
//
//  CRFPagingController works by implementing the minimal logic necessary
//  for paging inside UITableviewDataSource and UITableViewDelegate methods and
//  delegating the remaining responsibility to real UITableviewDataSource and
//  UITableViewDelegate instances.
//
//  To use this class, create a new instance of CRFPagingController and set
//  the delegates for tableViewDataSource, tableViewDelegate and delegate; then
//  set the instance as a UITableView's data source and delegate.
//
//  IMPORTANT: Because UITableViews cache results from -respondsToSelector: you
//  MUST set the tableViewDataSource and tableViewDelegate properties of this
//  class BEFORE you set the dataSource and delegate properties of the
//  UITableView.
//

#import <UIKit/UIKit.h>
#import "CRFPagingCellView.h"

////////////////////////////////////////////////////////////////////////////////

@interface NSIndexPath (CRFExtension)

// Convenience method for creating an array of NSIndexPaths.
+ (NSArray *)indexPathsForRange:(NSRange)range;

@end

////////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingControllerDelegate;

////////////////////////////////////////////////////////////////////////////////

@interface CRFPagingController : NSObject <UITableViewDataSource, UITableViewDelegate>

// IMPORTANT: You MUST set this property before setting the UITableView's
// dataSource property.
@property (nonatomic, weak) id<UITableViewDataSource> tableViewDataSource;

// IMPORTANT: You MUST set this property before setting the UITableView's
// delegate property.
@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;

// The delegate will be informated of requests to paginate data.
@property (nonatomic, weak) id<CRFPagingControllerDelegate>  delegate;

// The number of rows to maintain ahead of the greatest currently visible index.
// For example: setting the buffer to 5 will cause the paging controller to
// request the next page when there are 5 rows remaining to be displayed.
// Default value is 0 (no buffer, user interaction required to load next page).
//
// Note: The buffer size must be  less than the page size.
@property (nonatomic, assign) NSUInteger buffer;

// Customize the trigger cell ("more button") appearance. Trigger cells must
// conform to the CRFPagingCell protocol.
@property (nonatomic, strong) UITableViewCell<CRFPagingCell> * triggerCell;

// The UITableView for which this instance is delegating.
@property (nonatomic, weak) UITableView * tableView;

- (void)loadedNextPage:(NSUInteger)rows;

@end

////////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingControllerDelegate <NSObject>

@required

// Called when a the tableView is scrolled into the buffer.
- (void)pagingControllerBufferNeedsNextPage:(CRFPagingController *)dataSource;

// Called when the triggerCell ("more button") is selected.
- (void)pagingControllerDidTriggerNextPage:(CRFPagingController *)dataSource;

// Delegates should return YES if there are more pages to load.
- (BOOL)pagingControllerDoesHaveNextPage:(CRFPagingController *)dataSource;

@end