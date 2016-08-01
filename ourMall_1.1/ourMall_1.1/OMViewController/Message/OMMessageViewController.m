//
//  OMMessageViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMMessageViewController.h"
#import "OMMessageDetailVC.h"

#import "OMMessageCell.h"
#import "OMFriendListModel.h"

#import "UINavigationItem+Loading.h"


@interface OMMessageViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *friendArray;

@end

@implementation OMMessageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _friendArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set title
    self.title = @"Message";
    [self.tableViewMessage registerNib:[UINib nibWithNibName:@"OMMessageCell" bundle:nil] forCellReuseIdentifier:@"OMMessageCell"];
    
    // websocket settings
    [NOTIFICATION_SETTING addObserver:self selector:@selector(loadDataWithNotice:) name:OMWEBSOCKET_SESSIONLIST object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // loading start
    [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionCenter];
    
    if ([OMCustomTool UserIsLoggingIn]) {
        
        [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_SESSIONLISTREQUEST object:nil];
        [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_UNREADCOUNTREQUEST object:nil];
    }
    else{
    }
    
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(rebackToRootViewAction)];
//    }else{
//        self.navigationItem.leftBarButtonItem=nil;
//    }
}

//- (void)rebackToRootViewAction {
//    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
//    [pushJudge setObject:@""forKey:@"push"];
//    [pushJudge synchronize];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Load Data With Notification
- (void)loadDataWithNotice:(NSNotification *)notice{
    
    // stop center loading animation
    [self.navigationItem stopAnimating];
    
    // 缓存未做
    if ([notice.userInfo[@"status"] isEqualToString:@"init"]) {
        
        NSArray *array = [NSArray arrayWithArray:[notice.userInfo objectForKey:@"sessionList"]];
        self.friendArray = [OMFriendListModel ModelArr_With_DictionaryArr:array];
        
        [self.tableViewMessage reloadData];
    }
    //
    else if ([notice.userInfo[@"status"] isEqualToString:@"new"])
    {
        // exchange
        NSArray *array = [NSArray arrayWithArray:[notice.userInfo objectForKey:@"sessionList"]];
        array = [OMFriendListModel ModelArr_With_DictionaryArr:array];
        
        // 副本数组
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.friendArray];
        
        for (OMFriendListModel *newModel in array) {
            for (OMFriendListModel *oldModel in self.friendArray) {
                
                if ([newModel.plus[@"name"] isEqualToString:oldModel.plus[@"name"]]) {
                    [tempArr removeObject:oldModel];
                }
            }
            
            self.friendArray = [NSMutableArray arrayWithArray:tempArr];
            [self.friendArray insertObject:newModel atIndex:0];
        }
        
        [self.tableViewMessage reloadData];
    }
    else{
        // empty
    }
    
}


#pragma mark - TableView Delegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.friendArray.count > 0) {
        
        return self.friendArray.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"OMMessageCell";
    OMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OMMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    OMFriendListModel *model = [self.friendArray objectAtIndex:indexPath.row];
    NSString *modelUrl = [[model.plus objectForKey:@"imgUrls"] firstObject];
    
    if (![OMCustomTool isNullObject:modelUrl]) {
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:modelUrl] placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
    }
    else{
        cell.userIcon.image = [UIImage imageNamed:@"userIcon.png"];
    }
    cell.titleLabel.text = model.plus[@"name"];
    cell.timeLabel.text = model.lastModifyTime;
    cell.ContentLabel.text = model.lastMessage;
    NSString *bageStr = [NSString stringWithFormat:@"%@", model.myUnReadCnt];
    
    if ([bageStr integerValue] == 0) {
        cell.bageLabel.hidden = YES;
    }
    else{
        cell.bageLabel.hidden = NO;
        cell.bageLabel.text = bageStr;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OMMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.bageLabel.hidden = YES;
    
    // prepare for detail page
    OMFriendListModel *model = [self.friendArray objectAtIndex:indexPath.row];
    OMMessageDetailVC *chatVC = [[OMMessageDetailVC alloc] init];
    chatVC.model = model;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
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
