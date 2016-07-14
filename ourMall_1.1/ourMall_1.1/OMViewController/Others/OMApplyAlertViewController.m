//
//  OMApplyAlertViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/19.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMApplyAlertViewController.h"

@interface OMApplyAlertViewController ()

@end

@implementation OMApplyAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [OMCustomTool setcornerOfView:self.submitBtn withRadius:5 color:ClearBackGroundColor];
}


- (IBAction)closeButtonClickedAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)submitButtonClickedAction:(id)sender {
    
    // delegate method
    [self.delegate applyBnttonClickedEvent_WithTextFieldValue:self.inputTextField.text];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
