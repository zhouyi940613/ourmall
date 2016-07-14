//
//  OMTaskFinishedCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/6/30.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMTaskFinishedCell.h"

@implementation OMTaskFinishedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userIconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userIconImg];
        
        self.platformFlagImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.platformFlagImg];
        
        self.accountLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.accountLabel];
        
        self.noticeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.noticeLabel];
        
        self.userIconImg.frame = CGRectMake(10, 10, 70, 70);
        [OMCustomTool setcornerOfView:self.userIconImg withRadius:35 color:ClearBackGroundColor];
//        self.userIconImg.backgroundColor = OMSeparatorLineColor;
        
        self.platformFlagImg.frame = CGRectMake(60, 60, 20, 20);
        [OMCustomTool setcornerOfView:self.platformFlagImg withRadius:10 color:ClearBackGroundColor];
//        self.platformFlagImg.backgroundColor = OMSeparatorLineColor;
        
        self.accountLabel.frame = CGRectMake(90, 16, SCREEN_WIDTH - 90 - 10, 20);
        self.accountLabel.font = [UIFont systemFontOfSize:15.0];
//        self.accountLabel.backgroundColor = OMSeparatorLineColor;
        
        self.noticeLabel.frame = CGRectMake(90, 40, SCREEN_WIDTH - 90 - 10, 20);
        self.noticeLabel.font = [UIFont systemFontOfSize:16.0];
//        self.noticeLabel.backgroundColor = OMSeparatorLineColor;
        self.noticeLabel.text = @"You had finished this task.";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
