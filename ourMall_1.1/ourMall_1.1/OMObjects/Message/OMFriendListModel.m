//
//  OMFriendListModel.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMFriendListModel.h"

@implementation OMFriendListModel

#pragma mark - 编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.lastMessage forKey:@"lastMessage"];
    [aCoder encodeObject:self.lastModifyTime forKey:@"lastModifyTime"];
    [aCoder encodeObject:self.messageType forKey:@"messageType"];
    [aCoder encodeObject:self.myUnReadCnt forKey:@"myUnReadCnt"];
    [aCoder encodeObject:self.otherId forKey:@"otherId"];
    [aCoder encodeObject:self.sellerId forKey:@"sellerId"];
    [aCoder encodeObject:self.sponsorName forKey:@"sponsorName"];
    [aCoder encodeObject:self.subjectPid forKey:@"subjectPid"];
    [aCoder encodeObject:self.plus forKey:@"plus"];
}

#pragma mark - 解码
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self) {
        
        self.lastMessage = [aDecoder decodeObjectForKey:@"lastMessage"];
        self.lastModifyTime = [aDecoder decodeObjectForKey:@"lastModifyTime"];
        self.messageType = [aDecoder decodeObjectForKey:@"messageType"];
        self.myUnReadCnt = [aDecoder decodeObjectForKey:@"myUnReadCnt"];
        self.otherId = [aDecoder decodeObjectForKey:@"otherId"];
        self.sellerId = [aDecoder decodeObjectForKey:@"sellerId"];
        self.sponsorName = [aDecoder decodeObjectForKey:@"sponsorName"];
        self.subjectPid = [aDecoder decodeObjectForKey:@"subjectPid"];
        self.plus = [aDecoder decodeObjectForKey:@"plus"];
        
    }
    return self;
}

@end
