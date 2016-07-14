//
//  OMInputAlertViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@protocol OMInputAlertViewControllerDelegate <NSObject>

@required

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *) strValue;

@end

@interface OMInputAlertViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic, assign) id <OMInputAlertViewControllerDelegate>delegate;


@end
