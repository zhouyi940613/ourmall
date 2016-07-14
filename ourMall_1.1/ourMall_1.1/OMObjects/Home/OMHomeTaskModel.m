//
//  OMHomeTaskModel.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMHomeTaskModel.h"

@implementation OMHomeTaskModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }
}

@end
