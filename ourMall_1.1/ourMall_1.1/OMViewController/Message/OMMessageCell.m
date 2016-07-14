//
//  OMMessageCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMMessageCell.h"
#import "OMDefined.h"
#import "OMCustomTool.h"

@implementation OMMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set user icon
    self.userIcon.layer.borderColor = [UIColor clearColor].CGColor;
    self.userIcon.layer.borderWidth = 1;
    self.userIcon.layer.cornerRadius = 30;
    self.userIcon.layer.masksToBounds = YES;
    
    [OMCustomTool setcornerOfView:self.bageLabel withRadius:11 color:ClearBackGroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
