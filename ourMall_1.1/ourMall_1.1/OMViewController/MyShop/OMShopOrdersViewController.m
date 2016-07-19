//
//  OMShopOrdersViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopOrdersViewController.h"

#import "OMProductCell.h"
#import "OMOrderModel.h"

@interface OMShopOrdersViewController ()

@property(nonatomic, strong) NSMutableArray *ordersArray;

@end

@implementation OMShopOrdersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _ordersArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    [self.titleSegment addTarget:self action:@selector(segmentClickedEvent:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - LoadData
- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"status" : @"1",
                               @"page" : @"1"
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_ORDERS_LIST dateBlock:^(id dateBlock) {
        NSLog(@"order list : %@", dateBlock);
        self.ordersArray = [OMOrderModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"OrderList"]];
        
        [self.orderTableView reloadData];
    }];
    
}

- (void)segmentClickedEvent:(UISegmentedControl *)seg{
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

- (void)loadDataWithChoice:(NSInteger)choice{
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ordersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"OMProductCell";
    OMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    OMOrderModel *model = [self.ordersArray objectAtIndex:indexPath.row];
    
    /*
     @property (weak, nonatomic) IBOutlet UILabel *productNoLabel;
     @property (weak, nonatomic) IBOutlet UILabel *productStatusLabel;
     @property (weak, nonatomic) IBOutlet UIView *productImg;
     @property (weak, nonatomic) IBOutlet UILabel *productDesLabel;
     @property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
     @property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
     @property (weak, nonatomic) IBOutlet UILabel *productProfitLabel;
     @property (weak, nonatomic) IBOutlet UILabel *productAmoutLabel;
     */
    
    cell.productNoLabel.text = [self OMString:model.code];
    
    [OMCustomTool SDSetImageView:cell.productImg withURLString:model.orderPlus[0][@"img"] andPlacehoderImageName:OMPORDUCT_ICONIMG];
    
    switch ([model.status integerValue]) {
        case 1:
            cell.productStatusLabel.text = @"Unpaid";
            break;
        case 2:
            cell.productStatusLabel.text = @"Paid";
            break;
        case 3:
            cell.productStatusLabel.text = @"Shipped";
            break;
        case 9:
            cell.productStatusLabel.text = @"Cancelled";
            break;
            
        default:
            break;
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
