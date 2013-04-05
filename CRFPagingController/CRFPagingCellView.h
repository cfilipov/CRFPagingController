//
//  CRFPagingCell and CRFPagingCellView
//  CRFPagingController
//
//  Created by vopilif on 4/4/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//
//  CRFPagingCellView is the default implementation of the CRFPagingCell
//  protocol. The CRFPagingController uses a UITableViewCell instance which
//  adheres to CRFPagingCell for the trigger cell.
//
//  To customize your own CRFPagingCell, subclass UITableViewCell and implement
//  the CRFPagingCell methods to set the content of the loading and regular
//  states.
//

#import <UIKit/UIKit.h>

///////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingCell <NSObject>

- (void)setLoading:(BOOL)loading animated:(BOOL)animated;

@end

///////////////////////////////////////////////////////////////////////////////

@interface CRFPagingCellView : UITableViewCell <CRFPagingCell>

@property (nonatomic, strong) NSString                * moreText;
@property (nonatomic, strong) NSString                * loadingText;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, assign) BOOL                      loading;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end


