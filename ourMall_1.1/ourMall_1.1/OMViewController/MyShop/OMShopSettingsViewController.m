//
//  OMShopSettingsViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/16.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMShopSettingsViewController.h"

@interface OMShopSettingsViewController ()

// container view
@property(nonatomic, strong) UIView *containerView;

@property(nonatomic, strong) UIView *titleUpContainerView;
@property(nonatomic, strong) UIView *titleDowncontainerView;

@property(nonatomic, strong) UIView *contentContainerUpView;
@property(nonatomic, strong) UIView *contentContainerDownView;

@property(nonatomic, strong) UIView *bottomContainerView;

// separator view
@property(nonatomic, strong) UIView *separatorViewUp;
@property(nonatomic, strong) UIView *separatorViewDown;
@property(nonatomic, strong) UIView *separatorViewHideUp;
@property(nonatomic, strong) UIView *separatorViewHideDown;

// up part
// title part
@property(nonatomic, strong) UIImageView *recomUpImg;
@property(nonatomic, strong) UILabel *recomUpLabel;
@property(nonatomic, strong) UISwitch *recomUpSwitch;

// detail title part
@property(nonatomic, strong) UIImageView *profitUpImg;
@property(nonatomic, strong) UILabel *profitUpLabel;
@property(nonatomic, strong) UILabel *profitUpDetailLabel;

// content part
@property(nonatomic, strong) UISlider *profitUpSlider;
@property(nonatomic, strong) UILabel *marginDesLabel;
@property(nonatomic, strong) UITextField *marginInputTextField;
@property(nonatomic, strong) UILabel *marginSymbolLabel;
@property(nonatomic, strong) UIButton *saveBtn;

// down part
// title part
@property(nonatomic, strong) UIImageView *recomDownImg;
@property(nonatomic, strong) UILabel *recomDownLabel;
@property(nonatomic, strong) UISwitch *recomDownSwitch;

//detail title part
@property(nonatomic, strong) UIImageView *profitDownImg;
@property(nonatomic, strong) UILabel *profitDownLabel;
@property(nonatomic, strong) UILabel *profitDownDetailLabel;

// content title
@property(nonatomic, strong) UISlider *profitDownSlider;
@property(nonatomic, strong) UILabel *leftValueLabel;
@property(nonatomic, strong) UILabel *rightValueLabel;
@property(nonatomic, strong) UILabel *distributeLabel;
@property(nonatomic, strong) UILabel *mineLabel;


// bottom
// title part
@property(nonatomic, strong) UIImageView *colorImg;
@property(nonatomic, strong) UILabel *colorLabel;
@property(nonatomic, strong) UILabel *colorDetailLabel;

// content part
@property(nonatomic, strong) UIButton *redBtn;
@property(nonatomic, strong) UIButton *blackBtn;

@property(nonatomic, assign) BOOL upSwitchStatus;
@property(nonatomic, assign) BOOL downSwitchStatus;

@end

@implementation OMShopSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _upSwitchStatus = YES;
        _downSwitchStatus = NO;
    }
    return self;
}

- (void)UIInit{
    
    // laod UI with four parts
    [self loadUI_containerPart];
    [self loadUI_upTitlePart];
    [self loadUI_upContentPart];
    [self loadUI_downTitlePart];
    [self loadUI_downContentPart];
    [self loadUI_bottomPart];
}

#pragma mark - Load UI Container Part
- (void)loadUI_containerPart{
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50)];
    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = WhiteBackGroudColor;
    
    
    self.titleUpContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50)];
    [self.containerView addSubview:self.titleUpContainerView];
//    self.titleUpContainerView.backgroundColor = [UIColor redColor];
    
    
    self.contentContainerUpView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 130)];
    [self.containerView addSubview:self.contentContainerUpView];
//    self.contentContainerUpView.backgroundColor = [UIColor orangeColor];
    
    
    self.titleDowncontainerView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50)];
    [self.containerView addSubview:self.titleDowncontainerView];
//    self.titleDowncontainerView.backgroundColor = [UIColor yellowColor];
    
    
    self.contentContainerDownView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110)];
    [self.containerView addSubview:self.contentContainerDownView];
//    self.contentContainerDownView.backgroundColor = [UIColor greenColor];
    
    
    self.bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110)];
    [self.containerView addSubview:self.bottomContainerView];
//    self.bottomContainerView.backgroundColor = [UIColor blueColor];
    
}


- (void)loadUI_upTitlePart{
    
    // up title container
    self.recomUpImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    [self.titleUpContainerView addSubview:self.recomUpImg];
//    self.recomUpImg.backgroundColor = WhiteBackGroudColor;
    [self.recomUpImg setImage:IMAGE(@"autoFill.png")];
    
    self.recomUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 190, 20)];
    [self.titleUpContainerView addSubview:self.recomUpLabel];
    self.recomUpLabel.backgroundColor = WhiteBackGroudColor;
    self.recomUpLabel.text = @"Product Recommended";
    
    self.recomUpSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.titleUpContainerView.frame.size.width - 60, 10, 60, 20)];
    [self.titleUpContainerView addSubview:self.recomUpSwitch];
    self.recomUpSwitch.backgroundColor = ClearBackGroundColor;
    self.recomUpSwitch.onTintColor = OMCustomRedColor;
    [self.recomUpSwitch addTarget:self action:@selector(recommendControl:) forControlEvents:UIControlEventValueChanged];
    
    self.separatorViewUp = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.titleUpContainerView.frame.size.width, 1)];
    [self.titleUpContainerView addSubview:self.separatorViewUp];
    self.separatorViewUp.backgroundColor = OMSeparatorLineColor;
}

- (void)loadUI_upContentPart{
    
    // up title detail container
    // title
    self.profitUpImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    [self.contentContainerUpView addSubview:self.profitUpImg];
//    self.profitUpImg.backgroundColor = WhiteBackGroudColor;
    [self.profitUpImg setImage:IMAGE(@"dollar.png")];
    
    self.profitUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 160, 20)];
    [self.contentContainerUpView addSubview:self.profitUpLabel];
    self.profitUpLabel.backgroundColor = WhiteBackGroudColor;
    self.profitUpLabel.text = @"Default Profit Margin";
    
    self.profitUpDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentContainerUpView.frame.size.width - 90, 15, 90, 15)];
    [self.contentContainerUpView addSubview:self.profitUpDetailLabel];
    self.profitUpDetailLabel.backgroundColor = WhiteBackGroudColor;
    self.profitUpDetailLabel.text = @"*Drag the bar";
    self.profitUpDetailLabel.textAlignment = NSTextAlignmentRight;
    self.profitUpDetailLabel.font = [UIFont systemFontOfSize:12.0];
    self.profitUpDetailLabel.textColor = [UIColor lightGrayColor];
    
    self.profitUpSlider = [[UISlider alloc] initWithFrame:CGRectMake(23, 15 + 20 + 20 + 5, self.contentContainerUpView.frame.size.width - 23 * 2, 15)];
    [self.contentContainerUpView addSubview:self.profitUpSlider];
    self.profitUpSlider.backgroundColor = WhiteBackGroudColor;
    self.profitUpSlider.minimumTrackTintColor = OMCustomRedColor;
    self.profitUpSlider.thumbTintColor = OMCustomRedColor;
    
    // content
    self.marginDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15 + 20 + 20 + 5 + 20 + 10 + 5, 110, 20)];
    [self.contentContainerUpView addSubview:self.marginDesLabel];
    self.marginDesLabel.backgroundColor = WhiteBackGroudColor;
    self.marginDesLabel.text = @"Profit Margin:";
    
    self.marginInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 15 + 20 + 20 + 5 + 20 + 10, 80, 30)];
    [self.contentContainerUpView addSubview:self.marginInputTextField];
    self.marginInputTextField.backgroundColor = WhiteBackGroudColor;
    self.marginInputTextField.layer.borderColor = OMSeparatorLineColor.CGColor;
    self.marginInputTextField.layer.borderWidth = 1;
    
    self.marginSymbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 + 80 + 5, 15 + 20 + 20 + 5 + 20 + 10 + 5, 20, 20)];
    [self.contentContainerUpView addSubview:self.marginSymbolLabel];
    self.marginSymbolLabel.text = @"%";
    self.marginSymbolLabel.textColor = OMCustomRedColor;
    self.marginSymbolLabel.backgroundColor = WhiteBackGroudColor;
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setFrame:CGRectMake(self.contentContainerUpView.frame.size.width - 60 - 23, 15 + 20 + 20 + 5 + 20 + 10, 60, 30)];
    [self.contentContainerUpView addSubview:self.saveBtn];
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = OMCustomRedColor;
    [self.saveBtn setTitleColor:WhiteBackGroudColor forState:UIControlStateNormal];
    [OMCustomTool setcornerOfView:self.saveBtn withRadius:5 color:ClearBackGroundColor];
    
    self.separatorViewHideUp = [[UIView alloc] initWithFrame:CGRectMake(0, 129, self.contentContainerUpView.frame.size.width, 1)];
    [self.contentContainerUpView addSubview:self.separatorViewHideUp];
    self.separatorViewHideUp.backgroundColor = OMSeparatorLineColor;
}

- (void)loadUI_downTitlePart{
    
    // down title container
    self.recomDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    [self.titleDowncontainerView addSubview:self.recomDownImg];
//    self.recomDownImg.backgroundColor = WhiteBackGroudColor;
    [self.recomDownImg setImage:IMAGE(@"autoFill.png")];
    
    self.recomDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 200, 20)];
    [self.titleDowncontainerView addSubview:self.recomDownLabel];
    self.recomDownLabel.backgroundColor = WhiteBackGroudColor;
    self.recomDownLabel.text = @"Three-Level Distrubution";
    
    self.recomDownSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.titleDowncontainerView.frame.size.width - 60, 10, 60, 20)];
    [self.titleDowncontainerView addSubview:self.recomDownSwitch];
    self.recomDownSwitch.backgroundColor = ClearBackGroundColor;
    self.recomDownSwitch.onTintColor = OMCustomRedColor;
    [self.recomDownSwitch addTarget:self action:@selector(distributeControl:) forControlEvents:UIControlEventValueChanged];
    
    self.separatorViewDown = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.titleDowncontainerView.frame.size.width, 1)];
    [self.titleDowncontainerView addSubview:self.separatorViewDown];
    self.separatorViewDown.backgroundColor = OMSeparatorLineColor;
}

- (void)loadUI_downContentPart{
    
    // down title detail container
    // title
    self.profitDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    [self.contentContainerDownView addSubview:self.profitDownImg];
//    self.profitDownImg.backgroundColor = WhiteBackGroudColor;
    [self.profitDownImg setImage:IMAGE(@"dollar.png")];
    
    self.profitDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 160, 20)];
    [self.contentContainerDownView addSubview:self.profitDownLabel];
    self.profitDownLabel.backgroundColor = WhiteBackGroudColor;
    self.profitDownLabel.text = @"Profit Alloacation";
    
    self.profitDownDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentContainerDownView.frame.size.width - 130, 15, 130, 15)];
    [self.contentContainerDownView addSubview:self.profitDownDetailLabel];
    self.profitDownDetailLabel.backgroundColor = WhiteBackGroudColor;
    self.profitDownDetailLabel.text = @"*Percentage Settings";
    self.profitDownDetailLabel.textAlignment = NSTextAlignmentRight;
    self.profitDownDetailLabel.font = [UIFont systemFontOfSize:12.0];
    self.profitDownDetailLabel.textColor = [UIColor lightGrayColor];
    
    
    self.leftValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15 + 20 + 5, 70, 15)];
    [self.contentContainerDownView addSubview:self.leftValueLabel];
    self.leftValueLabel.textColor = OMCustomBlueColor;
    self.leftValueLabel.text = @"75 %";
    
    self.rightValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentContainerDownView.frame.size.width - 90, 15 + 20 + 5, 70, 15)];
    [self.contentContainerDownView addSubview:self.rightValueLabel];
    self.rightValueLabel.textColor = OMCustomRedColor;
    self.rightValueLabel.text = @"25 %";
    self.rightValueLabel.textAlignment = NSTextAlignmentRight;
    
    self.profitDownSlider = [[UISlider alloc] initWithFrame:CGRectMake(23, 15 + 20 + 20 + 5 + 5, self.contentContainerDownView.frame.size.width - 23 * 2, 15)];
    [self.contentContainerDownView addSubview:self.profitDownSlider];
    self.profitDownSlider.backgroundColor = WhiteBackGroudColor;
    self.profitDownSlider.minimumTrackTintColor = OMCustomBlueColor;
    self.profitDownSlider.thumbTintColor = OMCustomBlueColor;
    self.profitDownSlider.maximumTrackTintColor = OMCustomRedColor;
    
    self.distributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + 20 + 20 + 5 + 20 + 10, 100, 15)];
    [self.contentContainerDownView addSubview:self.distributeLabel];
    self.distributeLabel.textColor = OMCustomBlueColor;
    self.distributeLabel.text = @"Distributors";
    self.distributeLabel.font = [UIFont systemFontOfSize:13];
    
    self.mineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentContainerDownView.frame.size.width - 50, 15 + 20 + 20 + 5 + 20 + 10, 50, 15)];
    [self.contentContainerDownView addSubview:self.mineLabel];
    self.mineLabel.textColor = OMCustomRedColor;
    self.mineLabel.text = @"Mine";
    self.mineLabel.font = [UIFont systemFontOfSize:13];
    self.mineLabel.textAlignment = NSTextAlignmentRight;
    
    self.separatorViewHideDown = [[UIView alloc] initWithFrame:CGRectMake(0, 109, self.contentContainerDownView.frame.size.width, 1)];
    [self.contentContainerDownView addSubview:self.separatorViewHideDown];
    self.separatorViewHideDown.backgroundColor = OMSeparatorLineColor;
}

- (void)loadUI_bottomPart{
    
    // bottom container
    self.colorImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    [self.bottomContainerView addSubview:self.colorImg];
//    self.colorImg.backgroundColor = WhiteBackGroudColor;
    [self.colorImg setImage:IMAGE(@"copy-s.png")];
    
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 160, 20)];
    [self.bottomContainerView addSubview:self.colorLabel];
    self.colorLabel.backgroundColor = WhiteBackGroudColor;
    self.colorLabel.text = @"Color Scheme";
    
    self.colorDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomContainerView.frame.size.width - 90, 15, 90, 15)];
    [self.bottomContainerView addSubview:self.colorDetailLabel];
    self.colorDetailLabel.backgroundColor = WhiteBackGroudColor;
    self.colorDetailLabel.text = @"*Tick it";
    self.colorDetailLabel.textAlignment = NSTextAlignmentRight;
    self.colorDetailLabel.font = [UIFont systemFontOfSize:12.0];
    self.colorDetailLabel.textColor = [UIColor lightGrayColor];
    
    self.redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.redBtn setFrame:CGRectMake(23, 45, 50, 50)];
    [self.bottomContainerView addSubview:self.redBtn];
    self.redBtn.backgroundColor = OMCustomRedColor;
    
    self.blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.blackBtn setFrame:CGRectMake(23 + 50 + 10, 45, 50, 50)];
    [self.bottomContainerView addSubview:self.blackBtn];
    self.blackBtn.backgroundColor = [UIColor blackColor];
}


#pragma mark - Update Style With status : hide & show - UP
- (void)updateUIStyle_HideUpContentPart{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - self.contentContainerUpView.frame.size.height);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_ShowUpContentPart{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 130);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_HideUpContentPartWithDownSwitchOff{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - 130 - 110);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_ShowUpContentPartWithDownSwitchOff{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - 110);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 130);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

#pragma mark - Update Style With status : hide & show - DOWN
- (void)updateUIStyle_HideDownContentPart{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - 110);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 130);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_ShowDownContentPart{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 130);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_HideDownContentPartWithUpSwitchOff{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - 110 - 130);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

- (void)updateUIStyle_ShowDownContentPartWithUpSwitchOff{
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50 - 50 - 130);
    self.titleUpContainerView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerUpView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 0);
    
    self.titleDowncontainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height, SCREEN_WIDTH - 10 * 2, 50);
    self.contentContainerDownView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
    
    self.bottomContainerView.frame = CGRectMake(10, self.titleUpContainerView.frame.size.height + self.contentContainerUpView.frame.size.height + self.titleDowncontainerView.frame.size.height + self.contentContainerDownView.frame.size.height, SCREEN_WIDTH - 10 * 2, 110);
}

#pragma mark - Control Items In Each Container Hide & Show
- (void)hideUpContentPart{
    
    self.profitUpImg.hidden = YES;
    self.profitUpLabel.hidden = YES;
    self.profitUpDetailLabel.hidden = YES;
    self.profitUpSlider.hidden = YES;
    // content
    self.marginDesLabel.hidden = YES;
    self.marginInputTextField.hidden = YES;
    self.marginSymbolLabel.hidden = YES;
    self.saveBtn.hidden = YES;
    self.separatorViewHideUp.hidden = YES;
    
}

- (void)hideDownContentPart{
    
    self.profitDownImg.hidden = YES;
    self.profitDownLabel.hidden = YES;
    self.profitDownDetailLabel.hidden = YES;
    self.leftValueLabel.hidden = YES;
    self.rightValueLabel.hidden = YES;
    self.profitDownSlider.hidden = YES;
    self.distributeLabel.hidden = YES;
    self.mineLabel.hidden = YES;
    self.separatorViewHideDown.hidden = YES;
}

- (void)showUpContentPart{
    
    self.profitUpImg.hidden = NO;
    self.profitUpLabel.hidden = NO;
    self.profitUpDetailLabel.hidden = NO;
    self.profitUpSlider.hidden = NO;
    // content
    self.marginDesLabel.hidden = NO;
    self.marginInputTextField.hidden = NO;
    self.marginSymbolLabel.hidden = NO;
    self.saveBtn.hidden = NO;
    self.separatorViewHideUp.hidden = NO;
}

- (void)showDownContentPart{
    
    self.profitDownImg.hidden = NO;
    self.profitDownLabel.hidden = NO;
    self.profitDownDetailLabel.hidden = NO;
    self.leftValueLabel.hidden = NO;
    self.rightValueLabel.hidden = NO;
    self.profitDownSlider.hidden = NO;
    self.distributeLabel.hidden = NO;
    self.mineLabel.hidden = NO;
    self.separatorViewHideDown.hidden = NO;
}


#pragma mark - Switch Control
- (void)recommendControl:(UISwitch *)recommendSwitch{
    
    if (self.recomDownSwitch.on) {
        
        if (recommendSwitch.on) {
            
            [UIView animateWithDuration:0.25 animations:^{
                [self updateUIStyle_ShowUpContentPart];
                [self performSelector:@selector(showUpContentPart) withObject:nil afterDelay:0.15];
            }];
        }
        else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self updateUIStyle_HideUpContentPart];
                [self hideUpContentPart];
            }];
        }
    }
    else{
        
        if (recommendSwitch.on) {
            
            [UIView animateWithDuration:0.25 animations:^{
                [self updateUIStyle_ShowUpContentPartWithDownSwitchOff];
                [self performSelector:@selector(showUpContentPart) withObject:nil afterDelay:0.15];
            }];
        }
        else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self updateUIStyle_HideUpContentPartWithDownSwitchOff];
                [self hideUpContentPart];
            }];
        }
    }
}

- (void)distributeControl:(UISwitch *)distributeSwitch{
    
    if (self.recomUpSwitch.on) {
        
        if (distributeSwitch.on) {
            
            [UIView animateWithDuration:0.25 animations:^{
                [self updateUIStyle_ShowDownContentPart];
                [self performSelector:@selector(showDownContentPart) withObject:nil afterDelay:0.15];
            }];
            
        }
        else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self updateUIStyle_HideDownContentPart];
                [self hideDownContentPart];
                
            }];
            
        }
    }
    else{
        
        if (distributeSwitch.on) {
            
            [UIView animateWithDuration:0.25 animations:^{
                [self updateUIStyle_ShowDownContentPartWithUpSwitchOff];
                [self performSelector:@selector(showDownContentPart) withObject:nil afterDelay:0.15];
            }];
            
        }
        else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self updateUIStyle_HideDownContentPartWithUpSwitchOff];
                [self hideDownContentPart];
                
            }];
            
        }
    }
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = OMSeparatorLineColor;
    
    [self UIInit];
    
    [self.recomUpSwitch setOn:YES animated:NO];
    [self.recomDownSwitch setOn:YES animated:NO];
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
