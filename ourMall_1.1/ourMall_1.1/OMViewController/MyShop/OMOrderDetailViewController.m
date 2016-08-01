//
//  OMOrderDetailViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/23.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMOrderDetailViewController.h"
#import "OMProductCell.h"

@interface OMOrderDetailViewController ()

@property(nonatomic, strong) NSMutableArray *listArr;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMOrderDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _listArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Dox any additional setup after loading the view from its nib.
    
    self.title = @"My Order";
    
    [self loadUI];
    [self loadData];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

- (void)loadUI{
    
    self.detailTableView.tableHeaderView = self.headerView;
    self.detailTableView.tableFooterView = self.footerView;
    self.detailTableView.bounces = NO;
}

- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"code" : [self OMString:self.model.code]
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_ORDER_DETAIL dateBlock:^(id dateBlock) {
        NSDictionary *dic = dateBlock[@"Data"][@"OrderDetail"];
        
        // header View
        self.numberLabel.text = dic[@"code"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@", dic[@"createData"]];
        self.nameLabel.text = dic[@"shopAddressName"];
        self.adressLabel.text = dic[@"shopAddress"];
        self.totalPriceLabel.text = [self OMString:dic[@"totalAmount"]];
        
        switch ([self.model.status integerValue]) {
            case 1:
                self.statusLabel.text = @"Unpaid";
                break;
            case 2:
                self.statusLabel.text = @"Paid";
                break;
            case 3:
                self.statusLabel.text = @"Shipped";
                break;
            case 9:
                self.statusLabel.text = @"Cancelled";
                break;
                
            default:
                break;
        }
        
        // footer View
        self.totalLabel.text = [self OMString:dic[@"itemTotal"]];
        self.shipLabel.text = [self OMString:dic[@"shopping"]];
        self.orderTotalLabel.text = [self OMString:dic[@"orderTotal"]];
        self.profitLabel.text = [self OMString:dic[@"profit"]];
        
        self.listArr = [OMOrderDetail ModelArr_With_DictionaryArr:dic[@"orderPlus"]];
        
        [self.detailTableView reloadData];
        
        [self.hud hide:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMProductCell";
    OMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    if (self.listArr.count > 0) {
        
        OMOrderDetail *model = [self.listArr objectAtIndex:indexPath.row];
        
        [OMCustomTool SDSetImageView:cell.productImg withURLString:model.img andPlacehoderImageName:OMPORDUCT_ICONIMG];
        cell.productDesLabel.text = model.name;
        cell.productPriceLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.price]];
        cell.productCountLabel.text = [NSString stringWithFormat:@"X%@", [self OMString:model.quantity]];
    }
    else{
        
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
