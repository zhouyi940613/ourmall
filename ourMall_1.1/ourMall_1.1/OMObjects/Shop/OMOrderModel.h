//
//  OMOrderModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMOrderModel : BaseModel

@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *profit;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *totalAmount;
@property(nonatomic, strong)  NSArray *orderPlus;

@end
