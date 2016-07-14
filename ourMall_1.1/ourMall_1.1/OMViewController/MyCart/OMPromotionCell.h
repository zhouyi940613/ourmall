//
//  OMPromotionCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMPromotionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *FBPlatformImg;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
