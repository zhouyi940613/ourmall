//
//  OMCategoryEditCell.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/25.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMCategoryEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
