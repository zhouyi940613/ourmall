//
//  OMHomeTaskModel.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseModel.h"

@interface OMHomeTaskModel : BaseModel

/* example model date:
 *
 * id = 78;
 * imgUrl = "https://contestimg.wish.com/api/webimage/539fe593d9113915c54a33a7-5-.jpg";
 * name = "Color-Changing LED Strip Light IR Remote Power Supply ";
 * releasePlatform = (2, 1);
 * timeCreated = "2016-05-09 05:08:09";
 * viewCount = 60;
 *
 */

@property(nonatomic, strong) NSString *idValue;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *timeCreated;
@property(nonatomic, strong) NSString *viewCount;
@property(nonatomic, strong) NSArray  *releasePlatform;


@end
