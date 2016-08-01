//
//  OMShopWebViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/7/28.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMShopWebViewController : BaseViewController<UIWebViewDelegate>

@property(strong, nonatomic) NSString *URLString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
