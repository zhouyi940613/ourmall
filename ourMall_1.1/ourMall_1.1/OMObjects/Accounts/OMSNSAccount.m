//
//  OMSNSAccount.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMSNSAccount.h"

@implementation OMSNSAccount

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        value = self.idValue;
    }
}

@end
