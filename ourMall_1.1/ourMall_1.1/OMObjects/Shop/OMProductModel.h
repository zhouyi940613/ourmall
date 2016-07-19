//
//  OMProductModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/18.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMProductModel : BaseModel

@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *idOfCategory;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *profit;
@property(nonatomic, strong) NSString *timeCreated;

@end
