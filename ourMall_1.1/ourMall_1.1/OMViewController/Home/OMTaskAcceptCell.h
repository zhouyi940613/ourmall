//
//  OMTaskAcceptCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/6/29.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMCustomTool.h"
#import "OMDefined.h"

@interface OMTaskAcceptCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *userIconImg;
@property (strong, nonatomic)  UIImageView *platformFlagImg;
@property (strong, nonatomic)  UILabel *accountLabel;
@property (strong, nonatomic)  UIImageView *numberImg;
@property (strong, nonatomic)  UILabel *numberLabel;
@property (strong, nonatomic)  UILabel *priceLabel;

@property (strong, nonatomic) UILabel *linkDesLabel;
@property (strong, nonatomic) UITextField *linkTextField;
@property (strong, nonatomic) UIButton *selectAllBtn;
@property (strong, nonatomic) UIImageView *editImg;
@property (strong, nonatomic) UILabel *editLabel;
@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UIButton *enterBtn;

@end
