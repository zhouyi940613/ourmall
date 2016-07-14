//
//  OMHomeViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import <MJRefresh.h>
#import "MJRefreshHeader.h"

#import "OMHomeViewController.h"
#import "OMHomeDetailViewController.h"
#import "OMLoginViewController.h"
#import "OMSearchViewController.h"

#import "OMHomeLargeCell.h"
#import "OMHomeMiniCell.h"
#import "OMHomeTaskModel.h"

@interface OMHomeViewController ()<SDWebImageManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewHome;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property(nonatomic, strong) NSMutableArray *homeCellArray;
@property(nonatomic, strong) NSMutableArray *homeRollerArray;

@property(nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, assign) NSInteger pageValue;

// track
@property(nonatomic, assign) NSInteger displayTimes;

// home cell style flag
@property(nonatomic, assign) BOOL isLargeStyle;

@property(nonatomic, assign) CGFloat cellNewHeight;



@end

@implementation OMHomeViewController

#pragma mark - Init
- (instancetype)init{
    self = [super init];
    if (self) {
        _homeCellArray = [NSMutableArray array];
        _homeRollerArray =[NSMutableArray array];
        _pageValue = 1;
        _isLargeStyle = NO;
    }
    return self;
}

#pragma mark - Setting Scroller
- (void)viewWillAppear:(BOOL)animated{
    
    // lack judge user is login
    self.displayTimes ++;
    // appsflyer
//    NSDictionary *trackDic = @{ // OMAF_USER_ID :     [SETTINGs objectForKey:OM_USER_ID],
//                               OMAF_DEVICE_ID :   [SETTINGs objectForKey:OMAF_DEVICE_ID],
//                               OMAF_VIEWCOUNTS :  [self OMStringFrom:self.displayTimes],
//                               };
    
//    [[AppsFlyerTracker sharedTracker] trackEvent:OMAF_EVENT_HOMEPAGE_VIEWCOUNT withValues:trackDic];
    
    [super viewWillAppear:YES];
    
    // banner
//    [self.scrollerView setContentOffset:CGPointMake(0, 0)];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set title
    self.tabBarItem.title = @"Home";
    self.navigationItem.title = @"OurMall";
    
    // search button (right)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"homeSearch.png") style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];

    // change button (left)
    
    if ([SETTINGs valueForKey:@"OMDefaultCellStyle"]) {
        
        if ([[SETTINGs valueForKey:@"OMDefaultCellStyle"] isEqualToString:@"large"]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"homeStyleMini.png") style:UIBarButtonItemStyleDone target:self action:@selector(changeStyleAction:)];
        }
        else{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"homeStyleLarge.png") style:UIBarButtonItemStyleDone target:self action:@selector(changeStyleAction:)];
        }
    }
    else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"homeStyleMini.png") style:UIBarButtonItemStyleDone target:self action:@selector(changeStyleAction:)];
    }
    
    // banner : set header view
//    self.tableViewHome.tableHeaderView = self.headerView;
    
    [self loadData];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    // refresh data
    self.tableViewHome.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableViewHome.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

#pragma mark - Load Data
- (void)loadData{
    
    NSDictionary *paramDic = @{};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_ACCESS_TASKLIST dateBlock:^(id dateBlock) {
        if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            NSDictionary *dic = dateBlock;
            
            NSArray *dateArr = dic[@"Data"][@"Tasks"];
            self.homeCellArray = [OMHomeTaskModel ModelArr_With_DictionaryArr:dateArr];
            
            [self.tableViewHome reloadData];
            
            // remove loading animation
            [self.hud hide:YES];
        }
        else{
             NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
        }
    }];
    
}

#pragma mark - Refresh Data With Header and Footer
- (void)loadNewData{
    
    self.pageValue = 1;
    [self loadData];
    [self.tableViewHome.mj_header endRefreshing];
}

- (void)loadMoreData{
    
    self.pageValue ++;
    
    NSString *pageCount = [NSString stringWithFormat:@"%ld", (long)self.pageValue];
    
    NSDictionary *paramDic = @{@"page" : pageCount};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_ACCESS_TASKLIST dateBlock:^(id dateBlock) {
        if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            NSDictionary *dic = dateBlock;
            
            // add new data
            NSArray *dateArr = dic[@"Data"][@"Tasks"];
            NSMutableArray *newArr = [NSMutableArray array];
            newArr = [OMHomeTaskModel ModelArr_With_DictionaryArr:dateArr];
            for (OMHomeTaskModel *model in newArr) {
                [self.homeCellArray addObject:model];
            }
            
            [self.tableViewHome reloadData];
            
        }
        else{
            NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
        }
    }];
    
    [self.tableViewHome.mj_footer endRefreshing];
}

#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.homeCellArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[SETTINGs objectForKey:@"OMDefaultCellStyle"] isEqualToString:@"large"]) {
        
        if (self.cellNewHeight != 0 && self.cellNewHeight > 0) {
            return self.cellNewHeight + 105;
        }
        else{
            return 500;
        }
        
    }
    else{
        return 140.0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([SETTINGs valueForKey:@"OMDefaultCellStyle"]) {
        
        if ([[SETTINGs valueForKey:@"OMDefaultCellStyle"] isEqualToString:@"mini"]) {
            // mini
            static NSString *reuse = @"OMHomeMiniCell";
            OMHomeMiniCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
            }
            
            OMHomeTaskModel *model = [self.homeCellArray objectAtIndex:indexPath.row];
            
            
            cell.titleImageView.image = IMAGE(@"productPlacer.png");
            
            // resize image
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            [manager downloadImageWithURL:[NSURL URLWithString:model.imgUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (!error) {
                    
                    CGFloat imgWidth = image.size.width;
                    CGFloat imgHeight = image.size.height;
                    
                    if (imgWidth > imgHeight) {
                        CGFloat aWidth = imgHeight / imgWidth;
                        CGFloat newHeight = 98 * aWidth;
                        cell.titleImageView.frame = CGRectMake(11, (100 - newHeight) / 2 + 10, 98, newHeight);
                    }
                    else{
                        CGFloat aWidth = imgWidth / imgHeight;
                        CGFloat newWidth = 98 * aWidth;
                        cell.titleImageView.frame = CGRectMake((100 - newWidth) / 2 + 10, 11, newWidth, 98);
                    }
                    cell.titleImageView.image = image;
                }
                else{
                    cell.titleImageView.image = IMAGE(@"productPlacer.png");
                }
            }];
            
            cell.titleLabel.text = model.name;
            cell.fansNumberLabel.text = [NSString stringWithFormat:@"%@", model.viewCount];
            
            // logic of platform icon display
            if (!model.releasePlatform) {
                
                cell.facebookImg.hidden = YES;
                cell.twitterImg.hidden = YES;
                cell.instgramImg.hidden = YES;
            }
            else{
                
                for (NSString *temp in model.releasePlatform) {
                    if ([temp isEqual:@1]) {
                        cell.facebookImg.hidden = NO;
                    }
                    else if ([temp isEqual:@2])
                    {
                        cell.twitterImg.hidden = NO;
                    }
                    else
                    {
                        cell.instgramImg.hidden = NO;
                    }
                }
            }
            return cell;
        }
        else{
            // large
            static NSString *reuse = @"OMHomeLargeCell";
            OMHomeLargeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
            }
            
            OMHomeTaskModel *model = [self.homeCellArray objectAtIndex:indexPath.row];
            
            cell.titleImageView.image = IMAGE(@"moren.jpg");
            
            // resize image
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            [manager downloadImageWithURL:[NSURL URLWithString:model.imgUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (finished) {
                    
                    if (!error) {
                        
                        CGFloat imgWidth = image.size.width;
                        CGFloat imgHeight = image.size.height;
                        CGFloat aWidth = imgHeight / imgWidth;
                        
                        CGFloat newHeight = SCREEN_WIDTH * aWidth;
                        
                        cell.titleImageView.image = image;
                        cell.titleImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, newHeight);
                        
                        self.cellNewHeight = newHeight;
                        
                        // set other container size in cell
                        cell.titleLabel.frame = CGRectMake(10, 10 + newHeight, SCREEN_WIDTH - 20, 40);
                        cell.fansNumberImg.frame = CGRectMake(10, 10 + newHeight + 40 + 10, 20, 20);
                        cell.fansNumberLabel.frame = CGRectMake(10 + 20, 10 + newHeight + 40 + 10, 35, 20);
                        cell.facebookImg.frame = CGRectMake(10 + 20 + 40, 10 + newHeight + 40 + 10, 25, 25);
                        cell.twitterImg.frame = CGRectMake(10 + 20 + 40 + 30, 10 + newHeight + 40 + 10, 25, 25);
                        cell.applyLabel.frame = CGRectMake(SCREEN_WIDTH - 10 - 85, 10 + newHeight + 40 + 10, 85, 30);
                        cell.separatorLine.frame = CGRectMake(0, 10 + newHeight + 40 + 10 + 35 + 2, SCREEN_WIDTH, 1);
                    }
                    else{
                        
                    }
                }
                else{
                
                }
            
            }];
            
            
            cell.titleLabel.text = model.name;
            cell.fansNumberLabel.text = [NSString stringWithFormat:@"%@", model.viewCount];
            
            // logic of platform icon display
            if (!model.releasePlatform) {
                
                cell.facebookImg.hidden = YES;
                cell.twitterImg.hidden = YES;
                cell.instgramImg.hidden = YES;
            }
            else{
                
                for (NSString *temp in model.releasePlatform) {
                    if ([temp isEqual:@1]) {
                        cell.facebookImg.hidden = NO;
                    }
                    else if ([temp isEqual:@2])
                    {
                        cell.twitterImg.hidden = NO;
                    }
                    else
                    {
                        cell.instgramImg.hidden = NO;
                    }
                }
            }
            return cell;
        }
    }
    else{
        // mini
        static NSString *reuse = @"OMHomeMiniCell";
        OMHomeMiniCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        
        OMHomeTaskModel *model = [self.homeCellArray objectAtIndex:indexPath.row];
        
        
        cell.titleImageView.image = IMAGE(@"productPlacer.png");
        
        // resize image
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:model.imgUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (!error) {
                
                CGFloat imgWidth = image.size.width;
                CGFloat imgHeight = image.size.height;
                
                if (imgWidth > imgHeight) {
                    CGFloat aWidth = imgHeight / imgWidth;
                    CGFloat newHeight = 98 * aWidth;
                    cell.titleImageView.frame = CGRectMake(11, (100 - newHeight) / 2 + 10, 98, newHeight);
                }
                else{
                    CGFloat aWidth = imgWidth / imgHeight;
                    CGFloat newWidth = 98 * aWidth;
                    cell.titleImageView.frame = CGRectMake((100 - newWidth) / 2 + 10, 11, newWidth, 98);
                }
                cell.titleImageView.image = image;
            }
            else{
               cell.titleImageView.image = IMAGE(@"productPlacer.png");
            }
            
        }];
        
        cell.titleLabel.text = model.name;
        cell.fansNumberLabel.text = [NSString stringWithFormat:@"%@", model.viewCount];
        
        // logic of platform icon display
        if (!model.releasePlatform) {
            
            cell.facebookImg.hidden = YES;
            cell.twitterImg.hidden = YES;
            cell.instgramImg.hidden = YES;
        }
        else{
            
            for (NSString *temp in model.releasePlatform) {
                if ([temp isEqual:@1]) {
                    cell.facebookImg.hidden = NO;
                }
                else if ([temp isEqual:@2])
                {
                    cell.twitterImg.hidden = NO;
                }
                else
                {
                    cell.instgramImg.hidden = NO;
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([OMCustomTool UserIsLoggingIn]) {
        
        // prepare for detail page
        OMHomeDetailViewController *detailVC = [[OMHomeDetailViewController alloc] init];
        detailVC.navigationController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        // transport parameters
        OMHomeTaskModel *model = [self.homeCellArray objectAtIndex:indexPath.row];
        detailVC.taskId = [NSString stringWithString:[NSString stringWithFormat:@"%@", model.idValue]];
        
        // appsflyer
//        NSDictionary *trackDic = @{// OMAF_USER_ID   : [SETTINGs objectForKey:OMAF_USER_ID],
//                                   OMAF_DEVICE_ID : [SETTINGs objectForKey:OMAF_DEVICE_ID],
//                                   OMAF_TASK_ID   : model.idValue
//                                   };
        
//        [[AppsFlyerTracker sharedTracker] trackEvent:OMAF_EVENT_TASK_CLICK withValues:trackDic];
        
    }
    else{
        OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
           
        }];
    }
}


#pragma mark - Right & Left Button Actions
- (void)searchAction:(UIBarButtonItem *)btn{
    
    OMSearchViewController *searchVC = [[OMSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)changeStyleAction:(UIBarButtonItem *)btn{
    
#if 0
    
    [SETTINGs removeObjectForKey:@"OMDefaultCellStyle"];
    
#endif
    
#if 1
    
    if ([SETTINGs valueForKey:@"OMDefaultCellStyle"]) {
        
        if ([[SETTINGs valueForKey:@"OMDefaultCellStyle"] isEqualToString:@"large"]) {
            
            self.navigationItem.leftBarButtonItem.image = IMAGE(@"homeStyleLarge.png");
            self.isLargeStyle = !self.isLargeStyle;
            [SETTINGs setValue:@"mini" forKey:@"OMDefaultCellStyle"];
        }
        else{
            self.navigationItem.leftBarButtonItem.image = IMAGE(@"homeStyleMini.png");
            self.isLargeStyle = !self.isLargeStyle;
            [SETTINGs setValue:@"large" forKey:@"OMDefaultCellStyle"];
        }
    }
    else{
        
        if (self.isLargeStyle) {
            self.navigationItem.leftBarButtonItem.image = IMAGE(@"homeStyleLarge.png");
            self.isLargeStyle = !self.isLargeStyle;
            [SETTINGs setValue:@"mini" forKey:@"OMDefaultCellStyle"];
        }
        else{
            self.navigationItem.leftBarButtonItem.image = IMAGE(@"homeStyleMini.png");
            self.isLargeStyle = !self.isLargeStyle;
            [SETTINGs setValue:@"large" forKey:@"OMDefaultCellStyle"];
        }
    }
    
    
#endif
    
    
    [self performSelector:@selector(updateStyle) withObject:nil afterDelay:0.15];
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:0.15];
}

- (void)updateStyle{
    
    [self.tableViewHome reloadData];
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
