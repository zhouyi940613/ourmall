//
//  OMSeparatorCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMSeparatorCell.h"

@implementation OMSeparatorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set cell unenable click
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
