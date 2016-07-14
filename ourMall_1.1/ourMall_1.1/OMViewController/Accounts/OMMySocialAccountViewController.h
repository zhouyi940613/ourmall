//
//  OMMySocialAccountViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMMySocialAccountViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableViewAccount;

@property(nonatomic, assign) NSInteger FBFlag;
@property(nonatomic, assign) NSInteger TWFlag;
//@property(nonatomic, strong) NSArray *authorizedArray;

@end
