//
//  CRFPagingController
//
//  Created by Cristian Filipov on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov Inc. All rights reserved.
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

///////////////////////////////////////////////////////////////////////////////

@interface NSIndexPath (CRFExtension)

// Convenience method for creating an array of NSIndexPaths.
+ (NSArray *)indexPathsForRange:(NSRange)range;

@end

///////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingControllerDelegate;

///////////////////////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingControllerDelegate <NSObject>

@required

// Called when a the tableView is scrolled into the buffer.
- (void)pagingControllerBufferNeedsNextPage:(CRFPagingController *)dataSource;

// Called when the triggerCell ("more button") is selected.
- (void)pagingControllerDidTriggerNextPage:(CRFPagingController *)dataSource;

// Delegates should return YES if there are more pages to load.
- (BOOL)pagingControllerDoesHaveNextPage:(CRFPagingController *)dataSource;

@end