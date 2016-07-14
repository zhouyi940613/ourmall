//
//  OMMyCartViewController.h
//  ourMall_1.1
//
//  Created by Jay on 16/5/11.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "BaseViewController.h"

@interface OMMyCartViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewPromotion;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UICollectionView *statusCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *platformCollectionView;

@end
