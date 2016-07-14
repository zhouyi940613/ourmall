//
//  OMAuthorityDetailViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMAuthorityDetailViewController.h"

#import "OMAuthorityDetailCell.h"
#import "OMSNSAccount.h"

@interface OMAuthorityDetailViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSMutableArray *FBSNSArray;
@property(nonatomic, strong) NSMutableArray *TWSNSArray;

@end

@implementation OMAuthorityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _FBSNSArray = [NSMutableArray array];
        _TWSNSArray = [NSMutableArray array];
    }
    return self;  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"My SNS Account";
    [self.tableViewAccount registerNib:[UINib nibWithNibName:@"OMAuthorityDetailCell" bundle:nil] forCellReuseIdentifier:@"OMAuthorityDetailCell"];
    self.tableViewAccount.separatorColor = OMSeparatorLineColor;
    
    [self loadData];
    [self loadHeaderView];
}

#pragma mark - Load Data
- (void)loadData{
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_SNS_LIST dateBlock:^(id dateBlock) {
        NSMutableArray *snsArray = [NSMutableArray array];
        snsArray = [OMSNSAccount ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"SnsAccounts"]];
        
        for (OMSNSAccount *item in snsArray) {
            if ([item.type integerValue] == 1) {
                [self.FBSNSArray addObject:item];
            }
            else if ([item.type integerValue] == 2){
                [self.TWSNSArray addObject:item];
            }
            else{
                // empty
            }
        }
        // hide redundant separator lines
        [self setExtraCellLineHidden:self.tableViewAccount WithCurrentArray:self.FBSNSArray];
        [self.tableViewAccount reloadData];
       
        // remove loading view
        [self.hud hide:YES];
    }];
}

#pragma mark - Load HeaderView
- (void)loadHeaderView{
    
    self.tableViewAccount.tableHeaderView = self.headerView;
    self.tableViewAccount.rowHeight = 80.0;
    
    // settings for header view
    [OMCustomTool setcornerOfView:self.addNewAccountBtn withRadius:5 color:WhiteBackGroudColor];
}

#pragma mark - TableView Delegate Mewthod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.type isEqualToString:@"1"]) {
        return self.FBSNSArray.count;
    }
    else{
        return self.TWSNSArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMAuthorityDetailCell";
    
    OMAuthorityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OMAuthorityDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    if ([self.type isEqualToString:@"1"]) {
        OMSNSAccount *model = [self.FBSNSArray objectAtIndex:indexPath.row];
        [OMCustomTool SDSetImageView:cell.userIconImg withURLString:model.portrait andPlacehoderImageName:OM_USER_ICON];
        cell.userNameLabel.text = model.name;
        cell.fansNumberLabel.text = [self OMString:model.fansCount];
        self.userIconImg.image = IMAGE(@"f.png");
        
        self.AccountNumberLabel.text = [NSString stringWithFormat:@"Facebook(%ld)", (long)self.FBAccountNumber];
    }
    else{
        OMSNSAccount *model = [self.TWSNSArray objectAtIndex:indexPath.row];
        [OMCustomTool SDSetImageView:cell.userIconImg withURLString:model.portrait andPlacehoderImageName:OM_USER_ICON];
        cell.userNameLabel.text = model.name;
        cell.fansNumberLabel.text = [self OMString:model.fansCount];
        self.userIconImg.image = IMAGE(@"t.png");
        
        self.AccountNumberLabel.text = [NSString stringWithFormat:@"Twitter(%ld)", (long)self.TWAccountNumber];
    }

    return cell;
}

#pragma mark - TableView Edit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

#pragma mark - Delete SNS ID
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((self.FBSNSArray.count + self.TWSNSArray.count) < 2) {
        [OMCustomTool OMshowAlertViewWithMessage:@"Sorry,you can not delete the last SNS account!" fromViewController:self];
    }
    else{
        OMSNSAccount *model = [self.TWSNSArray objectAtIndex:indexPath.row];
        
        if ([self.type integerValue] == 1) {
            // delete from facebook
            [OMCustomTool OMDeleteAccountInFacebook_WithSNSID:[NSString stringWithFormat:@"%@", model.outerUserId]];
            [self.FBSNSArray removeObjectAtIndex:indexPath.row];
            [self.tableViewAccount deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:1];
        }
        else{
            // delete from twitter
            [OMCustomTool OMDeleteAccountInTwitter_WithSNSID:[NSString stringWithFormat:@"%@", model.outerUserId]];
            [self.TWSNSArray removeObjectAtIndex:indexPath.row];
            [self.tableViewAccount deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:1];
        }
    }
    
}

- (IBAction)addNewSNSAccount:(id)sender {
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    if ([self.type isEqualToString:@"1"]) {
        [OMCustomTool OMAuthorityWithFacebook];
        [self.hud hide:YES];
        
    }
    else if ([self.type isEqualToString:@"2"])
    {
        [OMCustomTool OMAuthorityWithTwitter];
        [self.hud hide:YES];

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
