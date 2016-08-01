//
//  OMCateSearchViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import "OMCategoryModel.h"

@interface OMCateSearchViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) OMCategoryModel *model;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBtn;

@end
