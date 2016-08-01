//
//  OMShopAddProductVC.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopAddProductVC.h"
#import "OMEditViewController.h"
#import "OMProductDetail.h"
#import "OMAddProductCell.h"

@interface OMShopAddProductVC ()

@property(nonatomic,  strong)             UIView         *topContainerView;

@property (nonatomic, strong)             NSString       *transportStr;
@property (nonatomic, strong)             MBProgressHUD  *hud;
@property (nonatomic, strong)             NSMutableArray *searchArray;
@property (nonatomic, strong)             NSMutableArray *historyArray;

@property(nonatomic, assign)              NSInteger      searchTimes;
@property(nonatomic, assign)              NSInteger      maxLineNumber;

@property(nonatomic, assign)              NSInteger      pageValue;
@property(nonatomic, strong)              NSString       *currentPageNumber;
@property(nonatomic, strong)              NSString       *totalCount;
@property(nonatomic, strong)              NSString       *perPageCount;
@property(nonatomic, assign)              CGFloat        maxPageNumber;

@end

@implementation OMShopAddProductVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchArray = [NSMutableArray array];
        
        // ensure not null
        _transportStr = @" ";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.searchTextField setValue:OMCustomRedColor forKeyPath:@"_placeholderLabel.textColor"];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    [self.hud show:YES];
    
    // search & history part
    [self loadSearchPart];
    [self loadHistoryPart];
    
    // mjrefresh -- load more datas
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    [self loadData];
}


#pragma mark - Search & History Part
- (void)loadSearchPart{
    
    // search box
    self.navigationItem.titleView = self.searchView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)loadHistoryPart{
    // most history record number : 10
    
    self.topContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 10)];
    self.topContainerView.backgroundColor = WhiteBackGroudColor;
    
    self.historyArray = [NSMutableArray arrayWithArray:[SETTINGs objectForKey:OMHISTORY_ADD_ARRAY]];
    
    // control history view hide and show
    if (self.historyArray.count == 0) {
        self.topContainerView.hidden = YES;
        self.topContainerView = nil;
    }
    else{
        self.topContainerView.hidden = NO;
    }
    
    for (NSInteger i = 0; i < self.historyArray.count; i++) {
        
        NSString *hisTag = self.historyArray[i];
        static UIButton *recordBtn = nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect rect = [hisTag boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        if (i == 0) {
            btn.frame =CGRectMake(10, 30, rect.size.width + 5, rect.size.height);
        }
        else
        {
            
            CGFloat restWidth = SCREEN_WIDTH - 30 - recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (restWidth >= rect.size.width + 5) {
                btn.frame = CGRectMake(recordBtn.frame.origin.x + recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, rect.size.width + 5, rect.size.height);
            }else{
                self.maxLineNumber ++;
                btn.frame = CGRectMake(10, recordBtn.frame.origin.y + recordBtn.frame.size.height + 10, rect.size.width + 5, rect.size.height);
            }
        }
        // button layout
        btn.backgroundColor = WhiteBackGroudColor;
        btn.layer.borderColor = OMCustomRedColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [btn setTintColor:OMCustomRedColor];
        btn.titleLabel.textAlignment = 1;
        
        [btn setTitle:hisTag forState:UIControlStateNormal];
        [self.topContainerView addSubview:btn];
        
        recordBtn = btn;
        recordBtn.tag = 1000 + i;
        [recordBtn addTarget:self action:@selector(searchAndSortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // descriptions
    // history label
    UILabel *historyLabel = [[UILabel alloc] init];
    historyLabel.backgroundColor = WhiteBackGroudColor;
    historyLabel.frame = CGRectMake(10, 0, 100, 30);
    historyLabel.text = @"History";
    historyLabel.textColor = [UIColor blackColor];
    historyLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.topContainerView addSubview:historyLabel];
    
    // history item (buttons)
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(SCREEN_WIDTH - 100, (self.maxLineNumber + 1) * 20 + (self.maxLineNumber + 1) * 10 + 25, 80, 20);
    [self.topContainerView addSubview:clearButton];
    [clearButton setTitle:@"× clear all" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
    clearButton.layer.cornerRadius = 5;
    clearButton.layer.masksToBounds = YES;
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
    [clearButton addTarget:self action:@selector(clearHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // separator line
    UIView *separatorView = [[UIView alloc] init];
    separatorView.frame = CGRectMake(10, (self.maxLineNumber + 1) * 20 + (self.maxLineNumber + 1) * 10 + 25 + 25, SCREEN_WIDTH - 10, 1);
    separatorView.backgroundColor = OMSeparatorLineColor;
    [self.topContainerView addSubview:separatorView];
    
    
    self.topContainerView.frame = CGRectMake(10, 100, SCREEN_WIDTH - 20, (self.maxLineNumber + 1) * 20 + (self.maxLineNumber + 1) * 10 + 50);
    self.searchTableView.tableHeaderView = self.topContainerView;
    [self.searchTableView reloadData];
}


#pragma mark - Return Keyboard
- (void)keyboardHide:(UITapGestureRecognizer *)tap{
    
    [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchButtonClickedAction];
    return YES;
}

#pragma mark - Search Action
- (IBAction)searchButtonClickedAction{
    
    [self.hud show:YES];
    
    // history settings
    if (![self.searchTextField.text isEqualToString:@""] && ![self.historyArray containsObject:self.searchTextField.text]) {
        
        if (self.historyArray.count > 9) {
            
            [self.historyArray insertObject:self.searchTextField.text atIndex:0];
            [self.historyArray removeObject:self.historyArray[10]];
            
        }
        else{
            
            [self.historyArray insertObject:self.searchTextField.text atIndex:0];
        }
        
        // save in local file
        NSArray *tempArr = [NSArray arrayWithArray:self.historyArray];
        [SETTINGs setValue:tempArr forKey:OMHISTORY_ADD_ARRAY];
        [SETTINGs synchronize];
        
        // lose first responser
        [self.searchTextField resignFirstResponder];
        
        [self loadData];
        [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
        self.topContainerView = nil;
        [self loadHistoryPart];
    }
    else{
        // search content null
        
        self.searchTableView.tableHeaderView = nil;
        [self loadData];
        [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
}

- (void)clearHistoryAction:(UIButton *)btn{
    
    [SETTINGs removeObjectForKey:OMSEARCH_ADD_TIMES];
    [SETTINGs synchronize];
    [SETTINGs removeObjectForKey:OMHISTORY_ADD_ARRAY];
    [SETTINGs synchronize];
    
    // refresh UI
    self.topContainerView = nil;
    [self loadHistoryPart];
    
    self.searchTableView.tableHeaderView = nil;
    [self.searchTableView reloadData];
}


- (void)searchAndSortAction:(UIButton *)btn{
    
    [self.hud show:YES];
    
    self.searchTextField.text = [self.historyArray objectAtIndex:btn.tag - 1000];
    [self.historyArray exchangeObjectAtIndex:btn.tag - 1000 withObjectAtIndex:0];
    
    [self loadData];
    [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    // save in local file
    NSArray *tempArr = [NSArray arrayWithArray:self.historyArray];
    [SETTINGs setValue:tempArr forKey:OMHISTORY_ADD_ARRAY];
    [SETTINGs synchronize];
    
    // refresh UI
    self.topContainerView = nil;
    [self loadHistoryPart];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"OMAddProductCell";
    OMAddProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    OMProductDetail *model = [self.searchArray objectAtIndex:indexPath.row];
    
    [OMCustomTool SDSetImageView:cell.productImg withURLString:model.imageUrl andPlacehoderImageName:OMPORDUCT_ICONIMG];
    cell.descLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"US$ %@", [self OMString:model.defaultPrice]];
    if ([[self OMString:model.hasSelected] integerValue] == 1) {
        cell.statusImg.image = IMAGE(@"haveAdded.png");
    }
    else{
        cell.statusImg.image = IMAGE(@"addNew.png");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OMProductDetail *model = [self.searchArray objectAtIndex:indexPath.row];
    OMEditViewController *editVC = [[OMEditViewController alloc] init];
    editVC.myProductId = model.productId;
    editVC.myHeadStr = model.name;
    editVC.myHasSelected = model.hasSelected;
    
    // hasSelected = 1 : selected  2 : unSelected
    if ([self OMString:model.hasSelected].integerValue == 1) {
        // interface syn
        editVC.verifyFlag = @"2";
    }
    else{
        // interface syn
        editVC.verifyFlag = @"1";
    }
    
    [self.navigationController pushViewController:editVC animated:YES];
}


#pragma mark - Load Data
- (void)loadData{

    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"keywords" : self.searchTextField.text,
                               @"page" : @"1"
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_Product_SearchList dateBlock:^(id dateBlock) {
    
        NSLog(@"add list : %@", dateBlock);
        
        self.currentPageNumber = dateBlock[@"Data"][@"Pagination"][@"page"];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.maxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.pageValue = [self.currentPageNumber integerValue];
        
        NSArray *arr = [NSArray array];
        arr = dateBlock[@"Data"][@"Products"];
        
        NSMutableArray *normallArr = [NSMutableArray array];
        
        for (NSString *tempStr in arr) {
            NSDictionary *dic = [self dictionaryWithJsonString:tempStr];
            [normallArr addObject:dic];
        }
        
        self.searchArray = [OMProductDetail ModelArr_With_DictionaryArr:normallArr];
        
        [self.searchTableView reloadData];
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.searchTableView WithCurrentArray:self.searchArray];
        
        // hide loading
        [self.hud hide:YES];
    }];
}

- (void)loadMoreData{
    
    self.pageValue ++;
    NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"keywords" : self.searchTextField.text,
                               @"page"   : pageCount
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_Product_SearchList dateBlock:^(id dateBlock) {
        if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            // add new data
            NSArray *arr = [NSArray array];
            arr = dateBlock[@"Data"][@"Products"];
            
            NSMutableArray *normallArr = [NSMutableArray array];
            
            for (NSString *tempStr in arr) {
                NSDictionary *dic = [self dictionaryWithJsonString:tempStr];
                [normallArr addObject:dic];
            }
           
            NSMutableArray *newArr = [NSMutableArray array];
            
            newArr = [OMProductDetail ModelArr_With_DictionaryArr:normallArr];
            for (OMProductDetail *model in newArr) {
                [self.searchArray addObject:model];
            }
            
            [self.searchTableView reloadData];
            
        }
        else{
            NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
        }
    }];
    
    [self.searchTableView.mj_footer endRefreshing];
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
