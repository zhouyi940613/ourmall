//
//  OMAuthorityDetailViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMAuthorityDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign) NSInteger FBAccountNumber;
@property(nonatomic, assign) NSInteger TWAccountNumber;

@property(nonatomic, strong) NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *tableViewAccount;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImg;

@property (weak, nonatomic) IBOutlet UILabel *AccountNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *addNewAccountBtn;



@end
