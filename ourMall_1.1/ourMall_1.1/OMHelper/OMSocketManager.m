//
//  OMSocketManager.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMSocketManager.h"

@implementation OMSocketManager

+ (instancetype)defaultManager{
    
    static OMSocketManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OMSocketManager alloc] init];
    });
    return manager;
}

@end
