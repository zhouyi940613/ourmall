//
//  OMMainViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMMainViewController.h"

#import "OMDefined.h"
#import "OMCustomTool.h"
#import "OMCustomNavigation.h"

#import "OMHomeViewController.h"
#import "OMMessageViewController.h"
#import "OMMyCartViewController.h"
#import "OMAccountsViewController.h"
#import "OMVisitorViewController.h"
#import "OMLoginViewController.h"

// JPush
#import <JPUSHService.h>
#import "NSString+MD5HexDigest.h"

@interface OMMainViewController ()<UITabBarControllerDelegate>

@property(nonatomic, strong) OMCustomNavigation *homeNavi;
@property(nonatomic, strong) OMCustomNavigation *messageNavi;
@property(nonatomic, strong) OMCustomNavigation *myCartNavi;
@property(nonatomic, strong) OMCustomNavigation *accountsNavi;
@property(nonatomic, strong) OMCustomNavigation *visitorNavi;

@property(nonatomic, assign) NSUInteger bageNumber;

@end

@implementation OMMainViewController

#pragma mark -- Screen Rotate Management
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark -- Image Render
- (UIImage *)makeOriginalImage:(NSString *)imageName{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)init{

    self = [super init];
    if (self) {
        
        // create tabBarItem
        OMHomeViewController *homeVC = [[OMHomeViewController alloc] init];
        homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[self makeOriginalImage:@"Home.png"] selectedImage:[self makeOriginalImage:@"Home-hover.png"]];
        
        OMMessageViewController *messageVC = [[OMMessageViewController alloc] init];
        messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Message" image:[self makeOriginalImage:@"Message.png"] selectedImage:[self makeOriginalImage:@"Message-hover.png"]];
        
        OMMyCartViewController *myCartVC = [[OMMyCartViewController alloc] init];
        myCartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Task" image:[self makeOriginalImage:@"Note.png"] selectedImage:[self makeOriginalImage:@"Note-hover.png"]];
        
        OMAccountsViewController *accountsVC = [[OMAccountsViewController alloc] init];
        accountsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[self makeOriginalImage:@"Male-User.png"] selectedImage:[self makeOriginalImage:@"Male-User-hover.png"]];
        
        OMVisitorViewController *visitorVC = [[OMVisitorViewController alloc] init];
        visitorVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[self makeOriginalImage:@"Male-User.png"] selectedImage:[self makeOriginalImage:@"Male-User-hover.png"]];
        
        // align center
        homeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        messageVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        myCartVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        accountsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        visitorVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        // navigation
        self.homeNavi = [[OMCustomNavigation alloc] initWithRootViewController:homeVC];
        self.messageNavi = [[OMCustomNavigation alloc] initWithRootViewController:messageVC];
        self.myCartNavi = [[OMCustomNavigation alloc] initWithRootViewController:myCartVC];
        self.accountsNavi = [[OMCustomNavigation alloc] initWithRootViewController:accountsVC];
        self.visitorNavi = [[OMCustomNavigation alloc] initWithRootViewController:visitorVC];
        
        // bagenumber initialize
        _bageNumber = 0;
    }
    return self;
}

#pragma mark - Change UI for Login&Logout Status
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (![OMCustomTool UserIsLoggingIn]) {
        
        [self logoutStatus];
    }
    else{
        
        [self loginStatus];
    }
    
   [NOTIFICATION_SETTING addObserver:self selector:@selector(loginStatus) name:OMUSER_STATUS_LOGIN object:nil];
    
   [NOTIFICATION_SETTING addObserver:self selector:@selector(logoutStatus) name:OMUSER_STATUS_LOGOUT object:nil];
}

// Login Status UI
- (void)loginStatus{
    // message
#if 1
    
    NSArray *tabs = @[self.homeNavi, self.messageNavi, self.myCartNavi, self.accountsNavi];
    self.viewControllers = [tabs copy];
    
#endif
    // no message
#if 0
    
    NSArray *tabs = @[self.homeNavi, self.myCartNavi, self.accountsNavi];
    self.viewControllers = [tabs copy];
    
#endif
}

- (void)logoutStatus{
  // message
#if 1
    
    NSArray *tabs = @[self.homeNavi, self.messageNavi, self.myCartNavi, self.visitorNavi];
    self.viewControllers = [tabs copy];

#endif
    
  // no message
#if 0
    
    NSArray *tabs = @[self.homeNavi, self.myCartNavi, self.visitorNavi];
    self.viewControllers = [tabs copy];
    
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // tabBar
    self.tabBar.backgroundColor = WhiteBackGroudColor;
    self.tabBar.translucent = YES;
    self.tabBar.tintColor = Rgb2UIColor(217, 79, 99);
    self.tabBar.shadowImage = [[UIImage alloc] init];
    [self setDelegate:self];
    
    // WebSocket Settings
    myWebSocket.delegate = nil;
    [myWebSocket close];
    
    myWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER_URL]]];
    myWebSocket.delegate = self;
    
    [self openWebSocketConection];
    
#if 0
    // add shadow up for footer
    CGRect rect = CGRectMake(0, -11, CGRectGetWidth(self.tabBar.frame), 11);
    UIImageView *footShadow = [[UIImageView alloc] initWithFrame:rect];
    footShadow.image = IMAGE(@"footer_top.png");
    [self.tabBar addSubview:footShadow];
#endif
    
}

#pragma mark -- Override TabBarController Method
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    // message
#if 1
    // limit the authority of visiting each tabbar （add login verification）
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 1) {
        
        if (![OMCustomTool UserIsLoggingIn]) {
            OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
                
            }];
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (index == 2)
    {
        if (![OMCustomTool UserIsLoggingIn]) {
            OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
                
            }];
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (index == 3)
    {
        return YES;
    }
    else{
        return YES;
    }
#endif
    
    // no message
#if 0
    
    // limit the authority of visiting each tabbar （add login verification）
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 1) {
        
        if (![OMCustomTool UserIsLoggingIn]) {
            OMLoginViewController *loginVC = [[OMLoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
                
            }];
            return NO;
        }
        else{
            return YES;
        }
    }
    
    else if (index == 2)
    {
        return YES;
    }
    else{
        return YES;
    }
    
#endif
    
}

#pragma mark -- Set TabBar Frame
- (void)viewWillLayoutSubviews{
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 50;
    tabFrame.origin.y = self.view.frame.size.height - 50;
    self.tabBar.frame = tabFrame;
    
}


#pragma mark - About WebSocket
- (void)openWebSocketConection{
    // open connection
//    [myWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSLog(@"WebSocket require data unRead message count!");
    
    [self requireData];
}

- (void)requireData{
    
    if (![OMCustomTool isNullObject:[SETTINGs objectForKey:OM_USER_LOGINKEY]]) {
        
        // require data : message unread number
        NSDictionary *paramDic = @{@"v" : @"2.0",
                                   @"ac" : @"init",
                                   @"loginKey" : [SETTINGs objectForKey:OM_USER_LOGINKEY],
                                   @"actions" : @[@"getUnRead"]
                                   };
        
        NSData *json = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil];
        NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        [myWebSocket send:str];
    }
    else{
        
        // longinKey disabled per 4 hours, require loginKey again
        [SETTINGs removeObjectForKey:OM_USER_LOGINKEY];
        [SETTINGs synchronize];
        
        if ([OMCustomTool UserIsLoggingIn]) {
            NSDictionary *paramDic = @{@"memberUid" : [SETTINGs objectForKey:OM_USER_UID]};
            [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_GET_LOGINKEY dateBlock:^(id dateBlock) {
                
                // save new loginkey in local
                [SETTINGs setObject:dateBlock[@"Data"][@"LoginKey"] forKey:OM_USER_LOGINKEY];
                [SETTINGs synchronize];
                
                // update
                [self requireData];
            }];
            
        }
        else{
            
        }
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSString *str = [NSString stringWithFormat:@"%@", message];
    NSDictionary *dicc = [self dictionaryWithJsonString:str];
    NSLog(@"Receive message unread number : %@", dicc);
    
    // ping : connected succeed
    if ([dicc[@"ac"] isEqualToString:@"ping"]) {
        // empty settings
    }
    // call when new message push
    else if ([dicc[@"ac"] isEqualToString:@"init"])
    {
        // bage number settings
        NSString *unReadNumber = dicc[@"getUnRead"][@"cnt"];
        
        if ([unReadNumber integerValue] > 0) {
           UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
           [item setBadgeValue:unReadNumber];
        }
        else{
            // empty settings
        }
        
        // close connenction
//        [myWebSocket close];
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
            
            // update
            [self requireData];
        }];
    }
    else{
        // empty
    }
}

#pragma mark - JSON To Dictionary
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"Json resolve failed with error : %@",error);
        return nil;
    }
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
