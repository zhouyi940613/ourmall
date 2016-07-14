//
//  OMChatModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMChatModel : BaseModel

@property(nonatomic ,strong) NSString *content;
@property(nonatomic ,strong) NSString *firstChar;
@property(nonatomic ,strong) NSString *memberId;
@property(nonatomic ,strong) NSString *memberType;
@property(nonatomic ,strong) NSString *pid;
@property(nonatomic ,strong) NSString *timeCreated;
@property(nonatomic ,strong) NSString *portrait;

@end
