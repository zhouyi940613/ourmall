//
//  OMShopOrdersViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMShopOrdersViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *titleSegment;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end
