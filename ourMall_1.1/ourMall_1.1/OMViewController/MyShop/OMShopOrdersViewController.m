//
//  OMShopOrdersViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopOrdersViewController.h"
#import "OMOrderDetailViewController.h"

#import "OMProductCell.h"
#import "OMOrderModel.h"
#import "OMOrderDetail.h"

@interface OMShopOrdersViewController ()

@property(nonatomic, strong) NSMutableArray *ordersSessionArr;
@property(nonatomic, strong) NSMutableArray *ordersRowArray;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMShopOrdersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _ordersSessionArr = [NSMutableArray array];
        _ordersRowArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Orders";
    
    [self loadData];
    
    [self.titleSegment addTarget:self action:@selector(segmentClickedEvent:) forControlEvents:UIControlEventValueChanged];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

#pragma mark - LoadData
- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"page" : @"1"
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_ORDERS_LIST dateBlock:^(id dateBlock) {
        NSLog(@"order list : %@", dateBlock);
        self.ordersSessionArr = [OMOrderModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"OrderList"]];
        
        for (OMOrderModel *model in self.ordersSessionArr) {
            [self.ordersRowArray addObject:model.orderPlus];
        }
        
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *orderTempArr = [NSMutableArray array];
        
        for (NSArray *arr in self.ordersRowArray) {
            
            tempArr = [OMOrderDetail ModelArr_With_DictionaryArr:arr];
            [orderTempArr addObject:tempArr];
        }
        
        self.ordersRowArray = [NSMutableArray arrayWithArray:orderTempArr];
        
        [self.orderTableView reloadData];
        
        [self.hud hide:YES];
    }];
    
}

#pragma mark  -LoadData With Choice
- (void)loadDataWithChoice:(NSInteger)choice{
    
    NSDictionary *paramDic0 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                @"page" : @"1"
                                };
    
    NSDictionary *paramDic1 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                @"status" : @"1",
                                @"page" : @"1"
                                };
    NSDictionary *paramDic2 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                @"status" : @"2",
                                @"page" : @"1"
                                };
    NSDictionary *paramDic3 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                @"status" : @"3",
                                @"page" : @"1"
                                };
    NSDictionary *paramDic9 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                @"status" : @"9",
                                @"page" : @"1"
                                };
    
    NSDictionary *paramDic = [NSDictionary dictionary];
    
    switch (choice) {
        case 0:
            paramDic = [NSDictionary dictionaryWithDictionary:paramDic0];
            break;
        case 1:
            paramDic = [NSDictionary dictionaryWithDictionary:paramDic1];
            break;
        case 2:
            paramDic = [NSDictionary dictionaryWithDictionary:paramDic2];
            break;
        case 3:
            paramDic = [NSDictionary dictionaryWithDictionary:paramDic3];
            break;
        case 4:
            paramDic = [NSDictionary dictionaryWithDictionary:paramDic9];
            break;
            
        default:
            break;
    }
    
    self.ordersRowArray = [NSMutableArray array];
    self.ordersSessionArr = [NSMutableArray array];
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_ORDERS_LIST dateBlock:^(id dateBlock) {
        NSLog(@"selected order list : %@", dateBlock);
        self.ordersSessionArr = [OMOrderModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"OrderList"]];
        
        // not found settings
        [self setExtraCellLineHidden:self.orderTableView WithCurrentArray:self.ordersSessionArr];
        
        for (OMOrderModel *model in self.ordersSessionArr) {
            [self.ordersRowArray addObject:model.orderPlus];
        }
        
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *orderTempArr = [NSMutableArray array];
        
        for (NSArray *arr in self.ordersRowArray) {
            
            tempArr = [OMOrderDetail ModelArr_With_DictionaryArr:arr];
            [orderTempArr addObject:tempArr];
        }
        
        self.ordersRowArray = [NSMutableArray arrayWithArray:orderTempArr];
        
        [self.orderTableView reloadData];
        
        [self.hud hide:YES];
    }];
}


#pragma mark - Segment Action
- (void)segmentClickedEvent:(UISegmentedControl *)seg{
    
    [self.hud show:YES];
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self loadDataWithChoice:0];
            break;
        case 1:
            [self loadDataWithChoice:1];
            break;
        case 2:
            [self loadDataWithChoice:2];
            break;
        case 3:
            [self loadDataWithChoice:3];
            break;
        case 4:
            [self loadDataWithChoice:4];
            break;
        default:
            break;
    }
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.ordersSessionArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OMOrderModel *model = [self.ordersSessionArr objectAtIndex:section];
    
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    sectionHeaderView.backgroundColor = WhiteBackGroudColor;
    
    UILabel *numDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 20)];
    numDesLabel.text = @"NO:";
    numDesLabel.font = [UIFont systemFontOfSize:15.0];
    numDesLabel.textColor = [UIColor lightGrayColor];
    [sectionHeaderView addSubview:numDesLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 140, 20)];
    numLabel.textColor = OMCustomRedColor;
    numLabel.font = [UIFont systemFontOfSize:16.0];
    [sectionHeaderView addSubview:numLabel];
    numLabel.text = model.code;
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 5, 80, 20)];
    statusLabel.textColor = OMCustomRedColor;
    statusLabel.font = [UIFont systemFontOfSize:16.0];
    [sectionHeaderView addSubview:statusLabel];
    
    switch ([model.status integerValue]) {
        case 1:
            statusLabel.text = @"Unpaid";
            break;
        case 2:
            statusLabel.text = @"Paid";
            break;
        case 3:
            statusLabel.text = @"Shipped";
            break;
        case 9:
            statusLabel.text = @"Cancelled";
            break;
            
        default:
            break;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 1)];
    bottomView.backgroundColor = OMSeparatorLineColor;
    [sectionHeaderView addSubview:bottomView];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    OMOrderModel *model = [self.ordersSessionArr objectAtIndex:section];
    
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionFooterView.backgroundColor = WhiteBackGroudColor;
    
    UILabel *profitDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    profitDesLabel.text = @"Profit:";
    profitDesLabel.font = [UIFont systemFontOfSize:15.0];
    profitDesLabel.textColor = [UIColor lightGrayColor];
    [sectionFooterView addSubview:profitDesLabel];
    
    UILabel *profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 60, 20)];
    profitLabel.textColor = OMCustomRedColor;
    profitLabel.font = [UIFont systemFontOfSize:16.0];
    [sectionFooterView addSubview:profitLabel];
    profitLabel.text = [NSString stringWithFormat:@"$ %@", [self OMString:model.profit]];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 20)];
    amountLabel.textColor = OMCustomRedColor;
    amountLabel.font = [UIFont systemFontOfSize:16.0];
    [sectionFooterView addSubview:amountLabel];
    amountLabel.text = [NSString stringWithFormat:@"$ %@", [self OMString:model.totalAmount]];

    UILabel *amountDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70 - 10 - 100, 5, 100, 20)];
    amountDesLabel.text = @"Total Amount:";
    amountDesLabel.textColor = [UIColor lightGrayColor];
    amountDesLabel.font = [UIFont systemFontOfSize:15.0];
    [sectionFooterView addSubview:amountDesLabel];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 10)];
    bottomView.backgroundColor = OMSeparatorLineColor;
    [sectionFooterView addSubview:bottomView];
    
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = [self.ordersRowArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"OMProductCell";
    OMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    if (self.ordersRowArray.count > 0) {
        
        OMOrderDetail *model = [[self.ordersRowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [OMCustomTool SDSetImageView:cell.productImg withURLString:model.img andPlacehoderImageName:OMPORDUCT_ICONIMG];
        cell.productDesLabel.text = model.name;
        cell.productPriceLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.price]];
        cell.productCountLabel.text = [NSString stringWithFormat:@"X%@", [self OMString:model.quantity]];
    }
    else{
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OMOrderModel *model = [self.ordersSessionArr objectAtIndex:indexPath.section];
    OMOrderDetailViewController *detailVC = [[OMOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.model = model;
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
