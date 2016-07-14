//
//  OMHomeLargeCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/6/29.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDefined.h"
#import "OMCustomTool.h"

@interface OMHomeLargeCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *titleImageView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIImageView *fansNumberImg;
@property (strong, nonatomic)  UILabel *fansNumberLabel;

@property (strong, nonatomic)  UIImageView *facebookImg;
@property (strong, nonatomic)  UIImageView *twitterImg;
@property (strong, nonatomic)  UIImageView *instgramImg;

@property (strong, nonatomic)  UILabel *applyLabel;

@property (strong, nonatomic)  UIView *separatorLine;

@end

