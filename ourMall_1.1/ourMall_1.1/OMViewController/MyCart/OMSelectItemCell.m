//
//  OMSelectItemCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMSelectItemCell.h"
#import "OMDefined.h"

@implementation OMSelectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.layer.borderColor = OMCustomRedColor.CGColor;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 15;
    self.titleLabel.backgroundColor = WhiteBackGroudColor;
    self.titleLabel.textColor = OMCustomRedColor;
    self.titleLabel.textAlignment =  NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}

@end
