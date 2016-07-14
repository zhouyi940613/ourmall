//
//  OMHomeDetailViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/13.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMHomeDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property(nonatomic, strong) NSString *taskId;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetail;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UILabel *fixedLabel;
@property (strong, nonatomic) UILabel *separatorLeftLabel;
@property (strong, nonatomic) UILabel *separatorRightLabel;
@property (strong, nonatomic) UILabel *productDetailLabel;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIWebView *webViewDetail;

@end
