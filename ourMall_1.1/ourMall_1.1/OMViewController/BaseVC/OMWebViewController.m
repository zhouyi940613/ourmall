//
//  OMWebViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMWebViewController.h"
#import "OMCustomTool.h"


@interface OMWebViewController ()

@end

@implementation OMWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"WEB RESOUCE";
    
    //    default YES
    //    [self.webView setUserInteractionEnabled:NO];
    
    NSURL *URL = [NSURL URLWithString:self.URLString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    self.webView.scrollView.bounces = NO;
    
    self.indicatorView.hidesWhenStopped = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

#pragma mark - Clear URL Date
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    if (![OMCustomTool isEmptyString:self.URLString]) {
        self.URLString = nil;
    }
}

#pragma mark -- WebView Delegate Method

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.indicatorView stopAnimating];
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
