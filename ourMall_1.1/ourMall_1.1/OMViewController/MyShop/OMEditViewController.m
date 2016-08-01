//
//  OMEditViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMEditViewController.h"
#import "OMProductAttributeModel.h"
#import "OMProductAtributeCell.h"
#import "OMProductCategoryViewController.h"
#import "OMProfitAlertViewController.h"

@interface OMEditViewController ()<OMProfitAlertViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray *attributeArray;
@property(nonatomic, strong) NSString *headerImgUrlStr;
@property(nonatomic, strong) NSString *headerNameStr;
@property(nonatomic, strong) NSString *categoryStr;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMEditViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _attributeArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Put On Sale";
    
    [self loadHeaderView];
    [self loadData];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
//    [self.hud show:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self loadData];
}


#pragma mark - Load View & Data
- (void)loadHeaderView{
    
    self.editTableView.tableHeaderView = self.headerView;
    
    [OMCustomTool setcornerOfView:self.profitSetBtn withRadius:5 color:ClearBackGroundColor];
    [OMCustomTool setcornerOfView:self.onSaleOprationBtn withRadius:5 color:ClearBackGroundColor];
    if ([self.verifyFlag isEqualToString:@"1"]) {
        // title save
        [self.onSaleOprationBtn setTitle:@"+ Put on sale" forState:UIControlStateNormal];
    }
    else{
        // title put on sale
        [self.onSaleOprationBtn setTitle:@" Save " forState:UIControlStateNormal];
    }
}

- (void)loadData{
    
    [self.hud show:YES];
    
    NSDictionary *paramDic = @{};
    
    // verifyFlag:  0 : reds's products
    //              1 : uncheck products
    //              2 : checked products
    
    if ([self.verifyFlag isEqualToString:@"2"])
    {
        
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                     @"productId" : self.myProductId,
                     @"isEdit" : @"1"
                     };
    }
    else{
        
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                     @"productId" : self.myProductId
                     };
    }
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_DETAIL dateBlock:^(id dateBlock) {
        
        NSLog(@"edit data : %@", dateBlock);
        
        NSArray *verifyArr = dateBlock[@"Data"][@"Product"];
        if (verifyArr.count > 0) {
            
            self.attributeArray = [OMProductAttributeModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Product"][@"stocks"]];
            
            self.headerImgUrlStr = [NSString stringWithFormat:@"%@", dateBlock[@"Data"][@"Product"][@"imgUrl1"]];
            self.headerNameStr = [NSString stringWithFormat:@"%@", dateBlock[@"Data"][@"Product"][@"name"]];
            self.categoryStr = [NSString stringWithFormat:@"%@", dateBlock[@"Data"][@"Product"][@"productCategory"]];
        }
        
        // set value for header view
        [OMCustomTool SDSetImageView:self.headerImg withURLString:self.headerImgUrlStr andPlacehoderImageName:OMPORDUCT_ICONIMG];
        self.headerLabel.text = self.headerNameStr;
        
        [self.editTableView reloadData];
        [self.hud hide:YES];
    }];
}


#pragma mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        return 3;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        
        if (section == 0) {
            return 0;
        }
        else if (section == 1)
        {
            return 1;
        }
        else{
            if (self.attributeArray.count) {
                return self.attributeArray.count;
            }
            else{
                return 0;
            }
        }
    }
    else{
        if (section == 0) {
            return 0;
        }
        else{
            if (self.attributeArray.count) {
                return self.attributeArray.count;
            }
            else{
                return 0;
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        
        if (indexPath.section == 0) {
            return 0;
        }
        else if (indexPath.section == 1)
        {
            return 40.0;
        }
        else{
            return 140.0;
        }
    }
    else{
        
        if (indexPath.section == 0) {
            return 0;
        }
        else{
            return 140.0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        
        if (indexPath.section == 0) {
            return nil;
        }
        else if (indexPath.section == 1)
        {
            static NSString *reuse = @"reuse";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:reuse];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text  = @"Category";
            cell.detailTextLabel.text = self.categoryStr;
            //        if ([[self OMString:self.myHasSelected] integerValue] == 1) {
            //            cell.detailTextLabel.text = self.categoryStr;
            //        }
            //        else{
            //            if ([SETTINGs objectForKey:OMCACHE_SHOP_CATE_KEY]) {
            //                cell.detailTextLabel.text = [SETTINGs objectForKey:OMCACHE_SHOP_CATE_KEY];
            //            }
            //            else{
            //                cell.detailTextLabel.text = self.categoryStr;
            //            }
            //        }
            
            return cell;
        }
        else{
            static NSString *reuse = @"OMProductAtributeCell";
            OMProductAtributeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
            }
            
            OMProductAttributeModel *model = [self.attributeArray objectAtIndex:indexPath.row];
            
            cell.colorLabel.text = model.propertyValueString;
            
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price.floatValue];
            cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", model.setPrice.floatValue];
            cell.profitLabel.text = [NSString stringWithFormat:@"%.2f", model.profit.floatValue];
            
            cell.priceTextField.tag = 400 + indexPath.row;
            [cell.priceTextField addTarget:self action:@selector(getFinalStatus:) forControlEvents:UIControlEventEditingDidEnd];
            
            cell.stockLabel.text = [NSString stringWithFormat:@"stock:%@", [self OMString:model.quantity]];
            
            return cell;
        }
    }
    else{
        
        if (indexPath.section == 0) {
            return nil;
        }
        else
        {
            static NSString *reuse = @"OMProductAtributeCell";
            OMProductAtributeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
            }
            
            OMProductAttributeModel *model = [self.attributeArray objectAtIndex:indexPath.row];
            
            cell.colorLabel.text = model.propertyValueString;
            
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price.floatValue];
            cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", model.setPrice.floatValue];
            cell.profitLabel.text = [NSString stringWithFormat:@"%.2f", model.profit.floatValue];
            
            cell.priceTextField.tag = 400 + indexPath.row;
            [cell.priceTextField addTarget:self action:@selector(getFinalStatus:) forControlEvents:UIControlEventEditingDidEnd];
            
            cell.stockLabel.text = [NSString stringWithFormat:@"stock:%@", [self OMString:model.quantity]];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        
        if (indexPath.section == 0) {
            
        }
        else if (indexPath.section == 1)
        {
            OMProductCategoryViewController *cateVC = [[OMProductCategoryViewController alloc] init];
            [self.navigationController pushViewController:cateVC animated:YES];
            cateVC.productId = self.myProductId;
            cateVC.headStr = self.myHeadStr;
            cateVC.hasSelected = self.myHasSelected;
        }
        else{
            
        }
    }
    else{
        
    }
}


#pragma mark - Bottom Button Actions
- (IBAction)profitSetBtnAction:(id)sender {
    
    // get first line data and transmit to motify page
    if ([[self OMString:self.myHasSelected] integerValue] == 1) {
        // 3
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        OMProductAtributeCell *cell = [self.editTableView cellForRowAtIndexPath:indexPath];
        
        //    OMProductAttributeModel *model = [self.attributeArray objectAtIndex:indexPath.row];
        
        CGFloat margin = (cell.priceTextField.text.floatValue - cell.priceLabel.text.floatValue) / cell.priceLabel.text.floatValue;
        
        NSNumber *profitDefaultMargin = [NSNumber numberWithFloat:margin];
        NSNumber *profitDefaultValue = [NSNumber numberWithFloat:cell.priceTextField.text.floatValue - cell.priceLabel.text.floatValue];
        NSNumber *defaultPrice = [NSNumber numberWithFloat:cell.priceLabel.text.floatValue];
        
        OMProfitAlertViewController *profitVC = [[OMProfitAlertViewController alloc] init];
        profitVC.delegate = self;
        
        profitVC.view.backgroundColor = DefaultBackgroundColor;
        profitVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [NOTIFICATION_SETTING postNotificationName:@"modalityTransformValue" object:nil userInfo:@{@"margin" : profitDefaultMargin, @"value" : profitDefaultValue, @"defaultPrice" : defaultPrice}];
        
        
        [self presentViewController:profitVC animated:YES completion:^{
            profitVC.view.superview.backgroundColor = [UIColor clearColor];
            
        }];
    }
    else{
        // 2
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        OMProductAtributeCell *cell = [self.editTableView cellForRowAtIndexPath:indexPath];
        
        //    OMProductAttributeModel *model = [self.attributeArray objectAtIndex:indexPath.row];
        
        CGFloat margin = (cell.priceTextField.text.floatValue - cell.priceLabel.text.floatValue) / cell.priceLabel.text.floatValue;
        
        NSNumber *profitDefaultMargin = [NSNumber numberWithFloat:margin];
        NSNumber *profitDefaultValue = [NSNumber numberWithFloat:cell.priceTextField.text.floatValue - cell.priceLabel.text.floatValue];
        NSNumber *defaultPrice = [NSNumber numberWithFloat:cell.priceLabel.text.floatValue];
        
        OMProfitAlertViewController *profitVC = [[OMProfitAlertViewController alloc] init];
        profitVC.delegate = self;
        
        profitVC.view.backgroundColor = DefaultBackgroundColor;
        profitVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [NOTIFICATION_SETTING postNotificationName:@"modalityTransformValue" object:nil userInfo:@{@"margin" : profitDefaultMargin, @"value" : profitDefaultValue, @"defaultPrice" : defaultPrice}];
        
        
        [self presentViewController:profitVC animated:YES completion:^{
            profitVC.view.superview.backgroundColor = [UIColor clearColor];
            
        }];
    }
    
}


- (void)getFinalStatus:(UITextField *)textField{
    
    OMProductAttributeModel *model = [self.attributeArray objectAtIndex:textField.tag - 400];
    model.appendStr = model.propertyValue;
    model.appendStr = [model.appendStr stringByAppendingString:@"-|-"];
    model.appendStr = [model.appendStr stringByAppendingString:textField.text];
    
}

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    // strValue = profit
    
    for (OMProductAttributeModel *model in self.attributeArray) {
        model.profit = strValue;
        model.setPrice = [NSString stringWithFormat:@"%.2f", strValue.floatValue + model.price.floatValue];
        model.appendStr = model.propertyValue;
        model.appendStr = [model.appendStr stringByAppendingString:@"-|-"];
        model.appendStr = [model.appendStr stringByAppendingString:strValue];
    }
    
    [self.editTableView reloadData];
}

- (IBAction)onSaleBtnAction:(id)sender {
    
    NSString *tranStr = [NSString string];
    
    for (OMProductAttributeModel *model in self.attributeArray) {
        if (model.appendStr) {
            tranStr = [tranStr stringByAppendingString:[NSString stringWithFormat:@"%@,", model.appendStr]];
        }
        else{
            model.appendStr = [model.propertyValue stringByAppendingString:@"-|-"];
            model.appendStr = [model.appendStr stringByAppendingString:model.price];
            tranStr = [tranStr stringByAppendingString:[NSString stringWithFormat:@"%@,", model.appendStr]];
        }
    }
    
    tranStr = [tranStr substringToIndex:tranStr.length - 1];

    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"productId" : self.myProductId,
                               @"productPrice" : tranStr
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:@"api.mall.shop.sponsorproductadd" dateBlock:^(id dateBlock) {
       
        [OMCustomTool OMshowAlertViewWithMessage:@"Put on sale succeed!" fromViewController:self];
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
