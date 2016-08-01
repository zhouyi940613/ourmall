//
//  OMCategoryProductCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/22.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMCategoryProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *decLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
