//
//  OMVisitorViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMVisitorViewController.h"

#import "OMContactusViewController.h"
#import "OMLoginViewController.h"


@interface OMVisitorViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMVisitorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    // show loading view
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self performSelector:@selector(dismissLoadingView) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set title
    self.title = @"Accounts";
    [self loadHeaderView];
}

- (void)dismissLoadingView{
    // remove loading view
    [self.hud hide:YES];
}

#pragma mark - Load HeaderView
- (void)loadHeaderView{
    self.userIconImg.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    self.userIconImg.layer.borderWidth = 3;
    self.userIconImg.layer.cornerRadius = 45;
    self.userIconImg.layer.masksToBounds = YES;
    
    self.tableViewVisitor.tableHeaderView = self.headerView;
}

#pragma mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Authorized Social Account";
            cell.accessoryType = 1;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Ongoing Tasks";
            cell.accessoryType = 1;
        }
        else{
            cell.textLabel.text = @"Completed Tasks";
            cell.accessoryType = 1;
        }
    }
    else{
        cell.textLabel.text = @"Contact us";
        cell.accessoryType = 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
        
    }
    else{
        // Contact us
        OMContactusViewController *contactVC = [[OMContactusViewController alloc] init];
        [self.navigationController pushViewController:contactVC animated:YES];
        
    }
}


- (IBAction)loginButtonAction:(id)sender {
    OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
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
