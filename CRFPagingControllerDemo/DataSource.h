//
//  DataSource.h
//  CRFPagingController
//
//  Created by vopilif on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRFPagingController.h"

@interface DataSource : NSObject <CRFPagingControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger       pageSize;
@property (nonatomic, assign) NSTimeInterval   loadDelay;
@property (nonatomic, strong) NSMutableArray * data;
@property (nonatomic, strong) NSMutableArray * dataToLoad;

- (void)load:(CRFPagingController *)dataSource;
- (void)preload;

@end
