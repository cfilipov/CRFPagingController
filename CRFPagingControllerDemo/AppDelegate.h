//
//  AppDelegate.h
//  CRFPagingControllerDemo
//
//  Created by vopilif on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRFPagingController;
@class DataSource;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow               * window;
@property (nonatomic, strong) CRFPagingController    * pagingController;
@property (nonatomic, strong) UINavigationController * navigationController;
@property (nonatomic, strong) UITableViewController  * mainViewController;
@property (nonatomic, strong) DataSource             * dataSource;

- (void)toggleInfiniteScroll:(id)sender;
- (void)configureToolbar;

@end
