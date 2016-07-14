//
//  OMHomeLargeCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/6/29.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMHomeLargeCell.h"

@implementation OMHomeLargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // create and initialize
    self.titleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.titleImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = NSIntegerMax;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.fansNumberLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.fansNumberLabel];
    self.fansNumberLabel.textColor = [UIColor lightGrayColor];
    self.fansNumberLabel.font = [UIFont systemFontOfSize:14];
    
    self.fansNumberImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.fansNumberImg];
    self.fansNumberImg.image = IMAGE(@"Friends.png");
    
    self.facebookImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.facebookImg];
    self.facebookImg.image = IMAGE(@"f.png");
    
    self.twitterImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.twitterImg];
    self.twitterImg.image = IMAGE(@"t.png");
    
    self.instgramImg = [[UIImageView alloc] init];
    [self.contentView addSubview:self.instgramImg];
    
    self.applyLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.applyLabel];
    self.applyLabel.textColor = WhiteBackGroudColor;
    self.applyLabel.text = @"Apply";
    self.applyLabel.font = [UIFont systemFontOfSize:16];
    self.applyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.separatorLine = [[UIView alloc] init];
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.backgroundColor = OMSeparatorLineColor;
    
    // set default style for platform icon
    self.facebookImg.hidden = YES;
    self.twitterImg.hidden = YES;
    
    [OMCustomTool setcornerOfView:self.applyLabel withRadius:5 color:ClearBackGroundColor];
    self.applyLabel.backgroundColor = OMCustomRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
