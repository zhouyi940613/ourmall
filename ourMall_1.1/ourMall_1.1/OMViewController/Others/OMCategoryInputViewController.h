//
//  OMCategoryInputViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/22.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@protocol OMCategoryInputViewControllerDelegate <NSObject>

@required

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *) strValue;

@end

@interface OMCategoryInputViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic, assign) id <OMCategoryInputViewControllerDelegate>delegate;

@end
