//
//  OMWithdrawViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMWithdrawViewController.h"
#import "OMInputAlertViewController.h"

@interface OMWithdrawViewController ()<UITextFieldDelegate, OMInputAlertViewControllerDelegate>

@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMWithdrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES ;
    }
    return self;  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Withdrawal";

    // set button corner
    [OMCustomTool setcornerOfView:self.confirmBtn withRadius:5 color:ClearBackGroundColor];
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self loadData];
}


#pragma mark - Load Data
- (void)loadData{
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DETAIL_INFORMATION dateBlock:^(id dateBlock) {
        NSMutableDictionary *dic = [OMCustomTool OMDeleteAllNullValueInDic:dateBlock[@"Data"][@"MemberInfo"]];
        
        NSLog(@"user account data : %@", dateBlock);
        self.balanceLabel.text =dic[@"balance"];
        self.paypalLabel.text = dic[@"paypalAccount"];
        
        // remove loading view
        [self.hud hide:YES];
    }];
}


#pragma mark - Return Keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.inputTextField resignFirstResponder];
}


#pragma mark - Update PaypalAcction Action
- (IBAction)updateBtnClickedAction:(id)sender {
    
    OMInputAlertViewController *inputAlertView = [[OMInputAlertViewController alloc] init];
    // set delegate
    inputAlertView.delegate = self;
    inputAlertView.view.backgroundColor = DefaultBackgroundColor;
    inputAlertView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    inputAlertView.titleLabel.text = @"Please Enter Your Paypal account:";
    [self presentViewController:inputAlertView animated:YES completion:^{
        // set information
        inputAlertView.view.superview.backgroundColor = [UIColor clearColor];
        
    }];
}


#pragma mark - InputView Delegate Method
- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    
    NSDictionary *dic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                          @"paypalAccount" : strValue};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:dic API:API_S_UPDATE dateBlock:^(id dateBlock) {
        [OMCustomTool OMshowAlertViewWithMessage:@"Update your paypal account succeed!" fromViewController:self];
        self.paypalLabel.text = strValue;
        // update data
        [self loadData];
    }];
}

#pragma mark - Confirm Button Clicked Action
- (IBAction)confirmAction:(id)sender {
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"cash" : self.inputTextField.text,
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_APPLY_WITHDRAW dateBlock:^(id dateBlock) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Withdraw succeed!" message:nil preferredStyle:1];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:alertAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
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
