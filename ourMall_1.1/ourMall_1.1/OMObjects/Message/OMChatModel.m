//
//  OMChatModel.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMChatModel.h"

@implementation OMChatModel

#pragma mark - 编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.firstChar forKey:@"firstChar"];
    [aCoder encodeObject:self.memberId forKey:@"memberId"];
    [aCoder encodeObject:self.memberType forKey:@"memberType"];
    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeObject:self.timeCreated forKey:@"timeCreated"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    
}

#pragma mark - 解码
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.firstChar = [aDecoder decodeObjectForKey:@"firstChar"];
        self.memberId = [aDecoder decodeObjectForKey:@"memberId"];
        self.memberType = [aDecoder decodeObjectForKey:@"memberType"];
        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        self.timeCreated = [aDecoder decodeObjectForKey:@"timeCreated"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
    }
    return self;
}

@end
