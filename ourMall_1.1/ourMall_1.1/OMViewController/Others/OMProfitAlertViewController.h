//
//  OMProfitAlertViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/22.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@protocol OMProfitAlertViewControllerDelegate <NSObject>

@required

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *) strValue;

@end

@interface OMProfitAlertViewController : BaseViewController<UITextFieldDelegate>

@property(nonatomic, strong) NSNumber *tempMargin;
@property(nonatomic, strong) NSNumber *tempValue;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *profitSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *profitTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *profitSlider;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@property(nonatomic, assign) id <OMProfitAlertViewControllerDelegate>delegate;

@end
