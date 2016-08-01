//
//  OMAccountsViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import "AppDelegate.h"

#import "OMAccountsViewController.h"
#import "OMVisitorViewController.h"

#import "OMHomeViewController.h"
#import "OMBalanceDetailViewController.h"
#import "OMContactusViewController.h"
#import "OMMySocialAccountViewController.h"
#import "OMLoginViewController.h"
#import "OMInputAlertViewController.h"
#import "OMCompletedViewController.h"

// facebook settings
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// twitter settings
#import <TwitterKit/TwitterKit.h>

// model
#import "OMUser.h"

// JPush
#import <JPUSHService.h>

@interface OMAccountsViewController ()<OMInputAlertViewControllerDelegate, UITabBarControllerDelegate>

@property(nonatomic, strong) OMUser *user;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, assign) NSInteger clickFlag;

@end

@implementation OMAccountsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _user = [[OMUser alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set title
    self.tabBarItem.title = @"Account";
    self.navigationItem.title = @"My Account";
   
    self.tableViewAccount.scrollEnabled = NO;
    self.tableViewAccount.separatorColor = OMSeparatorLineColor;
    
    [OMCustomTool setcornerOfView:self.logButton withRadius:5 color:ClearBackGroundColor];
    
    [self LoadHeaderView];
    [self loadData];
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

#pragma mark - Load Data
- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               };
    
    // request user specific informations
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DETAIL_INFORMATION dateBlock:^(id dateBlock) {
        if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            NSLog(@"User CurrentAccount Specific Info : %@", dateBlock);
            NSMutableDictionary *dic = [OMCustomTool OMDeleteAllNullValueInDic:dateBlock[@"Data"][@"MemberInfo"]];
            
            for (NSString *key in dic) {
                [self.user setValue:dic[key] forKey:key];
            }
            
            // reload data
            [self.tableViewAccount reloadData];
            
            // remove loading view
            [self.hud hide:YES];
        }
        else{
            NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
        }
    }];
}

#pragma mark - Load HeaderView
- (void)LoadHeaderView{
    
    self.tableViewAccount.tableHeaderView = self.headerView;
    
    [OMCustomTool setcornerOfView:self.userIconImg withRadius:30.0 color:ClearBackGroundColor];
    
}

#pragma mark - TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1)
    {
        return 3;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        
    }
    cell.textLabel.tag = 500 + indexPath.row;
    // set image for userIcon imageView
    [OMCustomTool SDSetImageView:self.userIconImg withURLString:self.user.portrait andPlacehoderImageName:USER_ICONIMG];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Username";
            cell.tag = 1000;
            cell.detailTextLabel.text = self.user.name;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Paypal";
            cell.detailTextLabel.text = self.user.paypalAccount;
            cell.tag = 1001;
        }
        else{
            cell.textLabel.text = @"Balance";
            cell.accessoryType = 1;
            CGFloat total = [self.user.balance floatValue] + [self.user.frozenAmount floatValue] + [self.user.ongoingCash floatValue];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"US$: %.2f", total];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"My Social Account";
            cell.accessoryType = 1;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.user.snsAccountCount];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Ongoing Tasks";
            cell.accessoryType = 1;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.user.taskDoingCount];
        }
        else{
            cell.textLabel.text = @"Completed Tasks";
            cell.accessoryType = 1;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.user.taskFinishedCount];
        }
    }
    else{
        cell.textLabel.text = @"Contact us";
        cell.accessoryType = 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // instantiate an inputAlertView and set it transparent
    OMInputAlertViewController *inputAlertView = [[OMInputAlertViewController alloc] init];
    // set delegate
    inputAlertView.delegate = self;
    inputAlertView.view.backgroundColor = DefaultBackgroundColor;
    inputAlertView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            // user name show alert
            self.clickFlag = 0;
            inputAlertView.titleLabel.text = @"Please Input Your Name:";
            [self presentViewController:inputAlertView animated:YES completion:^{
                // set information
                inputAlertView.view.superview.backgroundColor = [UIColor clearColor];
                
            }];
        }
        else if (indexPath.row == 1)
        {
            // paypal show alert
            self.clickFlag = 1;
            inputAlertView.titleLabel.text = @"Please Input Your PayPal Account:";
            [self presentViewController:inputAlertView animated:YES completion:^{
                // set information
                inputAlertView.view.superview.backgroundColor = [UIColor clearColor];
                
            }];
        }
        else{
            // balance number jump to ..
            OMBalanceDetailViewController *balanceVC = [[OMBalanceDetailViewController alloc] init];
            balanceVC.income = self.user.balance;
            [self.navigationController pushViewController:balanceVC animated:YES];
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            
            [self loadData];
            // Authorized Social Account jump to ..
            OMMySocialAccountViewController *myAccountVC = [[OMMySocialAccountViewController alloc] init];
            
            [self.navigationController pushViewController:myAccountVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            // Ongoing Task jump to ..
            [self.tabBarController setSelectedIndex:2];
        }
        else{
            // Completed Tasks jump to ..
            OMCompletedViewController *completedVC = [[OMCompletedViewController alloc] init];
            [self.navigationController pushViewController:completedVC animated:YES];
        }
    }
    else{
        // Contact us jump to contact us
        OMContactusViewController *contactVC = [[OMContactusViewController alloc] init];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
}

#pragma mark - Logout Button Action
- (IBAction)logoutButtonAction:(id)sender {
    
    [self.hud show:YES];
    
    NSDictionary *paramDic = @{@"memberUid" : [SETTINGs objectForKey:OM_USER_UID],
                               @"jpushCode" : [JPUSHService registrationID]
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_DELETE_JPUSH_RION dateBlock:^(id dateBlock) {
        
        NSLog(@"delete register informations return data : %@", dateBlock);
        
        [self.hud hide:YES];
    }];
    
    
    [self deleteAllUserInfoLocal];
    [self clearAllLoginInformations];
    
    // send logout notification to global
    [NOTIFICATION_SETTING postNotificationName:OMUSER_STATUS_LOGOUT object:nil];
    
    
}

- (void)clearAllLoginInformations{
    
    // logout for twitter
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
    
    // logoout for facebook
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logOut];
}

- (void)deleteAllUserInfoLocal{
    
    // remove local data
    [SETTINGs removeObjectForKey:OM_USER_ID];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OM_USER_NAME];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OM_USER_LOGINKEY];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OM_USER_UID];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OM_USER_ICON];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OM_USER_SHOP_STATUS];
    [SETTINGs synchronize];
}

#pragma mark - InputAlertView Delegate Method
- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    NSIndexPath *indexPath = [self.tableViewAccount indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableViewAccount cellForRowAtIndexPath:indexPath];
    
    if (self.clickFlag == 0) {
        // update name to server
        // save local file and post to server GCD
#if 1
        NSDictionary *dic = @{@"id" :   [SETTINGs objectForKey:OM_USER_ID],
                              @"name" : strValue
                              };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:dic API:API_S_UPDATE dateBlock:^(id dateBlock) {
            // varify update result
            [OMCustomTool OMshowAlertViewWithMessage:@"Update your name succeed!" fromViewController:self];
            cell.detailTextLabel.text = strValue;
            [self loadData];
        }];
#endif
        
    }
    else
    {
        // update paypal account to server
        // save local file and post to server GCD
        NSDictionary *dic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                              @"paypalAccount" : strValue
                              };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:dic API:API_S_UPDATE dateBlock:^(id dateBlock) {
            // varify update result
            [OMCustomTool OMshowAlertViewWithMessage:@"Update your paypal account succeed!" fromViewController:self];
            cell.detailTextLabel.text = strValue;
            [self loadData];
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
