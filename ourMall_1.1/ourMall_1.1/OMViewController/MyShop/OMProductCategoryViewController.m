//
//  OMProductCategoryViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/21.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMProductCategoryViewController.h"
#import "OMCategoryModel.h"
#import "OMCatePerCell.h"

@interface OMProductCategoryViewController ()

@property(nonatomic, strong) NSMutableArray *cateArray;
@property(nonatomic, strong) NSMutableArray *saveArray;
@property(nonatomic, strong) NSString *headerImgUrlStr;
@property(nonatomic, strong) NSString *headerStr;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OMProductCategoryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cateArray = [NSMutableArray array];
        _saveArray  =[NSMutableArray array];
        _selected = NO;
        
        // cache must be nil when viewController appear
        if ([SETTINGs objectForKey:OMCACHE_SHOP_CATE_KEY]) {
            
            [SETTINGs removeObjectForKey:OMCACHE_SHOP_CATE_KEY];
            [SETTINGs synchronize];
            [SETTINGs removeObjectForKey:OMCACHE_SHOP_PARAMETER];
            [SETTINGs synchronize];
        }
        else{
            // empty
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadHeaderView];
    [self loadData];
    
    [self.categoryTableView setEditing:YES animated:YES];
    
    // laoding animation
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}

- (void)loadHeaderView{
    
    self.categoryTableView.tableHeaderView = self.headerView;
    [OMCustomTool setcornerOfView:self.saveBtn withRadius:5 color:ClearBackGroundColor];
}

- (void)loadData{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"productId" : self.productId
                               };
    
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_CATEGORIES dateBlock:^(id dateBlock) {
        
        NSLog(@"category list : %@", dateBlock);
        
        self.cateArray = [OMCategoryModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Category"][@"list"]];
        
        self.headerImgUrlStr = dateBlock[@"Data"][@"Category"][@"productImg"];
        
        [OMCustomTool SDSetImageView:self.headerImg withURLString:self.headerImgUrlStr andPlacehoderImageName:OMPORDUCT_ICONIMG];
        
        self.headerLabel.text = self.headStr;
        self.title = @"Category Settings";
//        self.title = [NSString stringWithFormat:@"Category[%@]", self.headStr];
        
        
        [self.categoryTableView reloadData];
        
        [self.hud hide:YES];
    }];
    
}


#pragma mark - TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"OMCatePerCell";
    OMCatePerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
    }
    
    OMCategoryModel *model = [self.cateArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = model.name;
    
    // add item to saveArr
    if ([model.isHasThisCategory integerValue] == 1) {

        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self.saveArray addObject:self.cateArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.saveArray addObject:self.cateArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.saveArray removeObject:self.cateArray[indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}


- (IBAction)saveBtnClickedAction:(id)sender {
    
    if ([[self OMString:self.hasSelected] integerValue] == 1) {
        NSString *tranStr = @"";
        
        if (self.saveArray.count > 0) {
            
            for (OMCategoryModel *model in self.saveArray) {
                NSLog(@" category id : %@", model.categoryId);
                tranStr = [tranStr stringByAppendingString:[NSString stringWithFormat:@"%@,", model.categoryId]];
            }
            
            tranStr = [tranStr substringToIndex:tranStr.length - 1];
        }
        
        NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                                   @"productId" : self.productId,
                                   @"categoryIds" : tranStr
                                   };
        [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PROofCATE_ADD dateBlock:^(id dateBlock) {
            
            NSLog(@"save return data : %@ ", dateBlock);
            
            [OMCustomTool OMshowAlertViewWithMessage:@"Save Succeed! (1)" fromViewController:self];
        }];
    }
    else{
        NSString *tranStrName = @"";
        NSString *tranStrId = @"";
        NSMutableArray *cateNameArr = [NSMutableArray array];
        NSMutableArray *cateIdArr = [NSMutableArray array];
        
        for (OMCategoryModel *model in self.saveArray) {
            [cateNameArr addObject:model.name];
            [cateIdArr addObject:[self OMString:model.categoryId]];
        }
        
        if (cateNameArr.count > 1) {
            tranStrName = [tranStrName stringByAppendingString:cateNameArr.firstObject];
            tranStrName = [tranStrName stringByAppendingString:[NSString stringWithFormat:@" %ldetc.", cateNameArr.count]];
        }
        else{
            tranStrName = [tranStrName stringByAppendingString:cateNameArr.firstObject];
        }
        
        for (NSString *temp in cateIdArr) {
            tranStrId = [tranStrId stringByAppendingString:temp];
            tranStrId = [tranStrId stringByAppendingString:@","];
        }
        
        tranStrId = [tranStrId substringFromIndex:tranStrId.length - 1];
        
        [SETTINGs setValue:tranStrName forKey:OMCACHE_SHOP_CATE_KEY];
        [SETTINGs synchronize];
        
        [SETTINGs setValue:tranStrId forKey:OMCACHE_SHOP_PARAMETER];
        [SETTINGs synchronize];
        
        [OMCustomTool OMshowAlertViewWithMessage:@"Save Succeed! (2)" fromViewController:self];
    }
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
