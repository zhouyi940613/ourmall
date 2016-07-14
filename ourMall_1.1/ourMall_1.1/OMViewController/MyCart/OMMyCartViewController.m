//
//  OMMyCartViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import <MJRefresh.h>
// twitter settings
#import <TwitterKit/TwitterKit.h>

#import "OMMyCartViewController.h"
#import "OMHomeDetailViewController.h"

#import "OMPromotionCell.h"
#import "OMSelectItemCell.h"
#import "OMPromotionModel.h"

@interface OMMyCartViewController ()

@property(nonatomic, strong)    MBProgressHUD   *hud;

@property(nonatomic, assign)    NSInteger       statusFlag;
@property(nonatomic, assign)    NSInteger       platformFlag;
@property(nonatomic, assign)    BOOL            selectedStatus;
@property(nonatomic, assign)    BOOL            selectedPlatform;

@property(nonatomic, strong)    NSMutableArray  *allTaskArray;
@property(nonatomic ,strong)    NSMutableArray  *taskArray;

@property(nonatomic, assign)    NSInteger       pageValue;
@property(nonatomic, strong)    NSString        *currentPageNumber;
@property(nonatomic, strong)    NSString        *totalCount;
@property(nonatomic, strong)    NSString        *perPageCount;
@property(nonatomic, assign)    CGFloat         maxPageNumber;

@end

@implementation OMMyCartViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _selectedStatus = NO;
        _selectedPlatform = NO;
        _statusFlag = 0;
        _platformFlag = 0;
        _taskArray = [NSMutableArray array];
        _allTaskArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set title
    self.tabBarItem.title = @"Task";
    self.navigationItem.title = @"Ongoing Tasks";
    
    // register cell
    [self.tableViewPromotion registerNib:[UINib nibWithNibName:@"OMPromotionCell" bundle:nil] forCellReuseIdentifier:@"OMPromotionCell"];
    [self.statusCollectionView registerNib:[UINib nibWithNibName:@"OMSelectItemCell" bundle:nil] forCellWithReuseIdentifier:@"OMSelectItemCell"];
    [self.platformCollectionView registerNib:[UINib nibWithNibName:@"OMSelectItemCell" bundle:nil] forCellWithReuseIdentifier:@"OMSelectItemCell"];
    self.tableViewPromotion.rowHeight = 130.0;
    
    // refresh data
    self.tableViewPromotion.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableViewPromotion.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadHeaderView];
    [self loadSelectData];
}

#pragma mark - Refresh Data With Header and Footer
- (void)loadNewData{
    
    [self loadSelectData];
    [self.tableViewPromotion.mj_header endRefreshing];
}

#pragma mark - Load Data
- (void)loadSelectData{
    // add loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    NSDictionary *paramDic = [NSDictionary dictionary];
    
    if (self.statusFlag == 0 && self.platformFlag == 0) {
        // all status and all platform
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    }
    else if (self.platformFlag == 0 && self.statusFlag != 0)
    {
        // all platform and selected status
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                     @"status" : [NSString stringWithFormat:@"%ld", (long)self.statusFlag],
                     };
    }
    else if (self.statusFlag == 0 && self.platformFlag != 0)
    {
        // all status and selected platform
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                     @"platform" : [NSString stringWithFormat:@"%ld", (long)self.platformFlag]
                     };
    }
    else{
        // selected status and selected platform
        paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                     @"status" : [NSString stringWithFormat:@"%ld", (long)self.statusFlag],
                     @"platform" : [NSString stringWithFormat:@"%ld", (long)self.platformFlag]
                     };
    }
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_TASK_LIST dateBlock:^(id dateBlock) {
        // remove loading view
        [self.hud hide:YES];
        
        NSLog(@"My Select Task List : %@", dateBlock);
        self.taskArray = [OMPromotionModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"MyTasks"]];
        // calculate max page numbers
        self.currentPageNumber = dateBlock[@"Data"][@"Pagination"][@"page"];
        self.totalCount = dateBlock[@"Data"][@"Pagination"][@"totalCount"];
        self.perPageCount = dateBlock[@"Data"][@"Pagination"][@"rowsPerPage"];
        self.maxPageNumber = [self.totalCount integerValue] / [self.perPageCount integerValue] + 1;
        self.pageValue = [self.currentPageNumber integerValue];
        
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewPromotion WithCurrentArray:self.taskArray];
        [self.tableViewPromotion reloadData];
    }];
}

#pragma mark - Refresh Data With Footer
- (void)loadMoreData{
    
    // limit page counts increment
    if (self.pageValue < self.maxPageNumber) {
        self.pageValue ++;
        NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
        
        NSDictionary *paramDic = [NSDictionary dictionary];
        
        if (self.statusFlag == 0 && self.platformFlag == 0) {
            // all status and all platform
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"page" : pageCount};
        }
        else if (self.platformFlag == 0 && self.statusFlag != 0)
        {
            // all platform and selected status
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"page" : pageCount,
                         @"status" : [NSString stringWithFormat:@"%ld", (long)self.statusFlag],
                         };
        }
        else if (self.statusFlag == 0 && self.platformFlag != 0)
        {
            // all status and selected platform
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"page" : pageCount,
                         @"platform" : [NSString stringWithFormat:@"%ld", (long)self.platformFlag]
                         };
        }
        else{
            // selected status and selected platform
            paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                         @"page" : pageCount,
                         @"status" : [NSString stringWithFormat:@"%ld", (long)self.statusFlag],
                         @"platform" : [NSString stringWithFormat:@"%ld", (long)self.platformFlag]
                         };
        }
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_TASK_LIST dateBlock:^(id dateBlock) {
            // remove loading view
            [self.hud hide:YES];
            
            NSLog(@"My Select Task List : %@", dateBlock);
            
            NSDictionary *dic = dateBlock;
            NSArray *dateArr = dic[@"Data"][@"MyTasks"];
            NSMutableArray *newArr = [NSMutableArray array];
            newArr = [OMPromotionModel ModelArr_With_DictionaryArr:dateArr];
            for (OMPromotionModel *model in newArr) {
                [self.taskArray addObject:model];
            }
            
            // hide redundant separator lines
            [self setExtraCellLineHidden:self.tableViewPromotion WithCurrentArray:self.taskArray];
            [self.tableViewPromotion reloadData];
        }];
    }
    else{
    }
    [self.tableViewPromotion.mj_footer endRefreshing];
}


#pragma mark - Load HeaderView
- (void)loadHeaderView{
    
    self.tableViewPromotion.tableHeaderView = self.headerView;
}

#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"OMPromotionCell";
    OMPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OMPromotionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
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
    
    cell.shareBtn.tag = 500 + indexPath.row;
    
    // status select
    switch ([model.status integerValue]) {
        case 1:
            cell.statusLabel.hidden = YES;
            [cell.shareBtn setTitle:OMPENDING forState:UIControlStateNormal];
            [cell.shareBtn setTitleColor:OMCustomRedColor forState:UIControlStateNormal];
            [cell.shareBtn setBackgroundColor:WhiteBackGroudColor];
            break;
        case 3:
            cell.statusLabel.hidden = NO;
            cell.statusLabel.text = @"Approved";
            [cell.shareBtn setTitle:OMSHARE forState:UIControlStateNormal];
            [cell.shareBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
            [cell.shareBtn setBackgroundColor:OMCustomBlueColor];
//            [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 4:
            cell.statusLabel.hidden = NO;
            cell.statusLabel.text = @"Published";
            cell.statusLabel.textColor = OMCustomGreenColor;
            [cell.shareBtn setTitle:OMCOMPLETE forState:UIControlStateNormal];
            [cell.shareBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
            [cell.shareBtn setBackgroundColor:OMCustomBlueColor];
//            [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OMPromotionModel *model = [self.taskArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OMHomeDetailViewController *detailVC = [[OMHomeDetailViewController alloc] init];
    detailVC.taskId = model.taskId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - CollectionView Delegate Mehtod
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.statusCollectionView) {
        return 3;
    }
    else{
        return 2;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OMSelectItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMSelectItemCell" forIndexPath:indexPath];
    
    if (collectionView == self.statusCollectionView) {
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"Pending";
                break;
            case 1:
                cell.titleLabel.text = @"Approved";
                break;
            case 2:
                cell.titleLabel.text = @"Published";
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row + 1) {
            case 1:
                cell.titleLabel.text = @"Facebook";
                cell.titleLabel.font = [UIFont systemFontOfSize:15];
                break;
            case 2:
                cell.titleLabel.text = @"Twitter";
                cell.titleLabel.font = [UIFont systemFontOfSize:15];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)updateCellStyle:(OMSelectItemCell *)cell InCollectionView:(UICollectionView *)currentCV WithCurrentSelectedStatus:(BOOL)status{
    
    if (!status) {
        // unselected
        cell.titleLabel.textColor = OMCustomRedColor;
        cell.titleLabel.backgroundColor = WhiteBackGroudColor;
    }
    else{
        // selected
        cell.titleLabel.textColor = WhiteBackGroudColor;
        cell.titleLabel.backgroundColor = OMCustomRedColor;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.statusCollectionView) {
        
        self.selectedStatus = YES;
        // UI change after clicked
        OMSelectItemCell *cell = (OMSelectItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self updateCellStyle:cell InCollectionView:collectionView WithCurrentSelectedStatus:self.selectedStatus];
        
        // record click status
        if (indexPath.row == 0) {
            if (self.selectedStatus) {
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 1;
            }
            else{
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 0;
            }
        }
        else if (indexPath.row == 1)
        {
            if (self.selectedStatus) {
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 3;
            }
            else{
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 0;
            }
        }
        else if (indexPath.row == 2)
        {
            if (self.selectedStatus) {
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 4;
            }
            else{
                self.selectedStatus = !self.selectedStatus;
                self.statusFlag = 0;
            }
        }
        else{
            // no item
            //            self.statusFlag = 0;
        }
    }
    else
    {
        // UI change after clicked
        self.selectedPlatform = YES;
        OMSelectItemCell *cell = (OMSelectItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self updateCellStyle:cell InCollectionView:collectionView WithCurrentSelectedStatus:self.selectedPlatform];
        
        if (self.selectedPlatform) {
            self.selectedPlatform = !self.selectedPlatform;
            self.platformFlag = indexPath.row + 1;
        }
        else{
            self.selectedPlatform = !self.selectedPlatform;
            self.platformFlag = 0;
        }
    }
    
    // refresh data
    [self loadSelectData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.statusCollectionView) {
        OMSelectItemCell *deselectCell = (OMSelectItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        deselectCell.titleLabel.textColor = OMCustomRedColor;
        deselectCell.titleLabel.backgroundColor = WhiteBackGroudColor;
    }
    else{
        OMSelectItemCell *deselectCell = (OMSelectItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        deselectCell.titleLabel.textColor = OMCustomRedColor;
        deselectCell.titleLabel.backgroundColor = WhiteBackGroudColor;
    }
    
}

#pragma mark - Share Action
- (void)shareAction:(UIButton *)btn{
    // get model with index
    OMPromotionModel *model = [self.taskArray objectAtIndex:btn.tag - 500];
    
    if ([model.totalPlatforms integerValue] == 1) {
        
        // share to facebook
        NSDictionary *paramFBContent = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                         @"taskId" : model.taskId,
                                         @"platform" : @"1"
                                         };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramFBContent API:API_S_GET_SHARECONTENT dateBlock:^(id dateBlock) {
            // get ULR willing to share
            NSString *contentUrl = dateBlock[@"Data"][@"ShareContent"][@"contentUrl"];
            
            // prepare parameters of return status
            NSDictionary *paramFB = @{@"id": [SETTINGs objectForKey:OM_USER_ID],
                                      @"taskId": model.taskId,
                                      @"platform": @"1",
                                      @"sponsorSnsAccountId": model.snsId
                                      };
            // share activity
//            [OMCustomTool OMShareContentOnFacebook_WithContent:contentUrl FromViewController:self AndSendServerResultWtihParameter:paramFB];
            
            // send result to server
            [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramFB API:API_S_COMPLETE_TASK dateBlock:^(id dateBlock) {
                [OMCustomTool OMshowAlertViewWithMessage:@"Sending Facebook Succeed!" fromViewController:self];
                
                // refresh data
                [self loadSelectData];
                
            }];
        }];
    }
    else{
        // share to twitter
        NSDictionary *paramTWContent = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                         @"taskId" : model.taskId,
                                         @"platform" : @"2"
                                         };
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramTWContent API:API_S_GET_SHARECONTENT dateBlock:^(id dateBlock) {
            // get ULR willing to share
            NSString *contentUrl = dateBlock[@"Data"][@"ShareContent"][@"contentUrl"];
            
            // prepare parameters of return status
            NSDictionary *paramTW = @{@"id": [SETTINGs objectForKey:OM_USER_ID],
                                      @"taskId": model.taskId,
                                      @"platform": @"2",
                                      @"sponsorSnsAccountId": model.snsId
                                      };
            // share activity
            // ps:can't reload data immediately with CustomTool method
            TWTRComposer *composer = [[TWTRComposer alloc] init];
            
            [composer setURL:[NSURL URLWithString:contentUrl]];
            
            // Called from a UIViewController
            [composer showFromViewController:self completion:^(TWTRComposerResult result) {
                if (result == TWTRComposerResultCancelled) {
                    NSLog(@"Tweet composition cancelled");
                }
                else {
                    NSLog(@"Sending Tweet!");
                    // send result to server
                    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramTW API:API_S_COMPLETE_TASK dateBlock:^(id dateBlock) {
                        
                        // refresh data
                        [self loadSelectData];
                    }];
                }
            }];
        }];
    }
}

#warning Wait to fix
#pragma mark - TabBarController Delegate Method
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSInteger index = [self.tabBarController.viewControllers indexOfObject:self];
    if (index == 1) {
        
        [self loadSelectData];
        return YES;
    }
    else{
        return  YES;
    }
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
