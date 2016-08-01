//
//  OMCateSearchViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMCateSearchViewController.h"
#import "OMCategoryInputViewController.h"
#import "OMCategoryProductCell.h"
#import "OMProductModel.h"
#import <MJRefresh.h>

@interface OMCateSearchViewController ()<OMCategoryInputViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray *searchArr;
@property(nonatomic, strong) NSMutableArray *selectedArr;
@property(nonatomic, strong) MBProgressHUD *hud;


@property(nonatomic, assign)              NSInteger      pageValue;
@property(nonatomic, strong)              NSString       *currentPageNumber;
@property(nonatomic, strong)              NSString       *totalCount;
@property(nonatomic, strong)              NSString       *perPageCount;
@property(nonatomic, assign)              CGFloat        maxPageNumber;

@end

@implementation OMCateSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchArr = [NSMutableArray array];
        _selectedArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
    [self loadData];
    
    [self.searchTableView setEditing:YES animated:YES];
    
    // mjrefresh -- load more datas
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

- (void)setUI{
    
    [OMCustomTool setcornerOfView:self.bottomLeftBtn withRadius:5 color:ClearBackGroundColor];
    [OMCustomTool setcornerOfView:self.bottomRightBtn withRadius:5 color:ClearBackGroundColor];
}

#pragma mark - LoadData
- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"categoryId" : [self OMString:self.model.categoryId],
                               @"page" : @"1"
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
        
        NSLog(@"category products list : %@", dateBlock);
        self.searchArr = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        
        // calculate max page numbers
        self.currentPageNumber = dateBlock[@"Data"][@"Pagination"][@"page"];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.maxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.pageValue = [self.currentPageNumber integerValue];

        [self.searchTableView reloadData];
        [self.hud hide:YES];
    }];
}

- (void)loadMoreData{
    
    if (self.pageValue < self.maxPageNumber) {
        
        self.pageValue ++;
        NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
        
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"categoryId" : [self OMString:self.model.categoryId],
                                   @"page"   : pageCount
                                   };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
            if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
                
                // add new data
                NSArray *arr = [NSArray array];
                arr = dateBlock[@"Data"][@"Products"];
                
                NSMutableArray *newArr = [NSMutableArray array];
                newArr = [OMProductModel ModelArr_With_DictionaryArr:arr];
                
                for (OMProductModel *model in newArr) {
                    [self.searchArr addObject:model];
                }
                
                [self.searchTableView reloadData];
                
            }
            else{
                NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
            }
        }];
        
    }
    else{
        
    }
    
    [self.searchTableView.mj_footer endRefreshing];
}


- (IBAction)reDefineNameAction:(id)sender {
    
    OMCategoryInputViewController *inputVC = [[OMCategoryInputViewController alloc] init];
    inputVC.delegate = self;
    
    inputVC.view.backgroundColor = DefaultBackgroundColor;
    inputVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:inputVC animated:YES completion:^{
        
     inputVC.view.superview.backgroundColor = [UIColor clearColor];
    }];
}


- (IBAction)searchBtnClickedAction:(id)sender {
    
    [self.hud show:YES];
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"categoryId" : self.model.categoryId,
                               @"page" : @"1",
                               @"nameSearch" : self.searchTextField.text
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
       
        NSLog(@"category products search list : %@", dateBlock);
        self.searchArr = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        [self.searchTableView reloadData];
        
        
        
        [self.hud hide:YES];
    }];
    
}


#pragma mark - Input Delegate Method
- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"name" : strValue,
                               @"categoryId" : [self OMString:self.model.categoryId]
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_CATEGORY_ADD dateBlock:^(id dateBlock) {
        
    }];
    
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMCategoryProductCell";
    OMCategoryProductCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    OMProductModel *model = [self.searchArr objectAtIndex:indexPath.row];
    
    cell.decLabel.text = model.name;
    [OMCustomTool SDSetImageView:cell.productImg withURLString:model.imgUrl andPlacehoderImageName:OMPORDUCT_ICONIMG];
    cell.priceLabel.text = [self OMString:model.price];
    
    if ([self OMString:model.idOfCategory].integerValue == 1) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.selectedArr addObject:self.searchArr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [self.selectedArr addObject:self.searchArr[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.selectedArr removeObject:self.searchArr[indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}


#pragma mark - Save Selected Model Array
- (IBAction)saveAction:(id)sender {
    
    NSString *tranStr = @"";
    
    if (self.selectedArr.count > 0) {
        
        for (OMProductModel *model in self.selectedArr) {
            
            tranStr = [tranStr stringByAppendingString:[NSString stringWithFormat:@"%@,", model.idValue]];
        }
        tranStr = [tranStr substringToIndex:tranStr.length - 1];
    }
    


    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"categoryId" : self.model.categoryId,
                               @"sponsorProductIdArray" : tranStr
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PROofCATE_ADD dateBlock:^(id dateBlock) {
        
        [OMCustomTool OMshowAlertViewWithMessage:@"Add Succeed!" fromViewController:self];
        
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
