//
//  OMShopAddProductVC.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import <MJRefresh.h>

@interface OMShopAddProductVC : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak,   nonatomic)   IBOutlet  UITableView    *searchTableView;
@property (strong, nonatomic)   IBOutlet  UIView         *searchView;
@property (weak,   nonatomic)   IBOutlet  UITextField    *searchTextField;
@property (weak,   nonatomic)   IBOutlet  UIButton       *searchButton;

@end
