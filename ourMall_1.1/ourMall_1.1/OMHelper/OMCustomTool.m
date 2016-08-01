//
//  OMCustomTool.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMCustomTool.h"

#import "OMDefined.h"

#import "GTMBase64.h"
#import "NSString+MD5HexDigest.h"

// Facebook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

// twitter settings
#import <TwitterKit/TwitterKit.h>

// jpush
#import <JPUSHService.h>

@implementation OMCustomTool

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}
#pragma mark - VARIFY ABOUT LOGIN
+ (BOOL)UserIsLoggingIn{
    
    if (![SETTINGs objectForKey:OM_USER_ID]) {
        
        NSLog(@" Current User ID : %@", [SETTINGs objectForKey:OM_USER_ID]);
        return NO;
    }
    NSLog(@" Current User ID : %@", [SETTINGs objectForKey:OM_USER_ID]);
    return YES;
}


#pragma mark - VALUE TYPE VARIFY
+ (BOOL)isNullObject:(id)object{
    
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isEmptyString:(NSString *)string{
    
    if ([[self class] isNullObject:string]) {
        return YES;
    }
    else if (![string isKindOfClass:[NSString class]]){
        return YES;
    }
    else if ([string isEqualToString:@""]){
        return YES;
    }
    
    return NO;
}

+ (NSString *)returnSafeString:(NSString *)string{
    
    if ([[self class] isEmptyString:string]) {
        return @"";
    }
    else
        return string;
}


#pragma mark - DATA DEAL WITH METHODS
+ (NSMutableDictionary *)OMDeleteAllNullValueInDic:(NSDictionary *)dic{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

+ (NSDictionary *)OMGetEncryptedParameters_WithUnEncryptParameterDictionary:(NSDictionary *) parametersDic AndAPI:(NSString *)API{
    
    // encryption encodeParams
    NSData *data = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData * encodeParamsData = [GTMBase64 encodeData:data];
    NSString *encodeParams = [[NSString alloc] initWithData:encodeParamsData  encoding:NSUTF8StringEncoding];
    
    // format and encrypt sign
    NSString *sign = [NSString stringWithFormat:@"api=%@&apiAccountId=%@&encodeParams=%@%@", API, API_ACOUNT_ID, encodeParams, VERIFIED_STRING];
    NSString *encryptedSign = [sign md5HexDigest];
    
    // create param : dic
    NSDictionary * dic = @{
                           @"api": API,
                           @"apiAccountId": API_ACOUNT_ID,
                           @"encodeParams": encodeParams,
                           @"sign": encryptedSign,
                           };
    
    return dic;
}


#pragma mark - AFN_POST & GET METHODS
+ (void)AFGetDateWithMethodGet_BaseOnURL:(NSString *)url dateBlock:(NetworkDate)dateBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/json", @"application/json", @"text/javascript", @"text/html",  nil];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            dateBlock(responseObject);
        }
        else{
            NSLog(@"!**!MaBang!**!-- SERVER ERROR CODE: %@ --!**!MaBang!**!", responseObject[@"ErrorCode"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"NETWORK ERROR WITH CODE : %@", error);
    }];
    
    
}

+ (void)AFGetDateWithMethodPost_ParametersDic:(NSDictionary *)parametersDic API:(NSString *)API dateBlock:(NetworkDate)dateBlock{
    
    // encryption encodeParams
    NSData *data = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData * encodeParamsData = [GTMBase64 encodeData:data];
    NSString *encodeParams = [[NSString alloc] initWithData:encodeParamsData  encoding:NSUTF8StringEncoding];
    
    // format and encrypt sign
    NSString *sign = [NSString stringWithFormat:@"api=%@&apiAccountId=%@&encodeParams=%@%@", API, API_ACOUNT_ID, encodeParams, VERIFIED_STRING];
    NSString *encryptedSign = [sign md5HexDigest];
    
    // create param : dic
    NSDictionary * dic = @{
                           @"api": API,
                           @"apiAccountId": API_ACOUNT_ID,
                           @"encodeParams": encodeParams,
                           @"sign": encryptedSign,
                           };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/json", @"application/json", @"text/javascript", @"text/html",  nil];
    
    
    [manager POST:SERVER_URL parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
            
            dateBlock(responseObject);
        }
        else{
            
            NSLog(@"!**!MaBang!**!-- SERVER ERROR Message: %@ --!**!MaBang!**!", responseObject[@"Message"]);
            
            UIViewController *rootVC = APPLICATION_SETTING.keyWindow.rootViewController;
            [self OMshowAlertViewWithMessage:responseObject[@"Message"] fromViewController:rootVC];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"NETWORK ERROR WITH CODE : %@", error);
        
    }];
    
}


#pragma mark - SET UI METHODS
+ (void)disableExtendedViewController:(UIViewController *)viewController{
    
    if ([viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [viewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}


+ (UIImage *)stretchImageFromCenter:(UIImage *)image{
    
    if (image) {
        CGFloat capWidth = floorf(image.size.width / 2);
        CGFloat capHeight = floorf(image.size.height / 2);
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(capHeight, capWidth, capHeight, capWidth)];
    }
    return image;
}

+ (void)setcornerOfView:(UIView *)view withRadius:(CGFloat)radius color:(UIColor *)color{
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = color.CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    
}

+ (void)SDSetImageView:(UIImageView *)imageView withURLString:(NSString *)url andPlacehoderImageName:(NSString *)name{
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(name)];
    
}


#pragma mark - LOGIN & AUTHORITY (FACEBOOK TWITTER)
+ (void)OMLogInWithFacebook{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"] fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

    // get token
    NSString *FBToken = [NSString stringWithFormat:@"%@", result.token.tokenString];
                                
    // request userId, userName from facebook
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        // varify the sacurity of reslut data
        if (result[@"id"] && result[@"name"] && ![self isEmptyString:FBToken]) {
            
            // sent request to my server
            NSDictionary *paramDic = @{@"type": @"1",
                                       @"token": FBToken,
                                       @"userId": result[@"id"],
                                       @"name": result[@"name"]
                                       };
            
            [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_LOGIN dateBlock:^(id dateBlock) {
                
                // varifiy return data from server
                if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
                    
                    // get and save date from my server
                    NSDictionary *dic = dateBlock[@"Data"][@"MemberInfo"];
                    
                    NSMutableDictionary *dicSafe = [OMCustomTool OMDeleteAllNullValueInDic:dic];
                    
                    NSLog(@"facebook require loginkey : %@", dicSafe);
                    
                    [self OMSaveUserInfoFromServerToLocal_WithParametersDictionary:dicSafe];
                    
                    // send login notification to global
                    [NOTIFICATION_SETTING postNotificationName:OMUSER_STATUS_LOGIN object:nil];
                }
                else{
                    
                    NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
                }
            }];
        }
        
    }];
    }];
}

+ (void)OMLoginWithTwitter{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        
        if (session) {
            
            // send post require to server
            NSString *TWToken = [NSString stringWithFormat:@"%@-||-%@", session.authToken, session.authTokenSecret];
            
            // send post require to server
            NSDictionary *paramDic = @{@"type": @"2",
                                       @"token": TWToken,
                                       @"userId": session.userID,
                                       @"name": session.userName
                                       };
            
            if (session.userID && session.userName && session.authToken && session.authTokenSecret) {
                
                [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_LOGIN dateBlock:^(id dateBlock) {
                    
                    if ([dateBlock[@"ErrorCode"] isEqualToString:REQ_SUCCEED_CODE]) {
                        
                        NSDictionary *dic = dateBlock[@"Data"][@"MemberInfo"];
                        NSMutableDictionary *dicSafe = [OMCustomTool OMDeleteAllNullValueInDic:dic];
                        
                        NSLog(@"twitter require loginkey : %@", dicSafe);
                        //  save user informations
                        [self OMSaveUserInfoFromServerToLocal_WithParametersDictionary:dicSafe];
                        
                        // send login notification to global
                        [NOTIFICATION_SETTING postNotificationName:OMUSER_STATUS_LOGIN object:nil];
                        
                    }
                    else{
                        NSLog(@"!**!MaBang!**!-- Error Message: %@ --!**!MaBang!**!", dateBlock[@"Message"]);
                    }
                    
                }];
            }
            
        }
        else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        
    }];
}

+ (void)OMAuthorityWithFacebook{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        // get token
        NSString *FBToken = [NSString stringWithFormat:@"%@", result.token.tokenString];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // varify data no null
            if (result[@"id"] && result[@"name"] && ![self isEmptyString:FBToken]) {
                // sent request to my server
                NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                           @"type": @"1",
                                           @"token": FBToken,
                                           @"userId": result[@"id"],
                                           @"name": result[@"name"]
                                           };
                
                [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_ADD_NEWSNS dateBlock:^(id dateBlock) {
                    
                   // return data with add result
                    NSLog(@"OMAuthority facebook return data : %@", dateBlock);
                    
                    // show accounts list
                    [self testGetSNSAccounts];
                }];
            }
            
        }];
        
        
    }];
}

+ (void)OMAuthorityWithTwitter{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (session) {
            NSString *TWToken = [NSString stringWithFormat:@"%@-||-%@", session.authToken, session.authTokenSecret];
            NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                       @"type": @"2",
                                       @"token": TWToken,
                                       @"userId": session.userID,
                                       @"name": session.userName
                                       };
            
            if (session.userID && session.userName && session.authToken && session.authTokenSecret) {
                [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_ADD_NEWSNS dateBlock:^(id dateBlock) {
                    // return data with add result
                    NSLog(@"OMAuthority twitter return data : %@", dateBlock);
                    // show accounts list
                    [self testGetSNSAccounts];
                }];
            }
        }
    }];
}

+ (void)OMDeleteAccountInFacebook_WithSNSID:(NSString *)snsId{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"snsAccountId" : snsId
                               };
    
    [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DEL_SNS dateBlock:^(id dateBlock) {
        // return data with delete result
        NSLog(@"OMDelete facebook return data : %@", dateBlock);
    }];
    
}

+ (void)OMDeleteAccountInTwitter_WithSNSID:(NSString *)snsId{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"snsAccountId": snsId
                               };
    
    [self AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_DEL_SNS dateBlock:^(id dateBlock) {
        // return data with delete result
        NSLog(@"OMDelete twitter return data : %@", dateBlock);
    }];
   
}


#pragma mark - JPUSH SEND REGISTER INFORMATION TO SERVER
+ (void)transformRigisterInformationsToServer{
    
        NSString *baseStr = [NSString stringWithFormat:@"%@%@%@", OMJPUSH_APP_KEY, @"3", [JPUSHService registrationID]];
        NSString *encryptStr = [baseStr md5HexDigest];
        
        if (![OMCustomTool isNullObject:[SETTINGs objectForKey:OM_USER_UID]]) {
            
            NSDictionary *paramDic = @{@"memberUid"     : [SETTINGs objectForKey:OM_USER_UID],
                                       @"jpushCode"     : [JPUSHService registrationID],
                                       @"platform"      : @"2",
                                       @"deviceVersion" : @"3",
                                       @"versionCode"   : encryptStr
                                       };
            
            [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SEND_JPUSH_RION dateBlock:^(id dateBlock) {
                
                NSLog(@"send register information return data : %@", dateBlock);
                
            }];
        }
        else{
            
        }
}


#if 0
#pragma mark - SHARE WITH FACEBOOK & TWITTER
+ (void)OMShareContentOnFacebook_WithContent:(NSString *)ParamURL FromViewController:(UIViewController *)viewController AndSendServerResultWtihParameter:(NSDictionary *)paramDic{
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:ParamURL];
    // trigger a dialog
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = viewController;
    dialog.shareContent = content;
    dialog.mode =  FBSDKShareDialogModeAutomatic;
    [dialog show];
    
}

+ (void)OMShareContentOnTwitter_WithContent:(NSString *)ParamURL FromViewController:(UIViewController *)viewController AndSendServerResultWtihParameter:(NSDictionary *)paramDic{
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    // content settings
    [composer setURL:[NSURL URLWithString:ParamURL]];
    
    // Called from a UIViewController
    [composer showFromViewController:viewController completion:^(TWTRComposerResult result) {
        
        if (result == TWTRComposerResultCancelled) {
            [self OMshowAlertViewWithMessage:@"Tweet composition cancelled!" fromViewController:viewController];
        }
        else
        {
            [self OMshowAlertViewWithMessage:@"Sending Tweet Succeed!" fromViewController:viewController];
            
            // send result to server
            [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_S_COMPLETE_TASK dateBlock:^(id dateBlock) {
                
            }];
        }
        
    }];
}
#endif

#pragma mark - OTHER METHODS
+ (void)OMSaveUserInfoFromServerToLocal_WithParametersDictionary:(NSDictionary *)dic{
    
    //  save user informations
    [SETTINGs setValue:dic[@"id"] forKey:OM_USER_ID];
    [SETTINGs synchronize];
    [SETTINGs setValue:dic[@"name"] forKey:OM_USER_NAME];
    [SETTINGs synchronize];
    [SETTINGs setValue:dic[@"loginKey"] forKey:OM_USER_LOGINKEY];
    [SETTINGs synchronize];
    [SETTINGs setValue:dic[@"uid"] forKey:OM_USER_UID];
    [SETTINGs synchronize];
    [SETTINGs setValue:dic[@"portrait"] forKey:OM_USER_ICON];
    [SETTINGs synchronize];
    
    // message authority
    [SETTINGs setValue:[NSString stringWithFormat:@"%@", dic[@"canOpenShop"]] forKey:OM_USER_SHOP_STATUS];
    [SETTINGs synchronize];
    
   
    
    // save userIcon in local file
    NSString *sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImage *image = [self getImageFromURL:[SETTINGs objectForKey:OM_USER_ICON]];
    [self saveImage:image withFileName:@"OMMyUserIcon" ofType:@"png" inDirectory:sandBoxPath];
    
    // send register information to server about JPush
    [self transformRigisterInformationsToServer];
}

+ (void)OMshowAlertViewWithMessage:(NSString *) message fromViewController:(UIViewController *)viewController{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:1];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:alertAction];
    [viewController presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark - Test Show Accounts List
+ (void)testGetSNSAccounts{
    
    NSDictionary *dic1 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                           @"type" : @"1"};
    NSDictionary *dic2 = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                           @"type" : @"2"};
    
    [self AFGetDateWithMethodPost_ParametersDic:dic1 API:API_S_SNS_LIST dateBlock:^(id dateBlock) {
        NSLog(@"ALL facebook accounts : %@", dateBlock);
    }];
    [self AFGetDateWithMethodPost_ParametersDic:dic2 API:API_S_SNS_LIST dateBlock:^(id dateBlock) {
        NSLog(@"ALL twitter accounts : %@", dateBlock);
    }];
}

+ (UIImage *) getImageFromURL:(NSString *)fileURL{
    NSLog(@"Download Image Started!");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

+ (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"download failed with error of image!");
    }
}

+ (UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


+ (void)OMRequestForNewLoginKey{
    
    // longinKey disabled per 4 hours, require loginKey again
    [SETTINGs removeObjectForKey:OM_USER_LOGINKEY];
    [SETTINGs synchronize];
    
    if ([self UserIsLoggingIn]) {
        
        NSDictionary *paramDic = @{@"memberUid" : [SETTINGs objectForKey:OM_USER_UID]};
        
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_GET_LOGINKEY dateBlock:^(id dateBlock) {
            
            // save new loginkey in local
            [SETTINGs setObject:dateBlock[@"Data"][@"LoginKey"] forKey:OM_USER_LOGINKEY];
            [SETTINGs synchronize];
        }];
        
    }
    else{
        NSLog(@"OMWarning : User login status error!");
    }
}


#pragma mark - WebSocket Send Parameters
+ (NSString *)OMReturnParametersWithDicForSessionList{
        
        // require data : session list
        NSDictionary *paramDic = @{@"v" : @"2.0",
                                   @"ac" : @"init",
                                   @"loginKey" : [SETTINGs objectForKey:OM_USER_LOGINKEY],
                                   @"actions" : @[@"getUnRead"],
                                   @"isSubjectListPage" : @"1"
                                   };
        
        NSData *json = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil];
        NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        return str;
}




@end
