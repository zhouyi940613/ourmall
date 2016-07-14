//
//  OMCompletedViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/30.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import <MJRefresh.h>
#import "OMCompletedViewController.h"
#import "OMPromotionCell.h"
#import "OMPromotionModel.h"

@interface OMCompletedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *taskArray;

@property(nonatomic, assign) NSInteger pageValue;
@property(nonatomic, strong) NSString *currentPageNumber;
@property(nonatomic, strong) NSString *totalCount;
@property(nonatomic, strong) NSString *perPageCount;
@property(nonatomic, assign) CGFloat maxPageNumber;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMCompletedViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _taskArray = [NSMutableArray array];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Completed Tasks";
    
    self.tableViewTasks.rowHeight = 130.0;
    
    // refresh data
    self.tableViewTasks.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self loadData];
}

#pragma mark - Load Data
- (void)loadData{
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"status" : @"5"
                               };
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_TASK_LIST dateBlock:^(id dateBlock) {
        self.taskArray = [OMPromotionModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"MyTasks"]];
        self.currentPageNumber = [self OMString:dateBlock[@"Data"][@"Pagination"][@"page"]];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.maxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.pageValue = [self.currentPageNumber integerValue];
        
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewTasks WithCurrentArray:self.taskArray];
        [self.tableViewTasks reloadData];
        
        // hide loading view
        [self.hud hide:YES];
    }];
}

- (void)loadMoreData{
    
    if (self.pageValue < self.maxPageNumber) {
        
        self.pageValue ++;
        
        NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
        
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"page" : pageCount,
                                   @"status" : @"5"
                                   };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_TASK_LIST dateBlock:^(id dateBlock) {
            NSDictionary *dic = dateBlock;
            NSArray *dateArr = dic[@"Data"][@"MyTasks"];
            
            NSMutableArray *newArr = [NSMutableArray array];
            newArr = [OMPromotionModel ModelArr_With_DictionaryArr:dateArr];
            for (OMPromotionModel *model in newArr) {
                [self.taskArray addObject:model];
            }
            
            [self.tableViewTasks reloadData];
        }];
    }
    else{
        
    }
    [self.tableViewTasks.mj_footer endRefreshing];
}

#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMPromotionCell";
    OMPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    OMPromotionModel *model = [self.taskArray objectAtIndex:indexPath.row];
    
    [OMCustomTool SDSetImageView:cell.productImg withURLString:model.taskImgUrl
          andPlacehoderImageName:USER_ICONIMG];
    cell.titleLabel.text = model.taskName;
    cell.priceLabel.text = [self OMString:model.applyCash];
    
    // platform select
    if ([model.totalPlatforms integerValue] == 1) {
        cell.FBPlatformImg.image = IMAGE(@"f.png");
    }
    else if ([model.totalPlatforms integerValue] == 2)
    {
        cell.FBPlatformImg.image = IMAGE(@"t.png");
    }
    
    [cell.shareBtn setTitle:@"Complete" forState:UIControlStateNormal];
    [cell.shareBtn setTitleColor:OMCustomGreenColor forState:UIControlStateNormal];
    cell.shareBtn.backgroundColor = WhiteBackGroudColor;
    
    cell.statusLabel.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
