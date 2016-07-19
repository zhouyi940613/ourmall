//
//  OMShopProductViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopProductViewController.h"

#import "OMShopAddProductVC.h"

#import "OMShopProductCell.h"
#import "OMProductModel.h"
#import "OMCategoryModel.h"

#import "LrdOutputView.h"

@interface OMShopProductViewController ()<UITableViewDelegate, UITableViewDataSource, LrdOutputViewDelegate>

@property(nonatomic, strong) UISegmentedControl *naviSeg;

@property(nonatomic, strong) UIScrollView *mainContainerScrollView;
@property(nonatomic, strong) UITableView *productTableView;
@property(nonatomic, strong) UITableView *categoryTableView;

@property(nonatomic, strong) NSMutableArray *onSaleArray;
@property(nonatomic, strong) NSMutableArray *offSaleArray;
@property(nonatomic, strong) NSMutableArray *productArray;
@property(nonatomic, strong) NSMutableArray *categoryArray;

@property(nonatomic, strong) UIView *onSaleTitleBgView;
@property(nonatomic, strong) UIView *offSaleTitleBgView;
@property(nonatomic, strong) UIButton *onSaleTitleBtn;
@property(nonatomic, strong) UIButton *offSaleTitleBtn;
@property(nonatomic, strong) UIView *leftSeparatorView;
@property(nonatomic, strong) UIView *rightSeparatorView;

@property(nonatomic, strong) UIView *productAddBgView;
@property(nonatomic, strong) UIView *categoryAddBgView;
@property(nonatomic, strong) UIButton *productAddBtn;
@property(nonatomic, strong) UIButton *categoryAddBtn;

@property(nonatomic, strong) MBProgressHUD *hud;


@end

@implementation OMShopProductViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _productArray = [NSMutableArray array];
        _categoryArray = [NSMutableArray array];
        _onSaleArray = [NSMutableArray array];
        _offSaleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - LoadUI
- (void)UIInit{
    
    // segment title text attribute
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             WhiteBackGroudColor,
                             UITextAttributeTextColor,  
                             WhiteBackGroudColor,
                             UITextAttributeTextShadowColor,
                             [NSValue valueWithUIOffset:UIOffsetMake(1, 0)],
                             UITextAttributeTextShadowOffset,
                             [UIFont systemFontOfSize:15],
                             UITextAttributeFont,
                             nil];
    
    self.naviSeg = [[UISegmentedControl alloc] initWithItems:@[@"Products", @"Categories"]];
    self.naviSeg.frame = CGRectMake(100, 10, 10, 30);
    [self.naviSeg setTitleTextAttributes:textDic forState:UIControlStateNormal];
    self.navigationItem.titleView = self.naviSeg;
    [self.naviSeg addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventValueChanged];
    
    
    // main frame settings
    self.mainContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIView *leftContainerView = [[UIView alloc] initWithFrame:self.view.frame];
    leftContainerView.backgroundColor = WhiteBackGroudColor;
    UIView *rightContainerView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    rightContainerView.backgroundColor = WhiteBackGroudColor;
    
    NSArray *viewArray = @[leftContainerView, rightContainerView];
    
    for (UIView *item in viewArray) {
        [self.mainContainerScrollView addSubview:item];
    }
    
    // product title background views
    self.onSaleTitleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 50)];
//    self.onSaleTitleBgView.backgroundColor = [UIColor redColor];
    self.offSaleTitleBgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 50)];
//    self.offSaleTitleBgView.backgroundColor = [UIColor greenColor];
    
    [leftContainerView addSubview:self.onSaleTitleBgView];
    [leftContainerView addSubview:self.offSaleTitleBgView];
    
    // product bottom background view
    self.productAddBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 60, SCREEN_WIDTH, 60)];
    [leftContainerView addSubview:self.productAddBgView];
    self.productAddBgView.backgroundColor = WhiteBackGroudColor;
    
    UIImageView *bottomShadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [bottomShadowImg setImage:IMAGE(@"footer_top")];
    [self.productAddBgView addSubview:bottomShadowImg];
    
    // category bottom background view
    self.categoryAddBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 60, SCREEN_WIDTH, 60)];
    [rightContainerView addSubview:self.categoryAddBgView];
    self.categoryAddBgView.backgroundColor = WhiteBackGroudColor;
    
    UIImageView *bottomShadowImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [bottomShadowImg2 setImage:IMAGE(@"footer_top")];
    [self.categoryAddBgView addSubview:bottomShadowImg2];
    
    // tableViews
    self.productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 110) style:UITableViewStylePlain];
    [leftContainerView addSubview:self.productTableView];
    self.productTableView.backgroundColor = WhiteBackGroudColor;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60) style:UITableViewStylePlain];
    [rightContainerView addSubview:self.categoryTableView];
    self.categoryTableView.backgroundColor = WhiteBackGroudColor;
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    
    [self.view addSubview:self.mainContainerScrollView];
    
    // load spe
    [self loadSpecificWidgets];
}

- (void)loadSpecificWidgets{
    
    // product title buttons
    self.onSaleTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.onSaleTitleBtn.frame = CGRectMake(20, 5, SCREEN_WIDTH / 2 - 20 * 2, 44);
    [self.onSaleTitleBtn setTitle:@"On Sale(12)" forState:UIControlStateNormal];
    [self.onSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.onSaleTitleBtn addTarget:self action:@selector(onSaleBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.onSaleTitleBgView addSubview:self.onSaleTitleBtn];
    
    self.leftSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH / 2, 1)];
    [self.onSaleTitleBgView addSubview:self.leftSeparatorView];
    self.leftSeparatorView.backgroundColor = OMCustomRedColor;
    
    self.offSaleTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.offSaleTitleBtn.frame = CGRectMake(20, 5, SCREEN_WIDTH / 2 - 20 * 2, 44);
    [self.offSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitle:@"Pull off shelves(2)" forState:UIControlStateNormal];
    [self.offSaleTitleBtn addTarget:self action:@selector(offSaleBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.offSaleTitleBgView addSubview:self.offSaleTitleBtn];
    
    self.rightSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH / 2, 1)];
    [self.offSaleTitleBgView addSubview:self.rightSeparatorView];
    self.rightSeparatorView.backgroundColor = OMSeparatorLineColor;
    
    
    // product bottom button
    self.productAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productAddBtn.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, 20, 150, 30);
    self.productAddBtn.backgroundColor = OMCustomRedColor;
    [self.productAddBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [self.productAddBtn setTitle:@"+ Add Product" forState:UIControlStateNormal];
    self.productAddBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [OMCustomTool setcornerOfView:self.productAddBtn withRadius:5 color:ClearBackGroundColor];
    [self.productAddBtn addTarget:self action:@selector(productAddBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.productAddBgView addSubview:self.productAddBtn];
    
    // category bottom button
    self.categoryAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryAddBtn.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, 20, 80, 30);
    self.categoryAddBtn.backgroundColor = OMCustomRedColor;
    [self.categoryAddBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [self.categoryAddBtn setTitle:@"+ Add" forState:UIControlStateNormal];
    self.categoryAddBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [OMCustomTool setcornerOfView:self.categoryAddBtn withRadius:5 color:ClearBackGroundColor];
    [self.categoryAddBtn addTarget:self action:@selector(categoryAddBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryAddBgView addSubview:self.categoryAddBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteBackGroudColor;
    
    [self UIInit];
    
    [self.naviSeg setSelectedSegmentIndex:0];
    
    [self loadDataOnSale];
    [self loadDataCategories];
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
}


#pragma mark - Change TableView Container
- (void)changeTableView:(UISegmentedControl *)seg{
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self.mainContainerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            [self.mainContainerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - Change Product TableView Data
- (void)onSaleBtnClickedAction:(UIButton *)btn{
    
    [self.hud show:YES];
   
    self.leftSeparatorView.backgroundColor = OMCustomRedColor;
    self.rightSeparatorView.backgroundColor = OMSeparatorLineColor;
    [self.onSaleTitleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self loadDataOnSale];
}

- (void)offSaleBtnClickedAction:(UIButton *)btn{
    
     [self.hud show:YES];
    
    self.leftSeparatorView.backgroundColor = OMSeparatorLineColor;
    self.rightSeparatorView.backgroundColor = OMCustomRedColor;
    [self.onSaleTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.offSaleTitleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self loadDataOffSale];
}

#pragma mark - Add Buttton Clicked Actions
- (void)productAddBtnClickedAction:(UIButton *)btn{
    
    OMShopAddProductVC *addVC = [[OMShopAddProductVC alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)categoryAddBtnClickedAction:(UIButton *)btn{
    
    // motify view
}


#pragma mark - Require Data
- (void)loadDataOnSale{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"page" : @"1",
                               @"status" : @"1"
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
        
        self.onSaleArray = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        self.productArray = [NSMutableArray arrayWithArray:self.onSaleArray];
        
        [self.productTableView reloadData];
        
        [self.hud hide:YES];
    }];
}

- (void)loadDataOffSale{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID],
                               @"page" : @"1",
                               @"status" : @"2"
                               };
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_LIST dateBlock:^(id dateBlock) {
        
        self.offSaleArray = [OMProductModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Products"]];
        self.productArray = [NSMutableArray arrayWithArray:self.offSaleArray];
        
        [self.productTableView reloadData];
        
        [self.hud hide:YES];
    }];

}

- (void)loadDataCategories{
    
    NSDictionary *paramDic = @{@"id" : [SETTINGs objectForKey:OM_USER_ID]};
    
    [OMCustomTool AFGetDateWithMethodPost_ParametersDic:paramDic API:API_SHOP_PRODUCT_CATEGORIES_LIST dateBlock:^(id dateBlock) {
        self.categoryArray = [OMCategoryModel ModelArr_With_DictionaryArr:dateBlock[@"Data"][@"Category"][@"list"]];
        [self.categoryTableView reloadData];
    }];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.productTableView) {
        
        return self.productArray.count;
    }
    else if (tableView == self.categoryTableView){
        
        return self.categoryArray.count;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.productTableView) {
        return 130.0;
    }
    else if (tableView == self.categoryTableView)
    {
        return 60;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.productTableView) {
        
        static NSString *reuse = @"OMShopProductCell";
        OMShopProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuse owner:nil options:nil] lastObject];
        }
        OMProductModel *model = [self.productArray objectAtIndex:indexPath.row];
        
        [OMCustomTool SDSetImageView:cell.productImg withURLString:model.imgUrl andPlacehoderImageName:OMPORDUCT_ICONIMG];
        
        cell.descLabel.text = model.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.price]];
        cell.profitLabel.text = [NSString stringWithFormat:@"$%@", [self OMString:model.profit]];
        [cell.operationBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.operationBtn.tag = indexPath.row + 500;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (tableView == self.categoryTableView)
    {
        static NSString *reuse = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:reuse];
        }
        
        OMCategoryModel *model = [self.categoryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [self OMString:model.count];
        cell.accessoryType = 1;
        
        return cell;
    }
    else{
        return 0;
    }
}


- (void)operationAction:(UIButton *)btn{
    
//    OMProductModel *model = [self.productArray objectAtIndex:(btn.tag - 500)];
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag - 500 inSection:0];
    NSLog(@"row : %ld", index.row);
    
    
    CGPoint newPoint = CGPointMake(btn.center.x + 15, index.row * 130 + 64 + 50 + 80);

    CGPoint oldPoint = [btn convertPoint:btn.frame.origin toView:nil];
    
    oldPoint.x = btn.center.x;
    
    oldPoint.x = oldPoint.x + 15;
    oldPoint.y = oldPoint.y - 90;
    
    
    NSLog(@"old x : %f, old y :%f", oldPoint.x, oldPoint.y);
    NSLog(@"new x : %f, new y :%f", newPoint.x, newPoint.y);
    
    
    // show menu
    CGFloat x = oldPoint.x;
    CGFloat y = oldPoint.y + btn.bounds.size.height + 10;
    
    LrdCellModel *editItem = [[LrdCellModel alloc] initWithTitle:@"Edit" imageName:@""];
    LrdCellModel *categoryItem = [[LrdCellModel alloc] initWithTitle:@"Category" imageName:@""];
    LrdCellModel *offItem = [[LrdCellModel alloc] initWithTitle:@"Off the shelf" imageName:@""];
    LrdCellModel *deleteItem = [[LrdCellModel alloc] initWithTitle:@"Delete" imageName:@""];
    LrdCellModel *moveUpItem = [[LrdCellModel alloc] initWithTitle:@"Move up" imageName:@""];
    LrdCellModel *moveDownItem = [[LrdCellModel alloc] initWithTitle:@"Move down" imageName:@""];
    
     NSArray *itemsArray = @[editItem, categoryItem, offItem, deleteItem, moveUpItem, moveDownItem];
    
    if (oldPoint.y > 350) {
        // top
        LrdOutputView *outputView = [[LrdOutputView alloc] initWithDataArray:itemsArray origin:CGPointMake(x, y) width:120 height:30 direction:kLrdOutputViewDirectionTop];
        outputView.delegate = self;
        [outputView pop];
    }
    else{
        // down
        LrdOutputView *outputView = [[LrdOutputView alloc] initWithDataArray:itemsArray origin:CGPointMake(x, y) width:120 height:30 direction:kLrdOutputViewDirectionDown];
        outputView.delegate = self;
        [outputView pop];
    }
}

#pragma mark - DropMenu Delegate Method
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)editAction:(UIMenuItem *)item{
    
}

- (void)categoryAction:(UIMenuItem *)item{
    
}

- (void)offShelfAction:(UIMenuItem *)item{
    
}

- (void)deleteAction:(UIMenuItem *)item{
    
}

- (void)moveUpAction:(UIMenuItem *)item{
    
}

- (void)moveDownAction:(UIMenuItem *)item{
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
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
