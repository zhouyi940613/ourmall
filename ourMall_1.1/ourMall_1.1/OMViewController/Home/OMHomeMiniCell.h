//
//  OMHomeMiniCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/6/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDefined.h"

@interface OMHomeMiniCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fansNumberImg;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImg;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImg;
@property (weak, nonatomic) IBOutlet UIImageView *instgramImg;

@property (weak, nonatomic) IBOutlet UILabel *applyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgContainerImg;

@end
