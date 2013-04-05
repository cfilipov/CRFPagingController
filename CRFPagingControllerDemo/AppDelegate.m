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
