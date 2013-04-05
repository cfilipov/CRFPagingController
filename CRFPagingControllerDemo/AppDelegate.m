//
//  AppDelegate.m
//  CRFPagingControllerDemo
//
//  Created by vopilif on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import "AppDelegate.h"
#import "DataSource.h"
#import "CRFPagingController.h"

#define kToolbarLabelFont [UIFont boldSystemFontOfSize:20]
#define kShadowOffset     CGSizeMake(-0.5, -0.5)
#define kPageSize         8
#define kLoadDelay        1.0
#define kRowBufferSize    1

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.dataSource = [[DataSource alloc] init];
    self.dataSource.pageSize = kPageSize;
    self.dataSource.loadDelay = kLoadDelay;
    [self.dataSource preload];
    
    // IMPORTANT: Set the CRFPagingController delegates before setting
    // UITableView delegates.
    self.pagingController = [[CRFPagingController alloc] init];
    self.pagingController.delegate = self.dataSource;
    self.pagingController.tableViewDataSource = self.dataSource;
    self.pagingController.tableViewDelegate = self.dataSource;
    
    self.mainViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.mainViewController.tableView.dataSource = self.pagingController;
    self.mainViewController.tableView.delegate = self.pagingController;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    
    [self configureToolbar];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureToolbar;
{
    NSMutableArray *items = [NSMutableArray array];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = kToolbarLabelFont;
    label.text = @"Autoload";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = kShadowOffset;
    [label sizeToFit];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    [items addObject:labelItem];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:spacer];
    
    UISwitch *scrollSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *scrollSwitchItem = [[UIBarButtonItem alloc] initWithCustomView:scrollSwitch];
    [scrollSwitch addTarget:self action:@selector(toggleInfiniteScroll:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:scrollSwitchItem];
    
    self.mainViewController.toolbarItems = items;
}

- (void)toggleInfiniteScroll:(id)sender;
{
    UISwitch *s = sender;
    self.pagingController.buffer = s.on ? kRowBufferSize : 0;
}

@end
