//
//  OMOrderDetail.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMOrderDetail : BaseModel

@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *propertyValue;
@property(nonatomic, strong) NSString *quantity;

@end
