//
//  OMEditViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import "OMProductModel.h"

@interface OMEditViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSString *verifyFlag;
@property(nonatomic, strong) NSString *myProductId;
@property(nonatomic, strong) NSString *myHeadStr;
@property(nonatomic, strong) NSString *myHasSelected;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *profitSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *onSaleOprationBtn;

@end
