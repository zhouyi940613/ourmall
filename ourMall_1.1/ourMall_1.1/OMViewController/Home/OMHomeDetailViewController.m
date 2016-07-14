//
//  OMHomeDetailViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMHomeDetailViewController.h"

#import "OMApplyAlertViewController.h"
#import "OMMySocialAccountViewController.h"

#import "OMHomeTaskDetialModel.h"

#import "OMTaskDetailCell.h"
#import "OMSeparatorCell.h"
#import "OMTaskAcceptCell.h"
#import "OMTaskNormalCell.h"
#import "OMTaskFinishedCell.h"

// twitter settings
#import <TwitterKit/TwitterKit.h>

@interface OMHomeDetailViewController ()<OMApplyAlertViewControllerDelegate>

@property(nonatomic, strong) NSString *detailTitle;
@property(nonatomic, strong) NSString *shareCount;
@property(nonatomic, strong) NSString *shareContent;
@property(nonatomic, strong) NSString *taskDescription;
@property(nonatomic, strong) NSMutableArray *taskDetailArray;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) BOOL enterOpenFlag;

@end

@implementation OMHomeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        _taskDetailArray = [NSMutableArray array];
        _webViewDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 750)];
        _webViewDetail.delegate = self;
        _webViewDetail.scrollView.bounces = NO;
        _webViewDetail.scrollView.showsHorizontalScrollIndicator = NO;
        _webViewDetail.scrollView.scrollEnabled = NO;
        [_webViewDetail sizeToFit];
         _tipsLabel.hidden = YES;
        _enterOpenFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"BRIEF";
    
    self.tableViewDetail.separatorColor = OMSeparatorLineColor;
    
    [self createHeaderView];
    [self loadFooterView];
    [self loadData];
    
    // add loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    
}

#pragma mark - Create Header View
- (void)createHeaderView{
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    // title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 1)];
    self.titleLabel.numberOfLines = NSIntegerMax;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.titleLabel];
    
    // description label
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.titleLabel.frame.size.height, SCREEN_WIDTH - 30, 1)];
    self.descriptionLabel.numberOfLines = NSIntegerMax;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:15]];
    self.descriptionLabel.textColor = [UIColor lightGrayColor];
    self.descriptionLabel.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.descriptionLabel];
    
    // task title label
    self.fixedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 25)];
    self.fixedLabel.text = @"Task List";
    self.fixedLabel.backgroundColor = [UIColor whiteColor];
    self.fixedLabel.font = [UIFont systemFontOfSize:20];
    [self.headerView addSubview:self.fixedLabel];
    
    // tips label
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 20)];
    self.tipsLabel.text = @"You had finished all the tasks!";
    self.tipsLabel.backgroundColor = WhiteBackGroudColor;
    self.tipsLabel.font = [UIFont systemFontOfSize:15.0];
    [self.headerView addSubview:self.tipsLabel];
    
    // detail settings
    self.separatorLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 270) / 2, 10, 50, 1)];
    self.separatorLeftLabel.backgroundColor = OMSeparatorLineColor;
    [self.headerView addSubview:self.separatorLeftLabel];
    
    self.productDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 27) / 2 + 20, 10, 130, 25)];
    self.productDetailLabel.text = @"Product Details";
    self.productDetailLabel.backgroundColor = WhiteBackGroudColor;
    [self.headerView addSubview:self.productDetailLabel];
    
    self.separatorRightLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 27) / 2 + 20 + 130 + 20, 10, 50, 1)];
    self.separatorRightLabel.backgroundColor = OMSeparatorLineColor;
    [self.headerView addSubview:self.separatorRightLabel];
}

#pragma mark - Load Header View
- (void)loadFooterView{
    
    [self.webViewDetail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ourmall.com/index.php?m=content&a=view&id=%@", self.taskId]]]];
    
    self.tableViewDetail.tableFooterView = self.webViewDetail;
}

#pragma mark - Load Data
- (void)loadData{
    
    // parameter id require login with star id
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"taskId" : self.taskId};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_ACCESS_TASKDETAIL dateBlock:^(id dateBlock) {
        
        if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dateBlock[@"Data"][@"Task"]];
            
            self.detailTitle = dic[@"name"];
            self.shareCount = [self OMString:dic[@"shareCount"]];
            self.taskDescription = dic[@"taskDescription"];
           
            // override labels frame with loaded data
            // title label
            self.titleLabel.text = self.detailTitle;
            CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT)];
            self.titleLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, titleSize.height);
            
            // description label
            self.descriptionLabel.text = [NSString stringWithFormat:@"%@", self.taskDescription];
            CGSize descriptionSize = [self.descriptionLabel sizeThatFits:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
            self.descriptionLabel.frame = CGRectMake(15, self.titleLabel.frame.size.height + 20, SCREEN_WIDTH - 30, descriptionSize.height);
            
            // task title label
            self.fixedLabel.frame = CGRectMake(15, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 30, 200, 25);
            
            // tips for empty array
            self.tipsLabel.frame = CGRectMake(15, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 30 + self.fixedLabel.frame.size.height + 10, 300, 20);
            
            // detail size settings
            self.separatorLeftLabel.frame = CGRectMake((SCREEN_WIDTH - 270) / 2, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 30 + self.fixedLabel.frame.size.height + 10 + self.tipsLabel.frame.size.height + 20 + 12, 50, 1);
            
            self.productDetailLabel.frame = CGRectMake((SCREEN_WIDTH - 270) / 2 + 20 + 50, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 30 + self.fixedLabel.frame.size.height + 10 + self.tipsLabel.frame.size.height + 20, 130, 25);
            
            self.separatorRightLabel.frame = CGRectMake((SCREEN_WIDTH - 270) / 2 + 20 + 50 + 130 + 20, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 30 + self.fixedLabel.frame.size.height + 10 + self.tipsLabel.frame.size.height + 20 + 12, 50, 1);
            
            // model
            self.taskDetailArray = [OMHomeTaskDetialModel ModelArr_With_DictionaryArr: dic[@"taskPlatformArray"]];
            
            // add one more model for show Product Details
            // override header view frame
            if (self.taskDetailArray.count != 0) {
                self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 25 + 30 + self.tipsLabel.frame.size.height);
                [self.taskDetailArray addObject:self.taskDetailArray.firstObject];
                self.tipsLabel.hidden = YES;
                self.separatorRightLabel.hidden = YES;
                self.separatorLeftLabel.hidden = YES;
                self.productDetailLabel.hidden = YES;
            }
            else{
                self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.titleLabel.frame.size.height + self.descriptionLabel.frame.size.height + 10 + 25 + 30 + self.tipsLabel.frame.size.height + 20 + 60);
                self.tipsLabel.hidden = NO;
                self.separatorRightLabel.hidden = NO;
                self.separatorLeftLabel.hidden = NO;
                self.productDetailLabel.hidden = NO;
            }
            self.tableViewDetail.tableHeaderView = self.headerView;
            
            [self.tableViewDetail reloadData];
            
            
        }
        else{
            NSLog(@"!**!MaBang!**!-- SERVER ERROR CODE: %@ --!**!MaBang!**!", dateBlock[@"ErrorCode"]);
        }
    }];
}

#pragma mark - TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.taskDetailArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:indexPath.row];
    
    __block CGFloat height = 0;
    
    if (indexPath.row == self.taskDetailArray.count - 1) {
        height = 60;
    }
    else{
        if ([[self OMString:model.status] intValue] == 1 || [[self OMString:model.status] intValue] == 2 || [[self OMString:model.status] intValue] == 4 || [[self OMString:model.status] intValue] == 6) {
            height = 90;
        }
        else if ([[self OMString:model.status] intValue] == 3 || [[self OMString:model.status] intValue] == 5){
            // judge to show hidden size
                if (self.enterOpenFlag) {
                    [UIView animateWithDuration:2 animations:^{
                        height = 205;
                    }];
                }
                else{
                    [UIView animateWithDuration:2 animations:^{
                        height = 170;
                    }];
                }
            
        }
        else{
            height = 0;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // separator line
    if (indexPath.row == self.taskDetailArray.count - 1) {
        
        static NSString *reuse = @"OMSeparatorCell";
        OMSeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        return cell;
    }
    
    // detail style
    else
    { 
        OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:indexPath.row];
        
        // style with function button
        if ([[self OMString:model.status] intValue] == 1 || [[self OMString:model.status] intValue] == 2 || [[self OMString:model.status] intValue] == 4) {
            
            static NSString *reuse = @"OMTaskDetailCell";
            OMTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
            }
            
            cell.priceLabel.text = [NSString stringWithFormat:@"US$:%@", [self OMString:model.applyCash]];
            cell.accountLabel.text = model.name;
            cell.numberLabel.text = [self OMString:model.fansCount];
            [OMCustomTool SDSetImageView:cell.userIconImg withURLString:model.portrait andPlacehoderImageName:USER_ICONIMG];
            
            // use tag value of button replace cell indexPath.row
            cell.operationBtn.tag = indexPath.row + 500;
            
            // platform icon flag
            switch ([model.type integerValue]) {
                case 1:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"f.png");
                    break;
                case 2:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"t.png");
                    break;
                default:
                    break;
            }
            
            
            if ([[self OMString:model.status] intValue] == 1) {
                // statu apply
                cell.operationBtn.backgroundColor = OMCustomRedColor;
                [cell.operationBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
                [cell.operationBtn setTitle:OMAPPLY forState:UIControlStateNormal];
                [cell.operationBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.priceLabel.hidden = YES;
                cell.numberImg.hidden = NO;
                return cell;
            }
            else if ([[self OMString:model.status] intValue] == 2)
            {
                // statu wait
                cell.operationBtn.backgroundColor = WhiteBackGroudColor;
                [cell.operationBtn setTitleColor:OMCustomRedColor forState:UIControlStateNormal];
                [cell.operationBtn setTitle:OMPENDING forState:UIControlStateNormal];
                cell.operationBtn.enabled = NO;
                cell.priceLabel.hidden = NO;
                cell.numberImg.hidden = NO;
                return cell;
            }
            else
            {
                // statu authority
                cell.operationBtn.backgroundColor = OMCustomOrangeColor;
                [cell.operationBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
                [cell.operationBtn setTitle:OMAUTHORITY forState:UIControlStateNormal];
                [cell.operationBtn addTarget:self action:@selector(authorityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.priceLabel.hidden = YES;
                cell.numberImg.hidden = YES;
                return cell;
            }
        }
        // style share with input textField
        else if ([[self OMString:model.status] intValue] == 3 || [[self OMString:model.status] intValue] == 5)
        {
            // statu share
            static NSString *reuse = @"OMTaskAcceptCell";
            OMTaskAcceptCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[OMTaskAcceptCell alloc] initWithStyle:1 reuseIdentifier:reuse];
            }
            cell.priceLabel.text = [NSString stringWithFormat:@"US$:%@", [self OMString:model.applyCash]];
            cell.numberLabel.text = [self OMString:model.fansCount];
            cell.accountLabel.text = model.name;
            [OMCustomTool SDSetImageView:cell.userIconImg withURLString:model.portrait andPlacehoderImageName:USER_ICONIMG];
            cell.linkTextField.text = model.contentUrl;
            
            cell.selectAllBtn.tag = indexPath.row + 600;
            cell.submitBtn.tag = indexPath.row + 700;
            
            
            [cell.selectAllBtn addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.enterBtn addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            // platform icon flag
            switch ([model.type integerValue]) {
                case 1:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"f.png");
                    
                    break;
                case 2:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"t.png");
                    
                    break;
                    
                default:
                    break;
            }
            
            // show hidden part
            
            if (self.enterOpenFlag) {
                cell.inputTextField.hidden = NO;
                cell.submitBtn.hidden = NO;
            }
            else{
                cell.inputTextField.hidden = YES;
                cell.submitBtn.hidden = YES;
            }
            
            // control shared icon
            if ([[self OMString:model.status] intValue] == 3) {
                cell.editImg.image = IMAGE(@"noShare.png");
                cell.inputTextField.text = @" ";
            }
            else{
                cell.editImg.image = IMAGE(@"shared.png");
                cell.inputTextField.text = model.shareLink;
            }
            
            return cell;
        }
        
        // style share completed without button
        else
        {
            // statu completed
            static NSString *reuse = @"OMTaskFinishedCell";
            
            OMTaskFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[OMTaskFinishedCell alloc] initWithStyle:1 reuseIdentifier:reuse];
            }
            
            cell.accountLabel.text = model.name;
            [OMCustomTool SDSetImageView:cell.userIconImg withURLString:model.portrait andPlacehoderImageName:USER_ICONIMG];
            
            // platform icon flag
            switch ([model.type integerValue]) {
                case 1:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"f.png");
                    break;
                case 2:
                    cell.platformFlagImg.hidden = NO;
                    cell.platformFlagImg.image = IMAGE(@"t.png");
                    break;
                default:
                    break;
            }
            
            return cell;
        }
    }
}

#pragma mark - Copy & Enter Action
- (void)copyAction:(UIButton *)btn{
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:btn.tag - 600];
    
    // copy to clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.contentUrl;
    
    if (pasteboard.string) {
        [OMCustomTool OMshowAlertViewWithMessage:@"copy succeed!" fromViewController:self];
    }else{
        [OMCustomTool OMshowAlertViewWithMessage:@"copy failed!" fromViewController:self];
    }
}

- (void)enterAction:(UIButton *)btn{

    NSIndexPath *indexPath = [self.tableViewDetail indexPathForSelectedRow];
    
    btn.hidden = YES;
    
    if (self.enterOpenFlag) {
        self.enterOpenFlag = !self.enterOpenFlag;
    }
    else{
        self.enterOpenFlag = !self.enterOpenFlag;
    }
    
    [self.tableViewDetail reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSelector:@selector(updateCellStyle) withObject:nil afterDelay:0.2];
}

- (void)updateCellStyle{
    
    [self.tableViewDetail reloadData];
}

#pragma mark - Apply Button Clicked Action
- (void)applyBtnAction:(UIButton *)btn{
    
    // show alert for price input
    OMApplyAlertViewController *applyView = [[OMApplyAlertViewController alloc] init];
    applyView.delegate = self;
    
    // transport tag value from current button to submit button
    self.index = btn.tag - 500;
    
    applyView.view.backgroundColor = DefaultBackgroundColor;
    applyView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:applyView animated:YES completion:^{
        applyView.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

#pragma mark - Submit Button Clicked Action
- (void)submitBtnAction:(UIButton *)btn{
    
    
    NSLog(@"Share test!");
    
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:btn.tag - 700];
    
    // select platform and share
    if ([model.type integerValue] == 1) {
        
        // share on facebook
        [self shareOnFacebookWithParam:btn.tag - 700];
    }
    else if ([model.type integerValue] == 2){
        
        // share on twitter
        [self shareOnTwitterWithParam:btn.tag - 700];
    }
}

#pragma mark - Authority Button Clicked Action
- (void)authorityBtnAction:(UIButton *)btn{
    // jump to authority
    OMMySocialAccountViewController *authorityVC = [[OMMySocialAccountViewController alloc] init];
    [self.navigationController pushViewController:authorityVC animated:YES];
}


#pragma mark - Apply Alert Delegate Method
- (void)applyBnttonClickedEvent_WithTextFieldValue:(NSString *)strValue{
    
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:self.index];
    
    NSString *snsId = [NSString stringWithFormat:@"%@", model.snsId];
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"taskId" : self.taskId,
                               @"sponsorSnsAccountId" : snsId,
                               @"price" : strValue
                               };
    
    // send apply request to server
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_TASK_APPLY dateBlock:^(id dateBlock) {
        // apply succeed and show alert
        [OMCustomTool OMshowAlertViewWithMessage:@"Apply Succeed!" fromViewController:self];
        // refresh data
        [self loadData];
    }];
}

#pragma mark - Share Actions
- (void)shareOnFacebookWithParam:(NSInteger)param{
    
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:param];
    
//    // find cell with param
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:param inSection:0];
    OMTaskAcceptCell *cell  = [self.tableViewDetail cellForRowAtIndexPath: indexPath];
    
    NSLog(@"current accountlabel text : %@", cell.accountLabel.text);
    
    NSDictionary *paramFB = @{@"id": [SETTINGs objectForKey:OM_USER_ID],
                              @"taskId": self.taskId,
                              @"platform": @"1",
                              @"sponsorSnsAccountId": model.snsId,
                              @"shareLink" : cell.inputTextField.text
                              };
    // send result to server
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramFB API:API_S_COMPLETE_TASK dateBlock:^(id dateBlock) {
        [OMCustomTool OMshowAlertViewWithMessage:@"Sending Facebook Succeed!" fromViewController:self];
        // refresh data
        [self loadData];
    }];
}

- (void)shareOnTwitterWithParam:(NSInteger)param{
    
    OMHomeTaskDetialModel *model = [self.taskDetailArray objectAtIndex:param];
    
    // find cell with param
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:param inSection:0];
    OMTaskAcceptCell *cell  = [self.tableViewDetail cellForRowAtIndexPath: indexPath];
    
    NSLog(@"current accountlabel text : %@", cell.accountLabel.text);
    
    NSDictionary *paramTW = @{@"id": [SETTINGs objectForKey:OM_USER_ID],
                              @"taskId": self.taskId,
                              @"platform": @"2",
                              @"sponsorSnsAccountId": model.snsId,
                              @"shareLink" : cell.inputTextField.text
                              };
    // send result to server
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramTW API:API_S_COMPLETE_TASK dateBlock:^(id dateBlock) {
        [OMCustomTool OMshowAlertViewWithMessage:@"Sending Tweet Succeed!" fromViewController:self];
        // refresh data
        [self loadData];
    }];
}


#pragma mark - Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    self.tableViewDetail.contentSize = CGSizeMake(SCREEN_WIDTH, newFrame.origin.y + newFrame.size.height);
    
    // remove loading animation
    [self.hud hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
