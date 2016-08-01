//
//  OMShopProductViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopProductViewController.h"
#import "OMShopAddProductVC.h"
#import "OMEditViewController.h"
#import "OMProductCategoryViewController.h"
#import "OMCateSearchViewController.h"
#import "OMCategoryUpdateViewController.h"

#import "OMShopProductCell.h"
#import "OMCategoryEditCell.h"
#import "OMProductModel.h"
#import "OMCategoryModel.h"

#import "LrdOutputView.h"
#import <MJRefresh.h>

@interface OMShopProductViewController ()<UITableViewDelegate, UITableViewDataSource, LrdOutputViewDelegate,OMCategoryUpdateViewControllerDelegate>

@property(nonatomic, strong) UISegmentedControl *naviSeg;

@property(nonatomic, strong) UIScrollView *mainContainerScrollView;
@property(nonatomic, strong) UITableView *productTableView;
@property(nonatomic, strong) UITableView *categoryTableView;

@property(nonatomic, strong) NSMutableArray *onSaleArray;
@property(nonatomic, strong) NSMutableArray *offSaleArray;
@property(nonatomic, strong) NSMutableArray *productArray;
@property(nonatomic, strong) NSMutableArray *categoryArray;

@property(nonatomic, strong) UIView *onSaleTitleBgView;
@property(nonatomic, strong) UIView *offSaleTitleBgView;
@property(nonatomic, strong) UIButton *onSaleTitleBtn;
@property(nonatomic, strong) UIButton *offSaleTitleBtn;
@property(nonatomic, strong) UIView *leftSeparatorView;
@property(nonatomic, strong) UIView *rightSeparatorView;

@property(nonatomic, strong) UIView *productAddBgView;
@property(nonatomic, strong) UIView *categoryAddBgView;
@property(nonatomic, strong) UIButton *productAddBtn;
@property(nonatomic, strong) UIButton *categoryAddBtn;

@property(nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, assign) NSInteger flag;
@property(nonatomic, assign) BOOL onSaleFlag;
@property(nonatomic, assign) BOOL offSaleFlag;

@property(nonatomic, assign)              NSInteger      pageValue;
@property(nonatomic, assign)              CGFloat        maxPageNumber;

@property(nonatomic, assign)              NSInteger      onSalePageValue;
@property(nonatomic, assign)              CGFloat        onSaleMaxPageNumber;
@property(nonatomic, assign)              NSInteger      offSalePageValue;
@property(nonatomic, assign)              CGFloat        offSaleMaxPageNumber;

@property(nonatomic, strong)              NSString       *currentPageNumber;
@property(nonatomic, strong)              NSString       *totalCount;
@property(nonatomic, strong)              NSString       *perPageCount;

@end

@implementation OMShopProductViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _productArray = [NSMutableArray array];
        _categoryArray = [NSMutableArray array];
        _onSaleArray = [NSMutableArray array];
        _offSaleArray = [NSMutableArray array];
        _flag = 0;
        _onSaleFlag = YES;
        _offSaleFlag = NO;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.mainContainerScrollView setContentOffset:CGPointMake(0, 0)];
    [self.naviSeg setSelectedSegmentIndex:0];
    
    [self loadDataCategories];
}

#pragma mark - LoadUI
- (void)UIInit{
    
    // segment title text attribute
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             WhiteBackGroudColor,
                             UITextAttributeTextColor,  
                             WhiteBackGroudColor,
                             UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(1, 0)],
                             UITextAttributeTextShadowOffset,
                             [UIFont systemFontOfSize:15],
                             UITextAttributeFont,
                             nil];
    
    self.naviSeg = [[UISegmentedControl alloc] initWithItems:@[@"Products", @"Categories"]];
    self.naviSeg.frame = CGRectMake(100, 10, 10, 30);
    [self.naviSeg setTitleTextAttributes:textDic forState:UIControlStateNormal];
    self.navigationItem.titleView = self.naviSeg;
    [self.naviSeg addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventValueChanged];
    
    
    // main frame settings
    self.mainContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIView *leftContainerView = [[UIView alloc] initWithFrame:self.view.frame];
    leftContainerView.backgroundColor = WhiteBackGroudColor;
    UIView *rightContainerView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    rightContainerView.backgroundColor = WhiteBackGroudColor;
    
    NSArray *viewArray = @[leftContainerView, rightContainerView];
    
    for (UIView *item in viewArray) {
        [self.mainContainerScrollView addSubview:item];
    }
    
    // product title background views
    self.onSaleTitleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 50)];
//    self.onSaleTitleBgView.backgroundColor = [UIColor redColor];
    self.offSaleTitleBgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 50)];
//    self.offSaleTitleBgView.backgroundColor = [UIColor greenColor];
    
    [leftContainerView addSubview:self.onSaleTitleBgView];
    [leftContainerView addSubview:self.offSaleTitleBgView];
    
    // product bottom background view
    self.productAddBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 60, SCREEN_WIDTH, 60)];
    [leftContainerView addSubview:self.productAddBgView];
    self.productAddBgView.backgroundColor = WhiteBackGroudColor;
    
    UIImageView *bottomShadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [bottomShadowImg setImage:IMAGE(@"footer_top")];
    [self.productAddBgView addSubview:bottomShadowImg];
    
    // category bottom background view
    self.categoryAddBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 60, SCREEN_WIDTH, 60)];
    [rightContainerView addSubview:self.categoryAddBgView];
    self.categoryAddBgView.backgroundColor = WhiteBackGroudColor;
    
    UIImageView *bottomShadowImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [bottomShadowImg2 setImage:IMAGE(@"footer_top")];
    [self.categoryAddBgView addSubview:bottomShadowImg2];
    
    // tableViews
    self.productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 110) style:UITableViewStylePlain];
    [leftContainerView addSubview:self.productTableView];
    self.productTableView.backgroundColor = WhiteBackGroudColor;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60) style:UITableViewStylePlain];
    [rightContainerView addSubview:self.categoryTableView];
    self.categoryTableView.backgroundColor = WhiteBackGroudColor;
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.mainContainerScrollView];
    
    // load spe
    [self loadSpecificWidgets];
}

- (void)loadSpecificWidgets{
    
    // product title buttons
    self.onSaleTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.onSaleTitleBtn.frame = CGRectMake(20, 5, SCREEN_WIDTH / 2 - 20 * 2, 44);
    [self.onSaleTitleBtn setTitle:@"" forState:UIControlStateNormal];
    [self.onSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.onSaleTitleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.onSaleTitleBtn addTarget:self action:@selector(onSaleBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.onSaleTitleBgView addSubview:self.onSaleTitleBtn];
    
    self.leftSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH / 2, 1)];
    [self.onSaleTitleBgView addSubview:self.leftSeparatorView];
    self.leftSeparatorView.backgroundColor = OMCustomRedColor;
    
    self.offSaleTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.offSaleTitleBtn.frame = CGRectMake(20, 5, SCREEN_WIDTH / 2 - 20 * 2, 44);
    [self.offSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitle:@"" forState:UIControlStateNormal];
    self.offSaleTitleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.offSaleTitleBtn addTarget:self action:@selector(offSaleBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.offSaleTitleBgView addSubview:self.offSaleTitleBtn];
    
    self.rightSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH / 2, 1)];
    [self.offSaleTitleBgView addSubview:self.rightSeparatorView];
    self.rightSeparatorView.backgroundColor = OMSeparatorLineColor;
    
    
    // product bottom button
    self.productAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productAddBtn.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, 20, 150, 30);
    self.productAddBtn.backgroundColor = OMCustomRedColor;
    [self.productAddBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [self.productAddBtn setTitle:@"+ Add Product" forState:UIControlStateNormal];
    self.productAddBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [OMCustomTool setcornerOfView:self.productAddBtn withRadius:5 color:ClearBackGroundColor];
    [self.productAddBtn addTarget:self action:@selector(productAddBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.productAddBgView addSubview:self.productAddBtn];
    
    // category bottom button
    self.categoryAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryAddBtn.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, 20, 80, 30);
    self.categoryAddBtn.backgroundColor = OMCustomRedColor;
    [self.categoryAddBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [self.categoryAddBtn setTitle:@"+ Add" forState:UIControlStateNormal];
    self.categoryAddBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [OMCustomTool setcornerOfView:self.categoryAddBtn withRadius:5 color:ClearBackGroundColor];
    [self.categoryAddBtn addTarget:self action:@selector(categoryAddBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryAddBgView addSubview:self.categoryAddBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteBackGroudColor;
    
    [self UIInit];
    
    [self.naviSeg setSelectedSegmentIndex:0];
    
    // mjrefresh -- load more datas
    self.productTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadDataOnSale];
    [self loadDataCategories];
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}


#pragma mark - Change TableView Container
- (void)changeTableView:(UISegmentedControl *)seg{
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self.mainContainerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            [self.mainContainerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - Change Product TableView Data
- (void)onSaleBtnClickedAction:(UIButton *)btn{
    
    [self.hud show:YES];
   
    self.leftSeparatorView.backgroundColor = OMCustomRedColor;
    self.rightSeparatorView.backgroundColor = OMSeparatorLineColor;
    [self.onSaleTitleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self loadDataOnSale];
    
    self.offSaleFlag = NO;
    self.onSaleFlag = YES;
    
    self.pageValue = self.onSalePageValue;
    self.maxPageNumber = self.onSaleMaxPageNumber;
    
}

- (void)offSaleBtnClickedAction:(UIButton *)btn{
    
     [self.hud show:YES];
    
    self.leftSeparatorView.backgroundColor = OMSeparatorLineColor;
    self.rightSeparatorView.backgroundColor = OMCustomRedColor;
    [self.onSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self loadDataOffSale];
    
    self.onSaleFlag = NO;
    self.offSaleFlag = YES;
    
    self.pageValue = self.offSalePageValue;
    self.maxPageNumber = self.offSaleMaxPageNumber;
}

#pragma mark - Add Buttton Clicked Actions
- (void)productAddBtnClickedAction:(UIButton *)btn{
    
    OMShopAddProductVC *addVC = [[OMShopAddProductVC alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)categoryAddBtnClickedAction:(UIButton *)btn{
    
    // motify view
    OMCategoryUpdateViewController *updateVC = [[OMCategoryUpdateViewController alloc] init];
    updateVC.delegate = self;
    updateVC.view.backgroundColor = DefaultBackgroundColor;
    updateVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:updateVC animated:YES completion:^{
       updateVC.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

- (void)saveBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"name" : strValue
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_CATEGORY_ADD dateBlock:^(id dateBlock) {
        
        [self loadDataCategories];
        [OMCustomTool OMshowAlertViewWithMessage:@"Add Succeed!" fromViewController:self];
    }];
    
}


#pragma mark - Require Data
- (void)loadDataOnSale{
    
    [self.hud show:YES];
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"page" : @"1",
                               @"status" : @"1"
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
        
        NSLog(@"onsale list : %@", dateBlock);
        
        // calculate max page numbers
        self.currentPageNumber = dateBlock[@"Data"][@"Pagination"][@"page"];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.onSaleMaxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.onSalePageValue = [self.currentPageNumber integerValue];
        
        // number settings
        NSString *onSaleStr = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        NSInteger onSaleCount = onSaleStr.integerValue;
        
        NSString *totalSaleStr = dateBlock[@"Data"][@"Pagination"][@"allTotalCount"];
        NSInteger totalCount = totalSaleStr.integerValue;
        
        NSInteger offSaleCount = totalCount - onSaleCount;
        
        NSString *onSaleTitle = [NSString stringWithFormat:@"On Sale(%ld)", (long)onSaleCount];
        NSString *offSaleTitle = [NSString stringWithFormat:@"Pull off shelves(%ld)", (long)offSaleCount];
        
        [self.onSaleTitleBtn setTitle:onSaleTitle forState:UIControlStateNormal];
        [self.offSaleTitleBtn setTitle:offSaleTitle forState:UIControlStateNormal];
        
        self.onSaleArray = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        
        self.productArray = [NSMutableArray arrayWithArray:self.onSaleArray];
        
        [self.productTableView reloadData];
        
        [self.hud hide:YES];
    }];
}

- (void)loadDataOffSale{
    
    [self.hud show:YES];
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"page" : @"1",
                               @"status" : @"2"
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
        
         NSLog(@"offsale list : %@", dateBlock);
        
        // calculate max page numbers
        self.currentPageNumber = dateBlock[@"Data"][@"Pagination"][@"page"];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.offSaleMaxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.offSalePageValue = [self.currentPageNumber integerValue];
        
        // number settings
        NSString *offSaleStr = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        NSInteger offSaleCount = offSaleStr.integerValue;
        
        NSString *totalSaleStr = dateBlock[@"Data"][@"Pagination"][@"allTotalCount"];
        NSInteger totalCount = totalSaleStr.integerValue;
        
        NSInteger onSaleCount = totalCount - offSaleCount;
        
        NSString *onSaleTitle = [NSString stringWithFormat:@"On Sale(%ld)", onSaleCount];
        NSString *offSaleTitle = [NSString stringWithFormat:@"Pull off shelves(%ld)", offSaleCount];
        
        [self.onSaleTitleBtn setTitle:onSaleTitle forState:UIControlStateNormal];
        [self.offSaleTitleBtn setTitle:offSaleTitle forState:UIControlStateNormal];
        
        self.offSaleArray = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        self.productArray = [NSMutableArray arrayWithArray:self.offSaleArray];
        
        [self.productTableView reloadData];
        
        [self.hud hide:YES];
    }];

}

- (void)loadMoreData{
    
    if (self.pageValue == 0) {
        self.pageValue = self.onSalePageValue;
        self.maxPageNumber = self.onSaleMaxPageNumber;
    }
    
    if (self.pageValue < self.maxPageNumber) {
        
        self.pageValue ++;
        NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
        
        NSDictionary *paramDic = @{};
        
        if (self.onSaleFlag == YES && self.offSaleFlag == NO) {
            
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"status" : @"1",
                         @"page"   : pageCount
                         };
        }
        else if (self.onSaleFlag == NO && self.offSaleFlag == YES)
        {
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"status" : @"2",
                         @"page"   : pageCount
                         };
        }
        else{
            
        }
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
            if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
                
                // add new data
                NSArray *arr = [NSArray array];
                arr = dateBlock[@"Data"][@"Products"];
                
                NSMutableArray *newArr = [NSMutableArray array];
                newArr = [OMProductModel ModelArr_With_DictionaryArr:arr];
                
                if (self.onSaleFlag == YES && self.offSaleFlag == NO) {
                    
                    for (OMProductModel *model in newArr) {
                        [self.onSaleArray addObject:model];
                    }
                    
                    self.productArray = [NSMutableArray arrayWithArray:self.onSaleArray];
                }
                else if (self.onSaleFlag == NO && self.offSaleFlag == YES)
                {
                    for (OMProductModel *model in newArr) {
                        [self.offSaleArray addObject:model];
                    }
                    
                    self.productArray = [NSMutableArray arrayWithArray:self.offSaleArray];
                }
                else{
                    
                }
                
                [self.productTableView reloadData];
            }
            else{
                NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
            }
        }];
        
    }
    else{
        
    }
    
    [self.productTableView.mj_footer endRefreshing];
}


- (void)progressHideDelay{
    
    [self.hud hide:YES];
}

- (void)loadDataCategories{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_CATEGORIES_LIST dateBlock:^(id dateBlock) {
        self.categoryArray = [OMCategoryModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Category"][@"list"]];
        
        [self.categoryTableView reloadData];
    }];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.productTableView) {
        
        return self.productArray.count;
    }
    else if (tableView == self.categoryTableView){
        
        return self.categoryArray.count;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.productTableView) {
        return 130.0;
    }
    else if (tableView == self.categoryTableView)
    {
        return 50;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.productTableView) {
        
        static NSString *reuse = @"OMShopProductCell";
        OMShopProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        OMProductModel *model = [self.productArray objectAtIndex:indexPath.row];
        
        [OMCustomTool SDSetImageView:cell.productImg withURLString:model.imgUrl andPlacehoderImageName:OMPORDUCT_ICONIMG];
        
        cell.descLabel.text = model.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.price]];
        cell.profitLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.profit]];
        [cell.operationBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.operationBtn.tag = indexPath.row + 500;
        
        // set cell unenable click
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else if (tableView == self.categoryTableView)
    {
        static NSString *reuse = @"OMCategoryEditCell";
        OMCategoryEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        
        OMCategoryModel *model = [self.categoryArray objectAtIndex:indexPath.row];
        cell.categoryNameLabel.text = model.name;
        cell.itemsNumberLabel.text = [self OMString:model.count];
        cell.deleteBtn.tag = 700 + indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        return 0;
    }
}

- (void)deleteAction:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Are you sure of deleting this category?" preferredStyle:1];
    
    UIAlertAction *alertActionLeft = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        OMCategoryModel *model = [self.categoryArray objectAtIndex:btn.tag - 700];
        [self.categoryArray removeObject:model];
        [self.categoryTableView reloadData];
        
        // interface call
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"sponsorCategoryId" : model.categoryId
                                   };
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_CATEGORY_DELETE dateBlock:^(id dateBlock) {
            
        }];
        
    }];
    UIAlertAction *alertActionRight = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [alert addAction:alertActionLeft];
    [alert addAction:alertActionRight];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.categoryTableView) {
        
        OMCateSearchViewController *searchVC = [[OMCateSearchViewController alloc] init];
        OMCategoryModel *model = [self.categoryArray objectAtIndex:indexPath.row];
        searchVC.model = model;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }
    else{
        
    }
}

- (void)operationAction:(UIButton *)btn{
    
    self.flag = btn.tag - 500;
    
    OMProductModel *model = [self.productArray objectAtIndex:(btn.tag - 500)];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag - 500 inSection:0];
    
    CGPoint oldPoint = [btn convertPoint:btn.frame.origin toView:nil];
    
    oldPoint.x = btn.center.x;
    
    oldPoint.x = oldPoint.x + 15;
    oldPoint.y = oldPoint.y - 90;
    
    // show menu
    CGFloat x = oldPoint.x;
    CGFloat y = oldPoint.y + btn.bounds.size.height + 10;
    
    LrdCellModel *editItem = [[LrdCellModel alloc] initWithTitle:@"Edit" imageName:@""];
    LrdCellModel *categoryItem = [[LrdCellModel alloc] initWithTitle:@"Category" imageName:@""];
    LrdCellModel *offItem = [[LrdCellModel alloc] initWithTitle:@"Off the shelf" imageName:@""];
    LrdCellModel *onItem = [[LrdCellModel alloc] initWithTitle:@"On sale" imageName:@""];
    
    LrdCellModel *deleteItem = [[LrdCellModel alloc] initWithTitle:@"Delete" imageName:@""];
    LrdCellModel *moveUpItem = [[LrdCellModel alloc] initWithTitle:@"Move up" imageName:@""];
    LrdCellModel *moveDownItem = [[LrdCellModel alloc] initWithTitle:@"Move down" imageName:@""];
    
    
    NSArray *itemsArray = [NSArray array];
    
    if ([[self OMString:model.isOnSale] integerValue] == 1) {
    
        itemsArray = @[editItem, categoryItem, offItem, deleteItem, moveUpItem, moveDownItem];
    }
    else{
        itemsArray = @[editItem, categoryItem, onItem, deleteItem, moveUpItem, moveDownItem];
    }
    
    if (oldPoint.y > 350) {
        // top
        LrdOutputView *outputView = [[LrdOutputView alloc] initWithDataArray:itemsArray origin:CGPointMake(x, y) width:120 height:30 direction:kLrdOutputViewDirectionTop];
        outputView.delegate = self;
        [outputView pop];
    }
    else{
        // down
        LrdOutputView *outputView = [[LrdOutputView alloc] initWithDataArray:itemsArray origin:CGPointMake(x, y) width:120 height:30 direction:kLrdOutputViewDirectionDown];
        outputView.delegate = self;
        [outputView pop];
    }
}

#pragma mark - DropMenu Delegate Method
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath{
    
    OMProductModel *model = [self.productArray objectAtIndex:self.flag];
    
    if (indexPath.row == 0) {
        // edit
        OMEditViewController *editVC = [[OMEditViewController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
        editVC.myProductId = model.productId;
        editVC.myHeadStr = model.name;
        editVC.verifyFlag = @"0";
        editVC.myHasSelected = model.hasSelected;
    }
    else if (indexPath.row == 1)
    {
        // category
        OMProductCategoryViewController *cateVC = [[OMProductCategoryViewController alloc] init];
        [self.navigationController pushViewController:cateVC animated:YES];
        cateVC.productId = model.productId;
        cateVC.headStr = model.name;
        cateVC.hasSelected = model.hasSelected;
        
    }
    else if (indexPath.row == 2)
    {
        // on sale or off shelves
        if ([[self OMString:model.isOnSale] integerValue] == 1) {
            // operation : off sale
//            [self.productArray removeObjectAtIndex:self.flag];
//            [self.productTableView reloadData];
            
            // off sale interface
            NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                       @"productId" : [self OMString:model.productId],
                                       @"type" : @"1",
                                       @"doType" : @"1"
                                       };
            [self sendOperationResultToServer:paramDic];
        }
        else{
            // operation : on sale
//            [self.productArray removeObjectAtIndex:self.flag];
//            [self.productTableView reloadData];
            
            // on sale interface
            NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                       @"productId" : [self OMString:model.productId],
                                       @"type" : @"2",
                                       @"doType" : @"2"
                                       };
            [self sendOperationResultToServer:paramDic];
        }
    }
    else if (indexPath.row == 3)
    {
        // delete
//        [self.productArray removeObjectAtIndex:self.flag];
//        [self.productTableView reloadData];
    
        // synchronization server
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"productId" : [self OMString:model.productId],
                                   @"type" : [self OMString:model.isOnSale],
                                   @"doType" : @"4"
                                   };
        
        [self sendOperationResultToServer:paramDic];
    }
    else if (indexPath.row == 4)
    {
        // move up
        if (self.flag > 0) {
            
//            [self.productArray exchangeObjectAtIndex:self.flag withObjectAtIndex:self.flag - 1];
//            [self.productTableView reloadData];
        }
        else{
            
        }
        // synchronization server
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"productId" : [self OMString:model.productId],
                                   @"type" : [self OMString:model.isOnSale],
                                   @"doType" : @"5"
                                   };
        [self sendOperationResultToServer:paramDic];
    }
    else{
        // move down
        
        if (self.flag < self.productArray.count - 1) {
            
//            [self.productArray exchangeObjectAtIndex:self.flag withObjectAtIndex:self.flag + 1];
//            [self.productTableView reloadData];
        }
        else{
            
        }
        // synchronization server
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"productId" : [self OMString:model.productId],
                                   @"type" : [self OMString:model.isOnSale],
                                   @"doType" : @"6"
                                   };
        [self sendOperationResultToServer:paramDic];
    }
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)sendOperationResultToServer:(NSDictionary *)paramDIc{
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDIc API:API_SHOP_Product_EDIT dateBlock:^(id dateBlock) {
        
        if ([[paramDIc objectForKey:@"type"] isEqualToString:@"1"]) {
            [self loadDataOnSale];
        }
        else{
            [self loadDataOffSale];
        }
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
