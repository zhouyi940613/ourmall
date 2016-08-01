//
//  AppDelegate.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <AdSupport/AdSupport.h>

#import "AppDelegate.h"

#import "OMDefined.h"
#import "OMCustomTool.h"
#import "OMCustomNavigation.h"

#import "OMSplashViewController.h"
#import "OMMainViewController.h"
#import "OMMessageViewController.h"

// Facebook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Twitter
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>

// AppsFlyer
#import <AppsFlyer/AppsFlyer.h>

// JPush
#import <JPUSHService.h>

// keyboard
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // set status bar
    [APPLICATION_SETTING setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [APPLICATION_SETTING setStatusBarHidden:NO];
    
    // set navigationBar
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:UIColorFromHex(0xffffff),
                                 NSFontAttributeName:FONT_REGULAR(17.0),
                                 NSShadowAttributeName:shadow,
                                 };
    UIImage *backgroundImage = IMAGE(@"bannerIng.jpg");
    backgroundImage = [OMCustomTool stretchImageFromCenter:backgroundImage];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setTintColor:WhiteBackGroudColor];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:UIColorFromHex(0x40aefe)];
    
    // custom style for navigationabar loading
    [UIActivityIndicatorView appearanceWhenContainedIn:[UINavigationBar class], nil].color = [UIColor whiteColor];
    
    [self showMainViewController];
    
#if 1
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"sandbox Path : %@", path);
#endif
    
    
    // facebook settings
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    // Override point for customization after application launch.
    [FBSDKLoginButton class];
    
    // twitter settings
    [[Twitter sharedInstance] startWithConsumerKey:TW_CONSUMER_KEY consumerSecret:TW_CONSUMER_SECRET];
    [Fabric with:@[[Twitter class], [Crashlytics class]]];
    
    
    // AppsFlyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = APPSFLYER_DEV_KEY;
    [AppsFlyerTracker sharedTracker].appleAppID = APPSFLYER_App_ID;
    
    
    // JPush Settings
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // JPush Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // custom edit categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    // JPush Required
#if 1
    // development
    [JPUSHService setupWithOption:launchOptions appKey:OMJPUSH_APP_KEY
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
#endif
    
#if 0
    // distrubuttion
    [JPUSHService setupWithOption:launchOptions appKey:OMJPUSH_APP_KEY
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:advertisingId];
#endif
    
    // settings for keyboard
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // WebSocket Settings
    myWebSocket.delegate = nil;
    [myWebSocket close];
    
    myWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER_URL]]];
    myWebSocket.delegate = self;
    [myWebSocket open];
    
    // unRead count
    [NOTIFICATION_SETTING addObserver:self selector:@selector(sendForUnReadCount) name:OMWEBSOCKET_UNREADCOUNTREQUEST object:nil];
    // session list
    [NOTIFICATION_SETTING addObserver:self selector:@selector(sendForGetSessionList) name:OMWEBSOCKET_SESSIONLISTREQUEST object:nil];
    // session detail
    [NOTIFICATION_SETTING addObserver:self selector:@selector(sendForGetSessionDetail:) name:OMWEBSOCKET_SESSIONDETAILREQUEST object:nil];
    // send message
    [NOTIFICATION_SETTING addObserver:self selector:@selector(sendMessage:) name:OMWEBSOCKET_SENDMESSAGE object:nil];
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(socketOpenAction) name:OMWEBSOCKET_OPEN object:nil];
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(socketCloseAction) name:OMWEBSOCKET_CLOSE object:nil];
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(socketOpenAction) name:OMAPP_ENTER_FOREGROUND object:nil];
    
   
    
    // jump to specific page
//    if (launchOptions) {
//        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (remoteNotification) {
//            NSLog(@"推送消息==== %@",remoteNotification);
//            [self goToMssageViewControllerWith:remoteNotification];
//        }
//    }
    
    return YES;
}



- (void)showMainViewController{
    
    OMMainViewController *mainVC = [[OMMainViewController alloc] init];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = WhiteBackGroudColor;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // socket settings
    myWebSocket.delegate = nil;
    [myWebSocket close];
    [SETTINGs setValue:@"off" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [NOTIFICATION_SETTING postNotificationName:OMAPP_ENTER_FOREGROUND object:nil];
    
    // clear bage
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // facebook setting
    [FBSDKAppEvents activateApp];
    
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
    // clear bage
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    
    myWebSocket.delegate = nil;
    [myWebSocket close];
    [SETTINGs setValue:@"off" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];
    
}

#pragma mark - Facebook Settings
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


#pragma mark - JPush Settings
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - register DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
}

#pragma mark - Jump
- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{

    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"push"forKey:@"push"];
    [pushJudge synchronize];
    NSString * userId = [msgDic objectForKey:@"memberUid"];
    
    if ([userId isEqualToString:[SETTINGs objectForKey:OM_USER_UID]]) {
        
        OMMessageViewController * VC = [[OMMessageViewController alloc]init];
        OMCustomNavigation * Nav = [[OMCustomNavigation alloc]initWithRootViewController:VC];
        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    [self goToMssageViewControllerWith:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - About WebSocket
- (void)socketOpenAction{
    
    myWebSocket.delegate = nil;
    [myWebSocket close];
    [SETTINGs setValue:@"off" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];
    
    myWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER_URL]]];
    myWebSocket.delegate = self;
    [myWebSocket open];
}

- (void)socketCloseAction{
    
    [myWebSocket close];
    [SETTINGs setValue:@"off" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    [SETTINGs setValue:@"on" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];

    NSLog(@"WebSocket Connection Succeed!");
    
    // connencted succeed notice
    [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_CONNECTED object:nil];

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    [SETTINGs setValue:@"off" forKey:OMWEBSOCKT_STATUS];
    [SETTINGs synchronize];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    NSString *str = [NSString stringWithFormat:@"%@", message];
    NSDictionary *dicc = [self dictionaryWithJsonString:str];
    
     NSLog(@"WebSocket Received Informations : %@", dicc);
    
    if ([dicc[@"ac"] isEqualToString:@"ping"]) {
    }
    else if ([dicc[@"ac"] isEqualToString:@"init"])
    {
        // classisy
        if (![OMCustomTool isNullObject:dicc[@"getUnRead"]] && [OMCustomTool isNullObject:dicc[@"getChatContent"]]) {
            
            // unRead count and session list
                // unRead count
                NSString *unReadCountStr = dicc[@"getUnRead"][@"cnt"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_UNREADCOUNT object:nil userInfo:@{@"unReadCnt" : unReadCountStr}];
                
                // session list
                NSArray *sessionListArr = [NSArray array];
                sessionListArr = dicc[@"getUnRead"][@"subjects"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_SESSIONLIST object:nil userInfo:@{@"sessionList" : sessionListArr, @"status" : @"init"}];
            
        }
        else if (![OMCustomTool isNullObject:dicc[@"getChatContent"]] && [OMCustomTool isNullObject:dicc[@"getUnRead"]])
        {
           
            NSString *flag = [NSString stringWithFormat:@"%@", dicc[@"getChatContent"][@"isFirst"]];
            
            if ([flag integerValue] == 1) {
                // initailize list
                NSArray *sessionArr = [NSArray array];
                sessionArr = dicc[@"getChatContent"][@"contents"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_SESSIONDETAIL object:nil userInfo:@{@"chatList" : sessionArr}];
            }
            else{
                // = 0 new data
            }
        }
        else if (![OMCustomTool isNullObject:dicc[@"getChatContent"]] && ![OMCustomTool isNullObject:dicc[@"getUnRead"]])
        {
            // receive new message return data
            NSString *flag = [NSString stringWithFormat:@"%@", dicc[@"getChatContent"][@"isFirst"]];
            
            // new talk
            if ([flag integerValue] == 0) {
                // new item
                NSArray *newArr = [NSArray array];
                newArr = dicc[@"getChatContent"][@"contents"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_SESSIONDETAIL_NEW object:nil userInfo:@{@"newChat" : newArr}];
                
                // update style
                
                // unRead count and session list
                // unRead count
                NSString *unReadCountStr = dicc[@"getUnRead"][@"cnt"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_UNREADCOUNT object:nil userInfo:@{@"unReadCnt" : unReadCountStr}];
                
                // session list
                NSArray *sessionListArr = [NSArray array];
                sessionListArr = dicc[@"getUnRead"][@"subjects"];
                [NOTIFICATION_SETTING postNotificationName:OMWEBSOCKET_SESSIONLIST object:nil userInfo:@{@"sessionList" : sessionListArr, @"status" : @"new"}];
            }
            else{
                // = 1 initialize list
            }
        }
        else{
            NSLog(@"Return Data Error");
        }
    }
    else if ([dicc[@"ac"] isEqualToString:@"logout"])
    {
        NSLog(@"logout message");
        
        [OMCustomTool OMRequestForNewLoginKey];
        // 重新请求数据（重新send）
        // 备注:待定
    }
    else{
        NSLog(@"other message");
    }

}


#pragma mark - Send Method With Notification
- (void)sendForUnReadCount{
    
    if ([[SETTINGs objectForKey:OMWEBSOCKT_STATUS] isEqualToString:@"on"]) {
        [myWebSocket send:[OMCustomTool OMReturnParametersWithDicForSessionList]];
    }
    else{
        [self performSelector:@selector(sendForUnReadCount) withObject:nil afterDelay:1.5];
    }
}

- (void)sendForGetSessionList{
    
    if ([[SETTINGs objectForKey:OMWEBSOCKT_STATUS] isEqualToString:@"on"]) {
        [myWebSocket send:[OMCustomTool OMReturnParametersWithDicForSessionList]];
    }
    else{
        [self performSelector:@selector(sendForGetSessionList) withObject:nil afterDelay:1.5];
    }
}

- (void)sendForGetSessionDetail:(NSNotification *)notice{
    
    if ([[SETTINGs objectForKey:OMWEBSOCKT_STATUS] isEqualToString:@"on"]) {
        
        [myWebSocket send:notice.userInfo[@"sessionDetail"]];
    }
    else{
        [self performSelector:@selector(sendForGetSessionDetail:) withObject:nil afterDelay:1.5];
    }
}

- (void)sendMessage:(NSNotification *)notice{
    
    if ([[SETTINGs objectForKey:OMWEBSOCKT_STATUS] isEqualToString:@"on"]) {
        
        [myWebSocket send:notice.userInfo[@"messageContent"]];
    }
    else{
        [self performSelector:@selector(sendMessage:) withObject:nil afterDelay:1.5];
    }
}


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

@end
