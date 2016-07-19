//
//  OMTaskDetailCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMTaskDetailCell.h"

@implementation OMTaskDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 131 192 243 custom blue
    self.numberLabel.textColor = Rgb2UIColor(131, 192, 243);
    
    [OMCustomTool setcornerOfView:self.userIconImg withRadius:35 color:ClearBackGroundColor];
    [OMCustomTool setcornerOfView:self.platformFlagImg withRadius:10 color:ClearBackGroundColor];
    [OMCustomTool setcornerOfView:self.operationBtn withRadius:5 color:ClearBackGroundColor];
    
    self.platformFlagImg.hidden = YES;
    
    // set cell unenable click
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.operationBtn.titleLabel.numberOfLines = NSIntegerMax;
    self.operationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
