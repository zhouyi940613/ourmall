//
//  OMProductCategoryViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import "OMProductModel.h"

@interface OMProductCategoryViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *headStr;
@property(nonatomic, strong) NSString *hasSelected;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
