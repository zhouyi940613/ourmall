//
//  OMMessageCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;

@end
