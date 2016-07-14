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
    
    // socket settings
    myWebSocket.delegate = nil;
    [myWebSocket close];
    
    myWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://message.ourmall.com:7272"]]];
    myWebSocket.delegate = self;
    [self openWebSocketConnection];
    
    // add loading
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud hide:YES];
    
    [self requireData];
    
    // show center loading animation
    [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionCenter];
}

#pragma mark - WebSocket Life Cycle
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    // socket settings
    myWebSocket.delegate = nil;
    [myWebSocket close];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    // update local file
    [self requireData];
    
}

#pragma mark - Require Data
- (void)openWebSocketConnection{
    // open connection
    [myWebSocket open];
}

- (void)requireData{
    
    // initialize array to prevent load history records
    self.friendArray = [NSMutableArray array];
    
    // load local cache data
    NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [sandBoxPath stringByAppendingString:@"/OMMessageListCache.plist"];
    NSArray *cacheArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    if (cacheArray.count > 0) {
        
        for (OMFriendListModel *model in cacheArray) {
            [self.friendArray addObject:model];
        }
        
        if (![OMCustomTool isEmptyString:[SETTINGs objectForKey:@"lastSession"]]) {
            
            for (OMFriendListModel *model in cacheArray) {
                if ([model.subjectPid isEqualToString:[SETTINGs objectForKey:@"lastSessionID"]]) {
                    model.lastMessage = [SETTINGs objectForKey:@"lastSession"];
                    model.myUnReadCnt = @"0";
                }
            }
            
            // update cache
           [NSKeyedArchiver archiveRootObject:cacheArray toFile:cachePath];
        }
        else{
            // last session cache empty
        }
        
        [self.tableViewMessage reloadData];
        [self.hud hide:YES];
    }
    else{
        [self.hud show:YES];
        
        self.friendArray = [NSMutableArray array];
    }
}

- (void)requireNewData{
    
    if (![OMCustomTool isNullObject:[SETTINGs objectForKey:OM_USER_LOGINKEY]]) {
        
        // require data : session list
        NSDictionary *paramDic = @{@"v" : @"2.0",
                                   @"ac" : @"init",
                                   @"loginKey" : [SETTINGs objectForKey:OM_USER_LOGINKEY],
                                   @"actions" : @[@"getUnRead"],
                                   @"isSubjectListPage" : @"1"
                                   };
        
        NSData *json = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil];
        NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        [myWebSocket send:str];
    }
    else{
        
        // longinKey disabled per 4 hours, require loginKey again
        [SETTINGs removeObjectForKey:OM_USER_LOGINKEY];
        [SETTINGs synchronize];
        
        NSDictionary *paramDic = @{@"memberUid" : [SETTINGs objectForKey:OM_USER_UID]};
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_GET_LOGINKEY dateBlock:^(id dateBlock) {
            
            // save new loginkey in local
            [SETTINGs setObject:dateBlock[@"Data"][@"LoginKey"] forKey:OM_USER_LOGINKEY];
            [SETTINGs synchronize];
            
            // update
            [self requireNewData];
        }];
    }
}

#pragma mark - WebSocket Connected Succeed & Failed
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSLog(@"WebSocket Require Message Session Lists!");
    
    [self requireNewData];
    
}
// connected failed
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    NSLog(@":( Websocket Failed With Error %@", error);
    myWebSocket = nil;
}

#pragma mark - WebSocket Data Return
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSString *str = [NSString stringWithFormat:@"%@", message];
    NSDictionary *dicc = [self dictionaryWithJsonString:str];
    NSLog(@"Receive Session List : %@", dicc);
    [self.hud hide:YES];
    
    // ping : connected succeed
    if ([dicc[@"ac"] isEqualToString:@"ping"]) {
        // empty resolve
    }
    // call when new message push
    else if ([dicc[@"ac"] isEqualToString:@"init"])
    {
        // data update
        if (![dicc[@"getUnRead"][@"subjects"] isKindOfClass:[NSNull class]]) {
            self.friendArray = [OMFriendListModel ModelArr_With_DictionaryArr:dicc[@"getUnRead"][@"subjects"]];
            
            // stop center loading animation
            [self.navigationItem stopAnimating];
            
            [self.tableViewMessage reloadData];
            
            // local cache
            NSArray *cacheArray = [NSArray arrayWithArray:self.friendArray];
            NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *cachePath = [sandBoxPath stringByAppendingString:@"/OMMessageListCache.plist"];
            
             NSLog(@"message list cache path : %@", sandBoxPath);
             NSLog(@"cache list cache path : %@", cachePath);
            
            [NSKeyedArchiver archiveRootObject:cacheArray toFile:cachePath];
        }
    }
    // call when loginkey disabled
    else if ([dicc[@"ac"] isEqualToString:@"logout"]){
        
        // longinKey disabled per 4 hours, require loginKey again
        [SETTINGs removeObjectForKey:OM_USER_LOGINKEY];
        [SETTINGs synchronize];
    
        NSDictionary *paramDic = @{@"memberUid" : [SETTINGs objectForKey:OM_USER_UID]};
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_GET_LOGINKEY dateBlock:^(id dateBlock) {
            
            // save new loginkey in local
            [SETTINGs setObject:dateBlock[@"Data"][@"LoginKey"] forKey:OM_USER_LOGINKEY];
            [SETTINGs synchronize];
            
            // update data
            [self requireNewData];
        }];
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
