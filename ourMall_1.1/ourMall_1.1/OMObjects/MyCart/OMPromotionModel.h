//
//  OMPromotionModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMPromotionModel : BaseModel


@property(nonatomic, strong) NSString *applyCash;
@property(nonatomic, strong) NSString *finishRate; //100%  0%
@property(nonatomic, strong) NSString *history;
@property(nonatomic, strong) NSString *snsId;
@property(nonatomic, strong) NSString *status; // 1.pending 3.approved 4.complete
@property(nonatomic, strong) NSString *taskId;
@property(nonatomic, strong) NSString *taskImgUrl;
@property(nonatomic, strong) NSString *taskName;
@property(nonatomic, strong) NSString *totalPlatforms;

@end
