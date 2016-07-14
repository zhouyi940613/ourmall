//
//  OMPromotionCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import "OMCustomTool.h"
#import "OMPromotionCell.h"

@implementation OMPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [OMCustomTool setcornerOfView:self.shareBtn withRadius:5 color:[UIColor clearColor]];
    [OMCustomTool setcornerOfView:self.FBPlatformImg withRadius:12.5 color:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
