//
//  OMFriendListModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMFriendListModel : BaseModel

@property(nonatomic, strong) NSString *lastMessage;
@property(nonatomic, strong) NSString *lastModifyTime;
@property(nonatomic, strong) NSString *messageType;
@property(nonatomic, strong) NSString *myUnReadCnt;
@property(nonatomic, strong) NSString *otherId;

@property(nonatomic, strong) NSDictionary *plus;

// occur sometimes
@property(nonatomic, strong) NSString *sellerId;
@property(nonatomic, strong) NSString *sponsorName;

@property(nonatomic, strong) NSString *subjectPid;

@end
