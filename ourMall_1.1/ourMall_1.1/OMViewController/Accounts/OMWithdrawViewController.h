//
//  OMWithdrawViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMWithdrawViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UILabel *paypalLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
