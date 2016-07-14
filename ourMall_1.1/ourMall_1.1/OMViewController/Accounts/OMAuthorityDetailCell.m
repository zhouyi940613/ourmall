//
//  OMAuthorityDetailCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMAuthorityDetailCell.h"
#import "OMCustomTool.h"

@implementation OMAuthorityDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [OMCustomTool setcornerOfView:self.userIconImg withRadius:30 color:[UIColor clearColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
