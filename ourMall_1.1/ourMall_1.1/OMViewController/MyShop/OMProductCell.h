//
//  OMProductCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *productStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *productDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *productAmoutLabel;

@end
