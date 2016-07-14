//
//  OMMySocialAccountViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMMySocialAccountViewController.h"
#import "OMAuthorityDetailViewController.h"
#import "OMLoginViewController.h"

#import "OMAuthorizedAccountCell.h"
#import "OMUnAuthorizedAccountCell.h"

#import "OMSNSAccount.h"


@interface OMMySocialAccountViewController ()

@property(nonatomic, strong) NSMutableArray *authorizedArray;

@property(nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, assign) NSInteger StatusFlag;
@property(nonatomic, assign) NSInteger TypeFlag;

@property(nonatomic, assign) NSInteger FBFansCount;
@property(nonatomic, assign) NSInteger TWFansCount;

@end

@implementation OMMySocialAccountViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"My SNS Account";
    
    self.tableViewAccount = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableViewAccount.backgroundColor = WhiteBackGroudColor;
    [self.view addSubview:self.tableViewAccount];
    
    self.tableViewAccount.rowHeight = 90.0;
    self.tableViewAccount.bounces = NO;
    self.tableViewAccount.separatorColor = OMSeparatorLineColor;
    
    self.tableViewAccount.delegate = self;
    self.tableViewAccount.dataSource = self;
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self loadData];
}

#pragma mark - Load Data
- (void)loadData{
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_SNS_LIST dateBlock:^(id dateBlock) {
       
        self.authorizedArray = [OMSNSAccount ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"SnsAccounts"]];
        
        // account numbers load data
        for (OMSNSAccount *model in self.authorizedArray) {
            
            switch ([model.type integerValue]) {
                case 1:
                    self.FBFlag ++;
                    self.FBFansCount += [model.fansCount integerValue];
                    break;
                case 2:
                    self.TWFlag ++;
                    self.TWFansCount += [model.fansCount integerValue];
                    break;
                default:
                    break;
            }
        }
        
        [self.tableViewAccount reloadData];
        
        // remove loading view
        [self.hud hide:YES];
    }];
    
}


#pragma mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // all authoritied or all haven't authoritied
    
    if (self.FBFlag && self.TWFlag) {
        return 1;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.FBFlag && self.TWFlag) {
        // status 0 && 0 never occuried because of user's login status
        // true : 1 && 1
        if (section == 0) {
            return 2;
        }
        else{
            return 0;
        }
    }
    else{
        // false : 0 && 1 or 1 && 0
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"Authorized Social Account";
    }
    else{
        if (self.FBFlag != 0 && self.TWFlag != 0) {
            return @"";
        }
        else{
            return @"UnAuthorized";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // Authoritied
    if (indexPath.section == 0) {
        
        static NSString *reuse = @"OMAuthorizedAccountCell";
        OMAuthorizedAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        if (self.FBFlag == 0 && self.TWFlag == 0) {
            cell.hidden = YES;
        }
        else{
            cell.hidden = NO;
        }
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                // select palform for row 1
                if (self.FBFlag) {
                    cell.iconImg.image = IMAGE(@"f-f.png");
                    cell.accountNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.FBFlag];
                    cell.fansNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.FBFansCount];
                }
                else{
                    cell.iconImg.image = IMAGE(@"t-f.png");
                    cell.accountNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.TWFlag];
                    cell.fansNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.TWFansCount];
                }
            }
            else{
                // select platform for row 2
                if (self.TWFlag) {
                    cell.iconImg.image = IMAGE(@"t-f.png");
                    cell.accountNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.TWFlag];
                    cell.fansNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.TWFansCount];
                }
                else{
                }
            }
        }
        return cell;
    }
    // unAuthority
    else{
        static NSString *reuse = @"OMUnAuthorizedAccountCell";
        OMUnAuthorizedAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        
        if (self.FBFlag != 0 && self.TWFlag != 0) {
            cell.hidden = YES;
        }
        else{
            cell.hidden = NO;
        }
        // set cell unenable click
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // set iamge for each platform
        if (self.FBFlag) {
            cell.iconImg.image = IMAGE(@"t-f.png");
        }
        else{
            cell.iconImg.image = IMAGE(@"f-f.png");
        }
        
        cell.authorityBtn.tag = indexPath.row + 500;
        [cell.authorityBtn addTarget:self action:@selector(authorityAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        OMAuthorityDetailViewController *detailVC = [[OMAuthorityDetailViewController alloc] init];
        if (indexPath.row == 0) {
            if (_FBFlag) {
                detailVC.type = @"1";
            }
            else{
                detailVC.type = @"2";
            }
        }
        else{
            detailVC.type = @"2";
        }
        
        detailVC.FBAccountNumber = self.FBFlag;
        detailVC.TWAccountNumber = self.TWFlag;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else{
        // empty
    }
}

#pragma mark - Authority Activities
- (void)authorityAction:(UIButton *)btn{
    
    if (self.FBFlag == 0) {
        // authority with facebook
        [OMCustomTool OMAuthorityWithFacebook];
    }
    else{
        // authority with twitter
        [OMCustomTool OMAuthorityWithTwitter];
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
