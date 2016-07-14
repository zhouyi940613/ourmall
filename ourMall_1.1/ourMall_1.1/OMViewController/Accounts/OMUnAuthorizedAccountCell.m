//
//  OMUnAuthorizedAccountCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMUnAuthorizedAccountCell.h"
#import "OMDefined.h"
#import "OMCustomTool.h"

@implementation OMUnAuthorizedAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.authorityBtn setTitle:@"Connect" forState:UIControlStateNormal];
    [self.authorityBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [self.authorityBtn setBackgroundColor:OMCustomOrangeColor];
    [OMCustomTool setcornerOfView:self.authorityBtn withRadius:5 color:ClearBackGroundColor];
    
    self.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
