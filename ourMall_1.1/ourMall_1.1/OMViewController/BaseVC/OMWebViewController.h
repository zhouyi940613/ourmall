//
//  OMWebViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMWebViewController : UIViewController<UIWebViewDelegate>

@property(strong, nonatomic) NSString *URLString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
