//
//  OMMainViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface OMMainViewController : UITabBarController<SRWebSocketDelegate>
{
    SRWebSocket *myWebSocket;
}

@end
