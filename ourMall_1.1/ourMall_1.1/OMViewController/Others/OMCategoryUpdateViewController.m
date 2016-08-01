//
//  OMCategoryUpdateViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMCategoryUpdateViewController.h"

@interface OMCategoryUpdateViewController ()

@end

@implementation OMCategoryUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [OMCustomTool setcornerOfView:self.saveBtn withRadius:5 color:ClearBackGroundColor];
}

- (IBAction)closeBtnClickedAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)saveBtnClickedAction:(id)sender {
    
    // delegate method
    [self.delegate saveBnttonClickedEvent_WithTextFieldValue:self.inputTextField.text];
    
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
