//
//  AppDelegate.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SRWebSocketDelegate>
{
    SRWebSocket *myWebSocket;
}

@property (strong, nonatomic) UIWindow *window;


@end

