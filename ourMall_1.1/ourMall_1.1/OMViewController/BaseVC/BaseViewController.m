//
//  BaseViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
// SVN TEST

#import "BaseViewController.h"

@interface BaseViewController ()

// ScrollView store hold view to make it scrollable
@property (strong, nonatomic) UIScrollView *scrollableView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark -- Supports
#if 1
- (OMCustomNavigation *)customNavigation{
    
    OMCustomNavigation *navigation = (OMCustomNavigation *) self.navigationController;
    return navigation;
}
#endif

- (void)enableSupportViewScrollableWithSize:(CGSize)scrollSize{
    // add scrollView
    if (!self.scrollableView) {
        _scrollableView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        for (id obj in self.view.subviews) {
            [_scrollableView addSubview:obj];
        }
        [self.view addSubview:_scrollableView];
    }
    [_scrollableView setContentSize:scrollSize];
}

- (UIScrollView *)scrollableView{
    
    return _scrollableView;
}

#if 1
- (UIButton *)replaceBackButton{
    
    // create custom back button
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [buttonBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(buttonBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // fix button margin on iOS 7 or later
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [buttonBack setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, -15)];
    }
    
    // override back button
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    return buttonBack;
}
#endif

#if 1
- (void)buttonBackClicked:(UIButton *)btn{
    
    // pop to previous view when it's available
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // dismiss view when it's presenting
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
#endif


#pragma mark - Return Formatter String
- (NSString *)OMString:(id) string{
    
    if (!string || [string isKindOfClass:[NSNull class]]) {
        
        return @"0";
    }
    else{
        return [NSString stringWithFormat:@"%@", string];
    }
    
}

#pragma mark - Hide Redundant Separator Lines
- (void)setExtraCellLineHidden: (UITableView *)tableView WithCurrentArray:(NSMutableArray *)array{
    
    if (array.count != 0) {
        // set for redundant separator line
        UIView *view =[ [UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [tableView setTableFooterView:view];
    }
    else{
        // set for empty page with placeholder image
        UIImageView *emptyImageView = [[UIImageView alloc] init];
        CGSize newSize = CGSizeMake(tableView.frame.size.width, tableView.frame.size.height - tableView.tableHeaderView.frame.size.height);
        CGRect newFrame = CGRectMake(0, 0, newSize.width, newSize.height);
        emptyImageView.frame = newFrame;
        emptyImageView.image = IMAGE(@"NOFOUND.png");
        [tableView setTableFooterView:emptyImageView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
