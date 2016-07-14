//
//  OMBalanceDetailViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMBalanceDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewBalance;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;

@property(nonatomic, strong) NSString *income;
@end
