//
//  OMCategoryUpdateViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@protocol OMCategoryUpdateViewControllerDelegate <NSObject>

@required

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *) strValue;

@end


@interface OMCategoryUpdateViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property(nonatomic, assign) id <OMCategoryUpdateViewControllerDelegate>delegate;

@end
