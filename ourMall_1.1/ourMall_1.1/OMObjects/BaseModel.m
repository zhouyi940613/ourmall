//
//  BaseModel.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSMutableArray *)ModelArr_With_DictionaryArr:(NSArray *)arr{
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        id model = [[self class] baseModelWithDic:dic];
        [modelArr addObject:model];
    }
    
    return modelArr;
}

+ (instancetype)baseModelWithDic:(NSDictionary *)dic{
    
    id model = [[[self class] alloc] initWithDic:dic];
    return model;
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
