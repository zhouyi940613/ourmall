//
//  BaseViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OMCustomNavigation.h"
#import "OMDefined.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "OMCustomTool.h"
#import <MBProgressHUD.h>
#import <AppsFlyer/AppsFlyer.h>

@interface BaseViewController : UIViewController

// Return custom navigation
//- (OMCustomNavigation *)customNavigation;

// Eable view can scrollable
- (void)enableSupportViewScrollableWithSize:(CGSize)scrollSize;

// Return custom backButton and method
//- (UIButton *)replaceBackButton;

- (NSString *)OMString:(NSString *) string;

// hide redundant separator lines
- (void)setExtraCellLineHidden: (UITableView *)tableView WithCurrentArray:(NSMutableArray *)array;

// resolve json data to dictionary
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
