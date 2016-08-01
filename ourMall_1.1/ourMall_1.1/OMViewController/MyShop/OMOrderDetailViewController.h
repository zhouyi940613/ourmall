//
//  OMOrderDetailViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

#import "OMOrderModel.h"
#import "OMOrderDetail.h"

@interface OMOrderDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) OMOrderModel *model;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

@end
