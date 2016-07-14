//
//  OMUser.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/20.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMUser : BaseModel

/*
 balance = "0.00";
 frozenAmount = "0.00";
 id = 30;
 loginTimes = 19;
 name = zhoujian940613;
 paypalAccount = "<null>";
 portrait = "http://pbs.twimg.com/profile_images/729917278351855616/pS-CyHRX.jpg";
 snsAccountCount = 1;
 taskApplyingCount = 0;
 taskDoingCount = 0;
 taskFinishedCount = 0;
 timeCreated = "<null>";
 timeLastLogin = "2016-05-20 01:38:07";
 timeLogin = "2016-05-20 01:47:54";
 totalGetCash = 0;
 */

@property(nonatomic, strong) NSString *balance;
@property(nonatomic, strong) NSString *frozenAmount;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *paypalAccount;
@property(nonatomic, strong) NSString *portrait;
@property(nonatomic, strong) NSString *snsAccountCount;
@property(nonatomic, strong) NSString *taskApplyingCount;
@property(nonatomic, strong) NSString *taskDoingCount;
@property(nonatomic, strong) NSString *taskFinishedCount;
@property(nonatomic, strong) NSString * totalGetCash;
@property(nonatomic, strong) NSString *ongoingCash;

@end
