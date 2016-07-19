//
//  OMDefined.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

#define SETTINGs                [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_SETTING    [NSNotificationCenter defaultCenter]
#define APPLICATION_SETTING     [UIApplication sharedApplication]
#define APPDELEGATE             ((AppDelegate*)[[UIApplication sharedApplication] delegate])

// Default Color
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:(((float)r) / 255.0) green:(((float)g) / 255.0) blue:(((float)b) / 255.0) alpha:1.0]

#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define WhiteBackGroudColor      [UIColor whiteColor]
#define RedBackGroundColor       [UIColor redColor]
#define ClearBackGroundColor     [UIColor clearColor]
#define DefaultRedColor          Rgb2UIColor(217, 79, 99)
#define DefaultBackgroundColor   [UIColor colorWithWhite:0 alpha:0.7]
#define OMCustomRedColor         UIColorFromHex(0xdc5562)
#define OMCustomBlueColor        UIColorFromHex(0x55acee)
#define OMCustomOrangeColor      UIColorFromHex(0xf35c1f)
#define OMCustomGreenColor       Rgb2UIColor(77, 173, 74)
#define OMSeparatorLineColor     Rgb2UIColor(234, 235, 236)
#define OMMessageBackGroundColor UIColorFromHex(0xD9DAE5)



// Image Settings
#define IMAGE(IMAGE_NAME)  [UIImage imageNamed:IMAGE_NAME]

// Font Settings
#define FONT_REGULAR(SIZE)      [UIFont systemFontOfSize:SIZE]
#define FONT_LIGHT(SIZE)        [UIFont fontWithName:@"Lato-Light" size:SIZE]
#define FONT_BOLD(SIZE)         [UIFont boldSystemFontOfSize:SIZE]
#define FONT_ITALIC(SIZE)       [UIFont fontWithName:@"Lato-Italic" size:SIZE]

// Check IPhone and OS Version
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// Screen Size Settings
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


// Server URL
#define SERVER_URL           [NSString stringWithFormat:@"http://www.ourmall.com/interface/index.php?"]
#define WEBSOCKET_SERVER_URL [NSString stringWithFormat:@"ws://message.ourmall.com:7272"]
#define API_ACOUNT_ID        [NSString stringWithFormat:@"app_ios"]
#define VERIFIED_STRING      [NSString stringWithFormat:@"3a13de24a853e4a961f283c4e3a8b186"]
#define REQ_SUCCEED_CODE     [NSString stringWithFormat:@"9999"]
#define USER_ICONIMG         [NSString stringWithFormat:@"userIcon.png"]
#define OMPORDUCT_ICONIMG    [NSString stringWithFormat:@"productPlacer.png"]

#pragma mark - ALL API FOLLOWS

// 1
#pragma mark - OMAPI: Star Login
#define API_S_LOGIN    [NSString stringWithFormat:@"api.mall.sponsor.login"]

// 2
#pragma mark - OMAPI: Star Update Information
#define API_S_UPDATE    [NSString stringWithFormat:@"api.mall.sponsor.change"]

// 3
#pragma mark - OMAPI: Accessiable Task List
#define API_S_ACCESS_TASKLIST    [NSString stringWithFormat:@"api.mall.task.find"]

// 4
#pragma mark - OMAPI: Accessiable Task Detail
#define API_S_ACCESS_TASKDETAIL    [NSString stringWithFormat:@"api.mall.task.detail"]

// 5
#pragma mark - OMAPI: Task Apply
#define API_S_TASK_APPLY   [NSString stringWithFormat:@"api.mall.task.apply"]

// 6
#pragma mark - OMAPI: My Task List
#define API_S_TASK_LIST    [NSString stringWithFormat:@"api.mall.task.find4applied"]

// 7
#pragma mark - OMAPI: My Task Detail
#define API_S_TASK_DETAIL    [NSString stringWithFormat:@"api.mall.task.detail4applied"]

// 8
#pragma mark - OMAPI: Star Accept Task And Wait Pay From Seller
#define API_S_ACCEPT_WAITTING_PAY    [NSString stringWithFormat:@"api.mall.task.accept"]

// 9
#pragma mark - OMAPI: Star Complete Task On Platform
#define API_S_COMPLETE_TASK    [NSString stringWithFormat:@"api.mall.task.shared"]

// 10
#pragma mark - OMAPI: Get Share Content
#define API_S_GET_SHARECONTENT    [NSString stringWithFormat:@"api.mall.task.content4share"]

// 11
#pragma mark - OMAPI: Apply WithDraw
#define API_S_APPLY_WITHDRAW    [NSString stringWithFormat:@"api.mall.sponsor.cash"]

// 12
#pragma mark - OMAPI: Star Detail Information
#define API_S_DETAIL_INFORMATION    [NSString stringWithFormat:@"api.mall.sponsor.detail"]

// 13
#pragma mark - OMAPI: Star Account Detail
#define API_S_ACCOUNT_DETAIL    [NSString stringWithFormat:@"api.mall.sponsor.accountdetails"]

// 14
#pragma mark - OMAPI: Star SNS Account List
#define API_S_SNS_LIST    [NSString stringWithFormat:@"api.mall.sponsor.snsaccounts"]

// 15
#pragma mark - OMAPI: Star Add New SNS Account
#define API_S_ADD_NEWSNS    [NSString stringWithFormat:@"api.mall.sponsor.addsnsaccount"]

// 16
#pragma mark - OMAPI: Star Delete SNS Account
#define API_S_DEL_SNS    [NSString stringWithFormat:@"api.mall.sponsor.deletesnsaccount"]

// 17
#pragma mark - OMAPI: Require LoginKey Again
#define API_GET_LOGINKEY [NSString stringWithFormat:@"api.mall.member.getloginkey"]

// 18
#pragma mark - OMAPI: Send JPush Rigister Informations
#define API_SEND_JPUSH_RION [NSString stringWithFormat:@"api.mall.member.registdevice"]

// 19
#pragma mark - OMAPI: Remove JPush Rigister Informations
#define API_DELETE_JPUSH_RION [NSString stringWithFormat:@"api.mall.member.deletedevice"]


#pragma mark - SHOP PART API
// 20
#pragma mark - OMAPI: Reds Shop Orders List
#define API_SHOP_ORDERS_LIST [NSString stringWithFormat:@"api.mall.shop.orderlist"]

// 21
#pragma mark - OMAPI: Reds Shop Products List
#define API_SHOP_PRODUCT_LIST [NSString stringWithFormat:@"api.mall.shop.sponsorproductfind"]

// 22
#pragma mark - OMAPI:  Reds Shop Product Categories List
#define API_SHOP_PRODUCT_CATEGORIES_LIST [NSString stringWithFormat:@"api.mall.shop.categorylist"]

//// 23
//#pragma mark - OMAPI: Send JPush Rigister Informations
//#define API_SEND_JPUSH_RION [NSString stringWithFormat:@"api.mall.member.registdevice"]
//
//// 24
//#pragma mark - OMAPI: Send JPush Rigister Informations
//#define API_SEND_JPUSH_RION [NSString stringWithFormat:@"api.mall.member.registdevice"]
//
//// 25
//#pragma mark - OMAPI: Send JPush Rigister Informations
//#define API_SEND_JPUSH_RION [NSString stringWithFormat:@"api.mall.member.registdevice"]

#pragma mark - OMAPI: API Parameters Keys

#define OM_FACEBOOK_TOKEN       [NSString stringWithFormat:@"facebookToken"]
#define OM_TWITTER_TOKEN        [NSString stringWithFormat:@"twitterToken"]

#define OM_USER_ID              [NSString stringWithFormat:@"id"]
#define OM_USER_NAME            [NSString stringWithFormat:@"name"]
#define OM_USER_PAYPALACCOUNT   [NSString stringWithFormat:@"paypalAccount"]
#define OM_USER_MEMBER_TYPE     [NSString stringWithFormat:@"memberType"]
#define OM_USER_ICON            [NSString stringWithFormat:@"portrait"]
#define OM_USER_LOGINKEY        [NSString stringWithFormat:@"loginKey"]
#define OM_USER_UID             [NSString stringWithFormat:@"uid"]
#define OM_USER_BALANCE         [NSString stringWithFormat:@"balance"]
#define OM_USER_FROZENACCOUNT   [NSString stringWithFormat:@"frozenAmount"]
#define OM_MESSAGE_LIST_CACHE   [NSString stringWithFormat:@"messageList_cache"]
#define OM_MESSAGE_DETAIL_CACHE [NSString stringWithFormat:@"messageDetail_cache"]


#pragma mark - OMNOTIFICATION: Notification Name

#define OMUSER_STATUS_LOGIN    [NSString stringWithFormat:@"USER_IS_LOGGING_IN"]
#define OMUSER_STATUS_LOGOUT   [NSString stringWithFormat:@"USER_IS_LOGGED_OUT"]

#define OMHOME_STYLE_LARGE     [NSString stringWithFormat:@"HOME_STYLE_LARGE"]
#define OMHOME_STYLE_MINI      [NSString stringWithFormat:@"HOME_STYLE_MINI"]

#define OMHISTORY_ARRAY        [NSString stringWithFormat:@"HOME_HISTORY_ARRAY"]
#define OMSEARCH_TIMES         [NSString stringWithFormat:@"OMSEARCH_TIMES"]

#define OMWEBSOCKT_STATUS      [NSString stringWithFormat:@"OMSOCKET_STATUS"]

#pragma mark - CONTACT_URL : Contact us On Url

#define OMCONTACT_FACEBOOK      [NSString stringWithFormat:@"https://facebook.com/ourmallapp"]
#define OMCONTACT_TWITTER       [NSString stringWithFormat:@"https://twitter.com/Ourmall_app"]
#define OMCONTACT_INSTAGRAM     [NSString stringWithFormat:@"https://instagram.com/ourmall_cn"]

#define OMFACEBOOK_LOGIN_SUCCEED    [NSString stringWithFormat:@"facebookLoginSucceedKey"]
#define OMTWITTER_LOGIN_SUCCEED     [NSString stringWithFormat:@"twitterLoginSucceedKey"]

#pragma mark - OMTASK_STATUS
#define OMAPPLY                 [NSString stringWithFormat:@"Apply"]
#define OMPENDING               [NSString stringWithFormat:@"Pending"]
#define OMAUTHORITY             [NSString stringWithFormat:@"Connect"]
#define OMSHARE                 [NSString stringWithFormat:@"Share"]
#define OMCOMPLETE              [NSString stringWithFormat:@"Check"]

#pragma mark - TWITTER & APPSFLYER INFORMATIONS SETTINGS
#define TW_CONSUMER_KEY    @"tnHn0uOTFV0P7ri2Q5vXR2Wcz"
#define TW_CONSUMER_SECRET @"jrqNMqrdPRvbm1WpsGiGf0ekuENfwY4HIiVrXT9ZxLFg8tJpxQ"

#define APPSFLYER_DEV_KEY [NSString stringWithFormat:@"FrSRZkYxL4JBSnAnRfGRW5"]
#define APPSFLYER_App_ID  [NSString stringWithFormat:@"1103193691"]


#pragma mark - APPSFLYER_PARAMETERS

#define OMAF_DEVICE_ID             @"userDeviceId"
#define OMAF_USER_ID               @"userId"

// OMAF_EVENT_HOMEPAGE_VIEWCOUNT
#define OMAF_VIEWCOUNTS            @"viewCounts"

// OMAF_EVENT_TASK_CLICK
#define OMAF_TASK_ID               @"taskId"


#pragma mark - AppsFlyer Event Name List

#define OMAF_EVENT_HOMEPAGE_VIEWCOUNT  @"homePageViewCounts"
#define OMAF_EVENT_TASK_CLICK          @"taskClickEvent"


#pragma mark - ABOUT MESSAGE
#define OMSOCKET_SERVER   @"ws://message.ourmall.com:7272"

#pragma mark - ABOUT JPUSH
#define OMJPUSH_APP_KEY   @"4f64ecdf34170e40f7bebfab"

// appkey[2] 08c253a175acb5b6a587d544



