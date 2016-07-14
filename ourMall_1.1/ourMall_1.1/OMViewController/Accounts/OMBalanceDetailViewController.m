//
//  OMBalanceDetailViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMBalanceDetailViewController.h"
#import "OMBalanceCell.h"

#import "OMAcountDetailViewController.h"
#import "OMWithdrawViewController.h"

#import "OMAccountDetail.h"

@interface OMBalanceDetailViewController ()

@property(nonatomic, strong) NSMutableArray *accountArray;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSString *balance;
@property(nonatomic, strong) NSString *frozenAmout;
@property(nonatomic, strong) NSString *totalCash;
@property(nonatomic, strong) NSString *ongoingCash;

@end

@implementation OMBalanceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _accountArray = [NSMutableArray array];
        _income = [NSString string];
        _balance = [NSString string];
        _frozenAmout = [NSString string];
        _totalCash = [NSString string];
        _ongoingCash = [NSString string];
    }
    return self;  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Balance";
    
    [self LoadHeaderView];
    self.tableViewBalance.rowHeight = 90;
    self.tableViewBalance.bounces = NO;
    self.tableViewBalance.separatorColor = OMSeparatorLineColor;
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self loadData];
}

#pragma mark - Load Data
- (void)loadData{
    
    NSDictionary *paramDicAll = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                 };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDicAll API:API_S_DETAIL_INFORMATION dateBlock:^(id dateBlock) {
        NSLog(@"With_Draw account data : %@", dateBlock);
        NSMutableDictionary *dic = [OMCustomTool OMDeleteAllNullValueInDic:dateBlock[@"Data"][@"MemberInfo"]];
        NSString *str1 =  self.balance = [dic objectForKey:@"balance"];
        NSString *str2 =  self.ongoingCash = [dic objectForKey:@"ongoingCash"];
        NSString *str3 =  self.frozenAmout = [dic objectForKey:@"frozenAmount"];
        NSString *str4 =  self.totalCash = [dic objectForKey:@"totalGetCash"];
        self.accountArray = [NSMutableArray arrayWithObjects:str1, str2, str3, str4, nil];
        
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewBalance WithCurrentArray:self.accountArray];
        [self.tableViewBalance reloadData];
        
        // remove loading view
        [self.hud hide:YES];
    }];
    
}

#pragma mark - Load HeaderView
- (void)LoadHeaderView{
    
    [OMCustomTool setcornerOfView:self.withdrawalBtn withRadius:7 color:WhiteBackGroudColor];
    self.withdrawalBtn.layer.borderWidth = 2;
    
    self.tableViewBalance.tableHeaderView = self.headerView;
}


#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // withdraw balance
    self.balanceLabel.text = [self OMString:self.accountArray.firstObject];
    
    if (indexPath.row == 0) {
        
        static NSString *reuse = @"OMBalanceCell";
        OMBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        // withdrawing amounts
        cell.titleLabel.text = @"Ongoing Amounts(US$)";
        cell.numberLabel.text = [self OMString:[self.accountArray objectAtIndex:1]];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *reuse = @"OMBalanceCell";
        OMBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        // withdrawing amounts
        cell.titleLabel.text = @"Withdrawing Amounts(US$)";
        cell.numberLabel.text = [self OMString:[self.accountArray objectAtIndex:2]];
        cell.nextImg.hidden = YES;
        return cell;
        
        
    }
    else if (indexPath.row == 2){
        
        static NSString *reuse = @"OMBalanceCell";
        OMBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        // withdrawn amounts
        cell.titleLabel.text = @"Withdrawn Amounts(US$)";
        cell.numberLabel.text = [self OMString:[self.accountArray objectAtIndex:3]];
        cell.nextImg.hidden = YES;
        return cell;
    }
    else{
        
        static NSString *reuse = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.textLabel.text = @"Account Details";
        cell.accessoryType = 1;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        OMAcountDetailViewController *detailVC = [[OMAcountDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (indexPath.row == 0)
    {
        [self.tabBarController setSelectedIndex:2];
    }
    else{
        
    }
}

#pragma mark - Withdraw Action Push
- (IBAction)withdrawalBtnAction:(id)sender {
    
    OMWithdrawViewController *withdrawVC = [[OMWithdrawViewController alloc] init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
    
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
