//
//  OMLoginViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMLoginViewController.h"

@interface OMLoginViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud hide:YES];
}


#pragma mark - Back Button Clicked Action
- (IBAction)backButtonClickedAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Facebook Login Settings
- (IBAction)FacebookLoginButtonClickedAction:(id)sender {
    // statistics
    
    [self.hud show:YES];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:@"LOGIN_FB" withValue:[NSString stringWithFormat:@"%@", [SETTINGs objectForKey:OM_USER_ID]]];
    
    [OMCustomTool OMLogInWithFacebook];
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(LoginSucceed) name:OMUSER_STATUS_LOGIN object:nil];
}

#pragma mark - Twitter Login Settings
- (IBAction)TwitterLoginButtonClickedAction:(id)sender {
    // statistics
    
    [self.hud show:YES];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:@"LOGIN_TW" withValue:[NSString stringWithFormat:@"%@", [SETTINGs objectForKey:OM_USER_ID]]];
    
    [OMCustomTool OMLoginWithTwitter];
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(LoginSucceed) name:OMUSER_STATUS_LOGIN object:nil];
}

#pragma mark - Dismiss Current ViewContoller After Logout
- (void)LoginSucceed{
    
//    [self.hud hide:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
