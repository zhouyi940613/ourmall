//
//  NSString+MD5HexDigest.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface NSString (MD5)

// Return a encrypted string with MD5

- (NSString *)md5HexDigest;

@end
