//
//  OMProductDetail.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMProductDetail : BaseModel

@property(nonatomic, strong) NSString *defaultPrice;
@property(nonatomic, strong) NSString *hasSelected;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *categoryId;

@end
