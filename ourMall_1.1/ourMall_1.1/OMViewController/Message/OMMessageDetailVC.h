//
//  OMMessageDetailVC.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import <SRWebSocket.h>
#import "OMFriendListModel.h"

@interface OMMessageDetailVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) OMFriendListModel *model;

@end
