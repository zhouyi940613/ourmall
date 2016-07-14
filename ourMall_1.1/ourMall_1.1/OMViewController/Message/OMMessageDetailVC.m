//
//  OMMessageDetailVC.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/4.
//  Copyright © 2016年 MaBang. All rights reserved.
//
#import "UINavigationItem+Loading.h"
#import "OMMessageDetailVC.h"
#import "OMChatModel.h"

@interface OMMessageDetailVC ()<UITextViewDelegate>

@property (strong, nonatomic) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic ,strong) UIView *bottomContainerView;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) CGFloat newCellHeght;
@property (nonatomic, assign) NSInteger current_lines;
@property (nonatomic, strong) UIActivityIndicatorView *progressAty;

@end

@implementation OMMessageDetailVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _chatArray = [NSMutableArray array];
        _newCellHeght = 0;
        _current_lines = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Chat Message";
    [self loadUI];
    
    myWebSocket.delegate = nil;
    [myWebSocket close];
    
    myWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://message.ourmall.com:7272"]]];
    myWebSocket.delegate = self;
    [self openWebSocketConnection];
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
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

#pragma mark - Load UI Settings
- (void)loadUI{
    
    // tableView
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = UIColorFromHex(0xe0e1ea);
    
    // input area
    self.bottomContainerView = [[UIView alloc] init];
    [self.view addSubview:self.bottomContainerView];
    self.bottomContainerView.backgroundColor = UIColorFromHex(0xf7f8f9);
    self.bottomContainerView.frame = CGRectMake(0, self.chatTableView.frame.size.height, SCREEN_WIDTH, 50);
    
    // input textView
    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 8, SCREEN_WIDTH - 100, 34)];
    [self.bottomContainerView addSubview:self.inputTextView];
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.layer.borderColor = UIColorFromHex(0xe0e1ea).CGColor;
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.delegate = self;
    
    // send button
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 8, 60, 34);
    [self.bottomContainerView addSubview:self.sendBtn];
    [self.sendBtn addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn setImage:IMAGE(@"sendMsg.png") forState:UIControlStateNormal];
    
    // loading progress
    self.progressAty = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.progressAty.center = CGPointMake(0, 0);
    [self.progressAty setHidesWhenStopped:YES];
}

#pragma mark - Require Data
- (void)openWebSocketConnection{
    
    // open connection
    [myWebSocket open];
    NSLog(@"WebSocket open success!");

}
- (void)requireData{
    
    // load local cache data
    NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [sandBoxPath stringByAppendingString:[NSString stringWithFormat:@"/%@_OMMessageDetailCache.plist", self.model.subjectPid]];
    NSArray *cacheArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    if (cacheArray.count > 0) {
        for (OMChatModel *model in cacheArray) {
            [self.chatArray addObject:model];
            [self.chatTableView reloadData];
            
            [self.hud hide:YES];
        }
        
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - 1)];
    }
    else{
        self.chatArray = [NSMutableArray array];
    }
}

- (void)requireNewData{
    
    if (![OMCustomTool isNullObject:[SETTINGs objectForKey:OM_USER_LOGINKEY]]) {
        
        // require data from server
        NSDictionary *paramDic = @{@"v" : @"2.0",
                                   @"ac" : @"init",
                                   @"loginKey" : [SETTINGs objectForKey:OM_USER_LOGINKEY],
                                   @"actions" : @[@"getChatContent"],
                                   @"subjectPid" : self.model.subjectPid
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

#pragma mark - Open WebSocket Connection
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSLog(@"WebSocket require message detail!");
    
    [self requireNewData];
}

#pragma mark - WebSocket DidReceive Message
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *str = [NSString stringWithFormat:@"%@", message];
    NSDictionary *dicc = [self dictionaryWithJsonString:str];
    NSLog(@"receive informations : %@", dicc);
    
    // ping : connected succeed
    if ([dicc[@"ac"] isEqualToString:@"ping"]) {
        
    }
    else if ([dicc[@"ac"] isEqualToString:@"init"])
    {
        [self.progressAty stopAnimating];
        
        // data update
        if (![dicc[@"getChatContent"][@"contents"] isKindOfClass:[NSNull class]]) {
            
            NSString *flag = [NSString stringWithFormat:@"%@", dicc[@"getChatContent"][@"isFirst"]];
            
            // isFirst = 1 initialize array of sessions
            if ([flag integerValue] == 1) {
                
                // stop center loading animation
                [self.navigationItem stopAnimating];
                
                self.chatArray = [OMChatModel ModelArr_With_DictionaryArr:dicc[@"getChatContent"][@"contents"]];
                self.chatArray = (NSMutableArray *)[[self.chatArray reverseObjectEnumerator] allObjects];
                
                
                [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - 1)];
                [self.chatTableView reloadData];
                
                // local cache
                NSArray *cacheArray = [NSArray arrayWithArray:self.chatArray];
                NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

                NSString *cachePath = [sandBoxPath stringByAppendingString:[NSString stringWithFormat:@"/%@_OMMessageDetailCache.plist", self.model.subjectPid]];
                [NSKeyedArchiver archiveRootObject:cacheArray toFile:cachePath];
                NSLog(@"message detail cache path : %@", sandBoxPath);
            }
            // isFirst = 0 send message array of sessions
            else{
                
// session cache when connect with socket succeed
#if 0
                OMChatModel *tempModel = self.chatArray.lastObject;
                
                [SETTINGs setValue:tempModel.content forKey:@"lastSession"];
                [SETTINGs synchronize];
                [SETTINGs setValue:self.model.subjectPid forKey:@"lastSessionID"];
                [SETTINGs synchronize];
#endif
                [self.chatArray removeLastObject];
                
                NSMutableArray *array = [OMChatModel ModelArr_With_DictionaryArr:dicc[@"getChatContent"][@"contents"]];
                
                for (OMChatModel *item in array) {
                    [self.chatArray addObject:item];
                }
                
                // local cache
                NSArray *cacheArray = [NSArray arrayWithArray:self.chatArray];
                NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                NSString *cachePath = [sandBoxPath stringByAppendingString:[NSString stringWithFormat:@"/%@_OMMessageDetailCache.plist", self.model.subjectPid]];
                [NSKeyedArchiver archiveRootObject:cacheArray toFile:cachePath];
                NSLog(@"message detail cache path : %@", sandBoxPath);
                
                [self.chatTableView reloadData];
            }
            
            
            // remove loading
            [self.hud hide:YES];
        }
    }
    else if ([dicc[@"ac"] isEqualToString:@"logout"]){
        
        [myWebSocket close];
        
        // remove loading
        [self.hud hide:YES];
    }
    else{
        // empty
    }
    
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.newCellHeght == 0) {
        return 100.0 + 40;
    }
    else{
        return _newCellHeght + 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.chatArray.count > 0) {
        
        return self.chatArray.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    
    OMChatModel *model = [self.chatArray objectAtIndex:indexPath.row];
    
    //create userIocn
    UIImageView *photo;
    UILabel *timeLabel;
    
    // sender
    if ([model.memberType integerValue] == 5) {
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 50, 50)];
        [cell addSubview:photo];
        [OMCustomTool setcornerOfView:photo withRadius:25 color:ClearBackGroundColor];
        
        NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        UIImage *userIcon = [OMCustomTool loadImage:@"OMMyUserIcon" ofType:@"png" inDirectory:sandBoxPath];
        photo.image = userIcon;
        
        [cell addSubview:[self bubbleView:model.content from:YES withPosition:65]];
        
        [cell addSubview:self.progressAty];
    }
    // receiver
    else{
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell addSubview:photo];
        [OMCustomTool setcornerOfView:photo withRadius:25 color:ClearBackGroundColor];
        
        [OMCustomTool SDSetImageView:photo withURLString:model.portrait andPlacehoderImageName:OM_USER_ICON];
        
        [cell addSubview:[self bubbleView:model.content from:NO withPosition:65]];
    }
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, 10 + self.newCellHeght, 150, 20)];
    timeLabel.textAlignment = 1;
    timeLabel.backgroundColor = UIColorFromHex(0xe0e1ea);
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:timeLabel];
    timeLabel.text = model.timeCreated;
    
    cell.backgroundColor = UIColorFromHex(0xe0e1ea);
    
    return cell;
    
}

#pragma mark - Text Message Style Settings
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //figure out size
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    // background image
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width / 2) topCapHeight:floorf(bubble.size.height / 2)]];
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf ? 19.0f : 22.0f, 20.0f, size.width + 10, size.height + 10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 20.0f);
    
    if(fromSelf){
        returnView.frame = CGRectMake(SCREEN_WIDTH - position - (bubbleText.frame.size.width + 30.0f), 0.0f, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 30.0f);
        bubbleText.textColor = WhiteBackGroudColor;
        
        self.progressAty.center = CGPointMake(returnView.frame.origin.x - 15, 33);
        
    }
    else{
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width + 30.0f, bubbleText.frame.size.height + 30.0f);
    }
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    self.newCellHeght = returnView.frame.size.height + 10;
    
    return returnView;
}


#pragma mark - Send Button Clicked Action
- (void)sendMessageAction:(UIButton *)btn{
    
    self.current_lines = 1;
    
    [self.inputTextView resignFirstResponder];
    
    // loading
    [self.progressAty startAnimating];
    
    NSInteger random = arc4random() % (999999999999999 - 100000000000000 + 1) + 100000000000000;
    NSString *randomStr = [NSString stringWithFormat:@"%ld", random];
    
    // insert item
    OMChatModel *model = [[OMChatModel alloc] init];
    model.content = self.inputTextView.text;
    model.memberType = @"5";
    [self.chatArray addObject:model];
    
// session cache ignore connection status
#if 1
    
    [SETTINGs setValue:model.content forKey:@"lastSession"];
    [SETTINGs synchronize];
    [SETTINGs setValue:self.model.subjectPid forKey:@"lastSessionID"];
    [SETTINGs synchronize];
    
#endif
    
    [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height - 1)];
    
    [self.chatTableView reloadData];
    
    if (self.inputTextView.text) {
        // send message
        NSDictionary *paramDic = @{@"v"             : @"2.0",
                                   @"ac"            : @"say",
                                   @"loginKey"      : [SETTINGs objectForKey:OM_USER_LOGINKEY],
                                   @"subjectPid"    : self.model.subjectPid,
                                   @"content"       : self.inputTextView.text,
                                   @"chatRandomKey" : randomStr
                                   };
        
        NSData *json = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil];
        NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        [myWebSocket send:str];
    }
    else{
        [OMCustomTool OMshowAlertViewWithMessage:@"No message send!" fromViewController:self];
    }
    
    // clear input textView
    self.inputTextView.text = [NSString string];
    self.bottomContainerView.frame = CGRectMake(0, self.chatTableView.frame.size.height, SCREEN_WIDTH, 34);
    self.inputTextView.frame = CGRectMake(20, 8, SCREEN_WIDTH - 100, 34);
    self.sendBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 8, 70, 34);
}

- (CGSize)stringHeightWithMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font fromText:(NSString *)text{
    
    return  [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (CGSize)stringWidthWithMaxHeight:(CGFloat)maxHeight andFont:(UIFont*)font fromText:(NSString *)text{
    
    return  [text boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark - TextView Delegate Method
- (void)textViewDidChange:(UITextView *)textView{
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGSize size = [self stringHeightWithMaxWidth:SCREEN_WIDTH - 100 andFont:font fromText:textView.text];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [textView setContentInset:inset];
    
    NSInteger minLineHeight = 19;
    
    NSInteger lines = size.height / minLineHeight;
    
    if (lines > 5) {
        [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, 18 * 5 + 5)];
        
        CGSize newSize = CGSizeMake(SCREEN_WIDTH, MAX(5 * minLineHeight, 34) + 10);
        
        self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, self.bottomContainerView.frame.origin.y, newSize.width, 18 * 5 + 5 + 16);
    }
    else{
        [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, MAX(size.height, 34))];
    }
    
    if (lines > self.current_lines) {
        
        CGSize newSize = CGSizeMake(SCREEN_WIDTH, MAX(lines * minLineHeight, 34) + 10);
        
        if (lines > 5) {
            [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, 18 * 5 + 5)];
            
            CGSize newSize = CGSizeMake(SCREEN_WIDTH, MAX(5 * minLineHeight, 34) + 10);
            
            self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, self.bottomContainerView.frame.origin.y, newSize.width, 18 * 5 + 5 + 16);
        }
        else{
            [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, MAX(size.height, 34))];
            
            self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, self.bottomContainerView.frame.origin.y - minLineHeight, newSize.width, newSize.height);
        }
        
        self.current_lines = lines;
    }
    else if (lines < self.current_lines)
    {
        
        CGSize newSize = CGSizeMake(SCREEN_WIDTH, MAX(lines * minLineHeight, 34) + 10);
        
        if (lines > 5) {
            [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, 18 * 5 + 5)];
            
            CGSize newSize = CGSizeMake(SCREEN_WIDTH, MAX(5 * minLineHeight, 34) + 10);
            
            self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, self.bottomContainerView.frame.origin.y, newSize.width, 18 * 5 + 5 + 16);
        }
        else{
            [textView setFrame:CGRectMake(20, 5, SCREEN_WIDTH - 100, MAX(size.height, 34))];
            
            self.bottomContainerView.frame = CGRectMake(self.bottomContainerView.frame.origin.x, self.bottomContainerView.frame.origin.y + minLineHeight, newSize.width, newSize.height);
        }
        
        self.current_lines = lines;
    }
    else{
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGSize size = [self stringHeightWithMaxWidth:SCREEN_WIDTH - 100 andFont:[UIFont systemFontOfSize:14.0] fromText:textView.text];
    
//    self.progressAty.center = CGPointMake(SCREEN_WIDTH - size.width - 50 - 65, 33);
}

#pragma mark - Fix Bug Of Didmiss NavigationBar
//-(void)loadView{
//
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}

#pragma mark - JSON Dictionary Tool
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json analyzing failed：%@",err);
        return nil;
    }
    return dic;
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
