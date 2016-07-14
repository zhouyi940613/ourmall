//
//  OMTaskAcceptCell.m
//  ourMall_1.1
//
//  Created by Jay on 16/6/29.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMTaskAcceptCell.h"

@implementation OMTaskAcceptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // create and initialize
        self.userIconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userIconImg];
        
        self.platformFlagImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.platformFlagImg];
        
        self.accountLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.accountLabel];
        
        self.numberImg  =[[UIImageView alloc] init];
        [self.contentView addSubview:self.numberImg];
        
        self.numberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.numberLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.priceLabel];
        
        // new requires
        self.linkDesLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.linkDesLabel];
        
        self.linkTextField = [[UITextField alloc] init];
        [self.contentView addSubview:self.linkTextField];
        
        self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.selectAllBtn];
        
        self.editImg = [[UIImageView alloc] init];
        [self.contentView addSubview:self.editImg];
        
        self.editLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.editLabel];
        
        self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.enterBtn];
        
        
        self.inputTextField = [[UITextField alloc] init];
        [self.contentView addSubview:self.inputTextField];
        
        self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.submitBtn];
        
        
        
        self.numberLabel.textColor = OMCustomBlueColor;
        
        [OMCustomTool setcornerOfView:self.userIconImg withRadius:35 color:ClearBackGroundColor];
        [OMCustomTool setcornerOfView:self.platformFlagImg withRadius:10 color:ClearBackGroundColor];
        
        self.platformFlagImg.hidden = YES;
        
        // new require (style)
        
        /*
         @property (strong, nonatomic)  UIImageView *userIconImg;
         @property (strong, nonatomic)  UIImageView *platformFlagImg;
         @property (strong, nonatomic)  UILabel *accountLabel;
         @property (strong, nonatomic)  UIImageView *numberImg;
         @property (strong, nonatomic)  UILabel *numberLabel;
         @property (strong, nonatomic)  UILabel *priceLabel;
         */
        self.userIconImg.frame = CGRectMake(10, 10, 70, 70);
        [OMCustomTool setcornerOfView:self.userIconImg withRadius:35 color:ClearBackGroundColor];
//        self.userIconImg.backgroundColor = OMSeparatorLineColor;
        
        self.platformFlagImg.frame = CGRectMake(60, 60, 20, 20);
        [OMCustomTool setcornerOfView:self.platformFlagImg withRadius:10 color:ClearBackGroundColor];
//        self.platformFlagImg.backgroundColor = OMSeparatorLineColor;
        
        self.accountLabel.frame = CGRectMake(90, 16, SCREEN_WIDTH - 90 - 10, 20);
        self.accountLabel.font = [UIFont systemFontOfSize:15.0];
//        self.accountLabel.backgroundColor = OMSeparatorLineColor;
        
        self.numberImg.frame = CGRectMake(90, 55, 15, 15);
        [self.numberImg setImage:IMAGE(@"Friends-xq.png")];
//        self.numberImg.backgroundColor = OMSeparatorLineColor;
        
        self.numberLabel.frame = CGRectMake(105, 54, 40, 20);
        self.numberLabel.textColor = OMCustomBlueColor;
        self.numberLabel.font = [UIFont systemFontOfSize:14.0];
//        self.numberLabel.backgroundColor = OMSeparatorLineColor;
        
        self.priceLabel.frame = CGRectMake(150, 54, 70, 20);
        self.priceLabel.textColor = OMCustomRedColor;
        self.priceLabel.font = [UIFont systemFontOfSize:14.0];
//        self.priceLabel.backgroundColor = OMSeparatorLineColor;
        
        /*
         @property (strong, nonatomic) UILabel *linkDesLabel;
         @property (strong, nonatomic) UILabel *linkLabel;
         @property (strong, nonatomic) UIButton *selectAllBtn;
         @property (strong, nonatomic) UIImageView *editImg;
         @property (strong, nonatomic) UILabel *editLabel;
         @property (strong, nonatomic) UIButton *enterBtn;
         */
        
        self.linkDesLabel.frame = CGRectMake(10, 80, SCREEN_WIDTH - 20, 20);
        self.linkDesLabel.textColor = [UIColor lightGrayColor];
        self.linkDesLabel.font = [UIFont systemFontOfSize:14];
//        self.linkDesLabel.backgroundColor = OMSeparatorLineColor;
        self.linkDesLabel.text = @"Link need to share:";
        
        self.linkTextField.frame = CGRectMake(10, 105, SCREEN_WIDTH - 20 - 100, 20);
        self.linkTextField.textColor = OMCustomBlueColor;
        self.linkTextField.font = [UIFont systemFontOfSize:14];
//        self.linkTextField.backgroundColor = OMSeparatorLineColor;
        self.linkTextField.enabled = NO;
        
        self.selectAllBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 60, 103, 60, 24);
        [self.selectAllBtn setTitle:@"copy" forState:UIControlStateNormal];
        self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.selectAllBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
        self.selectAllBtn.backgroundColor = OMCustomBlueColor;
        self.selectAllBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [OMCustomTool setcornerOfView:self.selectAllBtn withRadius:3 color:ClearBackGroundColor];
        
        self.editImg.frame = CGRectMake(10, 137, 15, 15);
//        [OMCustomTool setcornerOfView:self.editImg withRadius:10 color:ClearBackGroundColor];
//        self.editImg.backgroundColor = OMSeparatorLineColor;
        
        self.editLabel.frame = CGRectMake(27, 135, SCREEN_WIDTH - 30 - 100, 20);
        self.editLabel.font = [UIFont systemFontOfSize:14];
//        self.editLabel.backgroundColor = OMSeparatorLineColor;
        self.editLabel.text = @"Verify valid link that direct to the post";
        
        self.enterBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 60, 133, 60, 24);
        [self.enterBtn setTitle:@"enter" forState:UIControlStateNormal];
        self.enterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.enterBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
        self.enterBtn.backgroundColor = OMCustomRedColor;
        self.enterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [OMCustomTool setcornerOfView:self.enterBtn withRadius:3 color:ClearBackGroundColor];
        
        // hiden
        /*
         @property (strong, nonatomic) UITextField *inputTextField;
         @property (strong, nonatomic) UIButton *submitBtn;
         */
        
        self.inputTextField.frame = CGRectMake(10, 170, SCREEN_WIDTH - 20 - 80, 25);
        [OMCustomTool setcornerOfView:self.inputTextField withRadius:0 color:OMSeparatorLineColor];
        self.inputTextField.hidden = YES;
        self.inputTextField.font = [UIFont systemFontOfSize:15];
        
        self.submitBtn.frame = CGRectMake(10 + SCREEN_WIDTH - 20 - 80, 170, 80, 25);
        [self.submitBtn setTitle:@"submit" forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
        self.submitBtn.backgroundColor = OMCustomRedColor;
        self.submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.submitBtn.hidden = YES;
        
        // set cell unenable click
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
