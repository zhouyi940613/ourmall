//
//  OMAccountDetail.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMAccountDetail : BaseModel

@property(nonatomic, strong) NSString *amount;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, strong) NSString *symbol;

@end
