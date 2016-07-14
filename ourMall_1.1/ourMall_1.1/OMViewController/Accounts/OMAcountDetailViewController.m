//
//  OMAcountDetailViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMAcountDetailViewController.h"

#import "OMAccountDetailCell.h"
#import "OMAccountDetail.h"

@interface OMAcountDetailViewController ()

@property(nonatomic, strong) NSMutableArray *allArray;
@property(nonatomic, strong) NSMutableArray *incomeArray;
@property(nonatomic, strong) NSMutableArray *withdrawArray;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMAcountDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        [_headSegmentView setSelectedSegmentIndex:0];
        _allArray = [NSMutableArray array];
        _incomeArray = [NSMutableArray array];
        _withdrawArray = [NSMutableArray array];
    }
    return self;  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Account Details";
    [self LoadHeaderView];
    [self.tableViewDetail registerNib:[UINib nibWithNibName:@"OMAccountDetailCell" bundle:nil] forCellReuseIdentifier:@"OMAccountDetailCell"];
    self.tableViewDetail.rowHeight = 70.0;
    self.tableViewDetail.bounces = NO;
    
    [self loadAllData];
    
    // show loading View
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

#pragma mark - Load Data
- (void)loadAllData{
    
    NSDictionary *paramDicAll = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                  };
    // all part
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDicAll API:API_S_ACCOUNT_DETAIL dateBlock:^(id dateBlock) {
        self.allArray = [OMAccountDetail ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"AccountDetails"]];
        NSLog(@"ALL DATA : %@", dateBlock[@"Data"][@"AccountDetails"]);
        
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewDetail WithCurrentArray:self.allArray];
        [self.tableViewDetail reloadData];
        
        // remove loading View
        [self.hud hide:YES];
    }];
    
    [self.tableViewDetail reloadData];
}

- (void)loadIncomeData{
    
    NSDictionary *paramDicIncome = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                     @"tab" : @"income"
                                     };
    // income part
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDicIncome API:API_S_ACCOUNT_DETAIL dateBlock:^(id dateBlock) {
        self.incomeArray = [OMAccountDetail ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"AccountDetails"]];
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewDetail WithCurrentArray:self.incomeArray];
        [self.tableViewDetail reloadData];
        
        NSLog(@"INCOME DATA : %@", dateBlock[@"Data"][@"AccountDetails"]);
    }];
    
    [self.tableViewDetail reloadData];
}

- (void)loadWithdrawData{
    
    NSDictionary *paramDicWithdraw = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                       @"tab" : @"withdraw"
                                       };
    // withdraw part
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDicWithdraw API:API_S_ACCOUNT_DETAIL dateBlock:^(id dateBlock) {
        self.withdrawArray = [OMAccountDetail ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"AccountDetails"]];
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewDetail WithCurrentArray:self.withdrawArray];
        [self.tableViewDetail reloadData];
        
        NSLog(@"WITHDRAW DATA : %@", dateBlock[@"Data"][@"AccountDetails"]);
    }];
    
    [self.tableViewDetail reloadData];
}

#pragma mark - Load HeaderView
- (void)LoadHeaderView{
    
    self.headSegmentView.tintColor = DefaultRedColor;
    [self.headSegmentView addTarget:self action:@selector(segementPressedAction:) forControlEvents:UIControlEventValueChanged];
    
    self.tableViewDetail.tableHeaderView = self.headerView;
    
}

#pragma mark - SegmentController Method
- (void)segementPressedAction:(UISegmentedControl *)seg{

    if ([seg selectedSegmentIndex] == 0) {
        [self loadAllData];
    }
    else if ([seg selectedSegmentIndex] == 1)
    {
        [self loadIncomeData];
    }
    else{
        [self loadWithdrawData];
    }
}

#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.headSegmentView.selectedSegmentIndex == 0) {
        return self.allArray.count;
    }
    else if (self.headSegmentView.selectedSegmentIndex == 1)
    {
        return self.incomeArray.count;
    }
    else{
        return self.withdrawArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMAccountDetailCell";
    OMAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OMAccountDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    
    if (self.headSegmentView.selectedSegmentIndex == 0) {
        OMAccountDetail *detail = [self.allArray objectAtIndex:indexPath.row];
        cell.timeLabel.text = [self OMString:detail.date];
        if ([detail.symbol integerValue] == 1) {
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS +%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomGreenColor;
        }
        else{
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS -%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomRedColor;
        }
        cell.statusLabel.text = detail.remark;
    }
    else if (self.headSegmentView.selectedSegmentIndex == 1)
    {
        OMAccountDetail *detail = [self.incomeArray objectAtIndex:indexPath.row];
        cell.timeLabel.text = [self OMString:detail.date];
        if ([detail.symbol integerValue] == 1) {
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS +%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomGreenColor;
        }
        else{
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS -%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomRedColor;
        }
        cell.statusLabel.text = detail.remark;
    }else{
        OMAccountDetail *detail = [self.withdrawArray objectAtIndex:indexPath.row];
        cell.timeLabel.text = [self OMString:detail.date];
        if ([detail.symbol integerValue] == 1) {
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS +%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomGreenColor;
        }
        else{
            cell.timeValueLabel.text = [NSString stringWithFormat:@"USS -%@", detail.amount];
            cell.timeValueLabel.textColor = OMCustomRedColor;
        }
        cell.statusLabel.text = detail.remark;
    }
    
    return cell;
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
