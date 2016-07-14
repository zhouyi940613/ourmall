//
//  OMTaskDetailCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMCustomTool.h"
#import "OMDefined.h"

@interface OMTaskDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIconImg;
@property (weak, nonatomic) IBOutlet UIImageView *platformFlagImg;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numberImg;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@end
