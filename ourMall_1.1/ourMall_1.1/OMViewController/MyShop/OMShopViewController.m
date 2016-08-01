//
//  OMShopViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/15.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopViewController.h"

#import "OMWebViewController.h"
#import "OMShopProductViewController.h"
#import "OMShopOrdersViewController.h"
#import "OMShopSettingsViewController.h"

#import "OMShopWebViewController.h"


@interface OMShopViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Shop";
    
    
    UITapGestureRecognizer *shopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToShopPage:)];
    UITapGestureRecognizer *productTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToProductPage:)];
    UITapGestureRecognizer *orderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToOrdersPage:)];
    UITapGestureRecognizer *settingsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToSettingsPage:)];
    
    
    [self.shopImg addGestureRecognizer:shopTap];
    [self.productImg addGestureRecognizer:productTap];
    [self.orderImg addGestureRecognizer:orderTap];
    [self.settingsImg addGestureRecognizer:settingsTap];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self loadData];
}

- (void)loadData{
    
    // interface for revenue label value
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DETAIL_INFORMATION dateBlock:^(id dateBlock) {
        
        // obtain parameters
        NSLog(@"shop informations : %@", dateBlock);
        NSString *revenueValue = dateBlock[@"Data"][@"MemberInfo"][@"thirtyDayIncome"];
        self.revenueLabel.text = [self OMString:revenueValue];
    }];
    
    [self.hud hide:YES];
}

- (void)jumpToShopPage:(UITapGestureRecognizer *)tap{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DETAIL_INFORMATION dateBlock:^(id dateBlock) {
        
        // obtain parameters
        NSLog(@"shop informations : %@", dateBlock);
        NSString *shopUrl = dateBlock[@"Data"][@"MemberInfo"][@"shopDetail"][@"shopUrl"];
        
        
        OMShopWebViewController *shopWebVC = [[OMShopWebViewController alloc] init];
        shopWebVC.URLString = shopUrl;
        [self.navigationController pushViewController:shopWebVC animated:YES];
    }];
    
}

- (void)jumpToProductPage:(UITapGestureRecognizer *)tap{
    
    OMShopProductViewController *productVC = [[OMShopProductViewController alloc] init];
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void)jumpToOrdersPage:(UITapGestureRecognizer *)tap{
    
    OMShopOrdersViewController *orderVC = [[OMShopOrdersViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

- (void)jumpToSettingsPage:(UITapGestureRecognizer *)tap{
    
    OMShopSettingsViewController *settingsVC = [[OMShopSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
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
