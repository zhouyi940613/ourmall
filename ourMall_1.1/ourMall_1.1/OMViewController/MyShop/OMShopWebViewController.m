//
//  OMShopWebViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/28.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopWebViewController.h"

@interface OMShopWebViewController ()

@end

@implementation OMShopWebViewController

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
    self.title = @"";
    
    NSURL *URL = [NSURL URLWithString:self.URLString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    self.webView.scrollView.bounces = NO;
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
