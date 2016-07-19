//
//  OMCategoryModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/18.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMCategoryModel : BaseModel

@property(nonatomic, strong) NSString *categoryId;
@property(nonatomic, strong) NSString *count;
@property(nonatomic, strong) NSString *isHasThisCategory;
@property(nonatomic, strong) NSString *name;

@end
