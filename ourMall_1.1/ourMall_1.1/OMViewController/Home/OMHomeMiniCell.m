//
//  OMHomeMiniCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/6/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMHomeMiniCell.h"
#import "OMCustomTool.h"

@implementation OMHomeMiniCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set default style for platform icon
    self.facebookImg.hidden = YES;
    self.twitterImg.hidden = YES;
    
    self.imgContainerImg.layer.borderColor = OMSeparatorLineColor.CGColor;
    self.imgContainerImg.layer.borderWidth = 1;
    
    [OMCustomTool setcornerOfView:self.applyLabel withRadius:5 color:ClearBackGroundColor];
    self.applyLabel.backgroundColor = OMCustomRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
