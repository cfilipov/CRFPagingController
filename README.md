CRFPagingController
===================

Summary
-------

CRFPagingController provides "infinite scrolling" functionality to UITableViews 
by implementing the UITableViewDataSource protocol and forwarding methods to a 
"real" data source. This allows one to easily enable table view paging by simply 
placing this controller between the data source and table view.

Usage
-----

Implement the CRFPagingControllerDelegate protocol (in addition to the 
UITableView delegate and dataSource):

    @interface MyDataSource : NSObject <CRFPagingControllerDelegate, UITableViewDelegate, UITableViewDataSource>

    ...

    @end

Instantiate the CRFPagingController:

    self.pagingController = [[CRFPagingController alloc] init];

Set the delegate, tableViewDataSource and tableViewDelegate properties:

    self.pagingController.delegate = self.dataSource;
    self.pagingController.tableViewDataSource = self.dataSource;
    self.pagingController.tableViewDelegate = self.dataSource;

Set the dataSource and delegate of your UITableView to the CRFPagingController 
instance.

    self.mainViewController.tableView.dataSource = self.pagingController;
    self.mainViewController.tableView.delegate = self.pagingController;

Configure the CRFPagingController:

    self.pagingController.buffer = 5;

IMPORTANT: You MUST set the tableViewDataSource and tableViewDelegate 
properties of this class BEFORE you set the dataSource and delegate 
properties of the UITableView.

License
-------

CRFPagingController is licensed under the 3-clause BSD license. A copy of the 
license can be found in the LICENSE file.