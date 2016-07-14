//
//  OMMessageViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"
#import <SRWebSocket.h>

@interface OMMessageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate>
{
    SRWebSocket *myWebSocket;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewMessage;

@end
