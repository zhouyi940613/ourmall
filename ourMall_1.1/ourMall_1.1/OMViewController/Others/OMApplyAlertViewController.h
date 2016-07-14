//
//  OMApplyAlertViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/19.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@protocol OMApplyAlertViewControllerDelegate <NSObject>

@required

- (void)applyBnttonClickedEvent_WithTextFieldValue:(NSString *) strValue;

@end

@interface OMApplyAlertViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property(nonatomic, assign) id <OMApplyAlertViewControllerDelegate>delegate;

@end
