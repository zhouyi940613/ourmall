//
//  OMCustomTool.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"

typedef void(^NetworkDate)(id dateBlock);

@interface OMCustomTool : NSObject

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

#pragma mark - VARIFY ABOUT LOGIN
/**
 *  Verify user login status
 *
 *  @return status
 */
+ (BOOL)UserIsLoggingIn;


#pragma mark - VALUE TYPE VARIFY

/**
 *  Varify object not null
 *
 *  @param object object to varify
 *
 *  @return varified object
 */
+ (BOOL)isNullObject:(id)object;

/**
 *  Varify stirng not empty
 *
 *  @param string string to varify
 *
 *  @return varified string
 */
+ (BOOL)isEmptyString:(NSString *)string;

/**
 *  Get safe string
 *
 *  @param string original string
 *
 *  @return safe string
 */
+ (NSString *)returnSafeString:(NSString *)string;

#pragma mark - DATA DEAL WITH METHODS

/**
 *  Delete all NULL value from server in dictionary
 *
 *  @param dic server date dictionary
 *
 *  @return no NULL dictionary
 */
+ (NSMutableDictionary *)OMDeleteAllNullValueInDic:(NSDictionary *)dic;

/**
 *  Encrypt parameters
 *
 *  @param parameterDic base parameters
 *  @param API current part API
 *
 *  @return parameter wait to post
 */
+ (NSDictionary *)OMGetEncryptedParameters_WithUnEncryptParameterDictionary:(NSDictionary *) parametersDic AndAPI:(NSString *)API;


#pragma mark - AFN_POST & GET METHODS
/**
 *  AFNetworking get date with method get
 *
 *  @param url server url
 *
 *  @return date in server
 */
+ (void)AFGetDateWithMethodGet_BaseOnURL:(NSString *)url dateBlock:(NetworkDate)dateBlock;

/**
 *  AFNetworking get date with method post
 *
 *  @param ParametersDic: param dictionary
 *  @param API: current server API
 *  @param dateBlock: return date
 *
 *  @return date in server
 */
+ (void)AFGetDateWithMethodPost_ParametersDic:(NSDictionary *)parametersDic API:(NSString *)API dateBlock:(NetworkDate)dateBlock;

#pragma mark - SET UI METHODS

/**
 *  Prevent the upward drift of ViewController
 */
+ (void)disableExtendedViewController:(UIViewController *)viewController;

/**
 *  Stretch a image from center and return this stretched image
 *
 *  @param image Input image
 *
 *  @return stretched image
 */
+ (UIImage *)stretchImageFromCenter:(UIImage *)image;

/**
 *  Set cornerRadius Of View
 *
 *  @param view to set
 *  @param view radius
 *  @param border color
 *
 *  @return view setted corner
 */
+ (void)setcornerOfView:(UIView *)view withRadius:(CGFloat)radius color:(UIColor *)color;

/**
 *  SDWebImage method packaged
 *
 *  @param web image url string
 *  @param placehoder image name
 *
 *  @return dated imageView
 */
+ (void)SDSetImageView:(UIImageView *) imageView withURLString:(NSString *)url andPlacehoderImageName:(NSString *)name;


#pragma mark - LOGIN & AUTHORITY (FACEBOOK TWITTER)
/**
 *  Method for user login with facebook
 */
+ (void)OMLogInWithFacebook;

/**
 *  Method for user login with twitter
 */
+ (void)OMLoginWithTwitter;

/**
 *  Method for user authority new facebook account
 */
+ (void)OMAuthorityWithFacebook;

/**
 *  Method for user authority new twitter account
 */
+ (void)OMAuthorityWithTwitter;

/**
 *  Method for user delete facebook account
 */
+ (void)OMDeleteAccountInFacebook_WithSNSID:(NSString *)snsId;

/**
 *  Method for user delete twitter account
 */
+ (void)OMDeleteAccountInTwitter_WithSNSID:(NSString *)snsId;


#if 0
/**
 *  Method for user share content on facebook
 *  @Param content : URL string willing to share
 */
+ (void)OMShareContentOnFacebook_WithContent:(NSString *)ParamURL FromViewController:(UIViewController *) viewController AndSendServerResultWtihParameter:(NSDictionary *)paramDic;

/**
 *  Method for user share content on twitter
 *  @Param content : URL string willing to share
 */
+ (void)OMShareContentOnTwitter_WithContent:(NSString *)ParamURL FromViewController:(UIViewController *) viewController AndSendServerResultWtihParameter:(NSDictionary *)paramDic;
#endif


#pragma mark - OTHER METHODS
/**
 *  Save userInfo dictionary in NSUserDefaulter
 *
 *  @param dictionary: userInfo dic will be saved in defaluter
 *
 */
+ (void)OMSaveUserInfoFromServerToLocal_WithParametersDictionary:(NSDictionary *)dic;

/**
 *  Show simple alertView with message (title)
 *
 *  @param message: title of alertView
 *  @param viewController: self VC
 *
 */
+ (void)OMshowAlertViewWithMessage:(NSString *) message fromViewController:(UIViewController *)viewController;

/**
 *  Load image from local file
 *
 *  @param fileName:        image name
 *  @param extension:       image extension name
 *  @param directoryPath:   directory
 *
 *  @return local image
 */
+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;



+ (void)OMRequestForNewLoginKey;



+ (NSString *)OMReturnParametersWithDicForSessionList;


@end
