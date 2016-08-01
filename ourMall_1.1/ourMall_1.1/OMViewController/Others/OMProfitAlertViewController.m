//
//  OMProfitAlertViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/7/22.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMProfitAlertViewController.h"

@interface OMProfitAlertViewController ()

@property(nonatomic, strong) NSString *ValueStr;

@property(nonatomic, strong) NSNumber *profitDefaultValue;
@property(nonatomic, strong) NSNumber *profitDefaultMargin;
@property(nonatomic, strong) NSNumber *supplyPrice;

@end

@implementation OMProfitAlertViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.profitSegmentControl addTarget:self action:@selector(changePageLeftOrRight:) forControlEvents:UIControlEventValueChanged];
    
    self.leftView.frame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    self.rightView.frame = CGRectMake(self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    
    NSArray *viewArr = @[self.leftView, self.rightView];
    for (UIView *temp in viewArr) {
        [self.mainScrollView addSubview:temp];
    }
    
    [self UISettings];
    
    [self.profitSlider addTarget:self action:@selector(sliderDragAction:) forControlEvents:UIControlEventValueChanged];
    self.profitSlider.maximumValue = 100.0;
    self.profitSlider.minimumValue = 0.0;
    
    [NOTIFICATION_SETTING addObserver:self selector:@selector(setUIValue:) name:@"modalityTransformValue" object:nil];
 
    self.leftTextField.delegate = self;
    self.rightTextField.delegate = self;
    
    
}

- (void)setUIValue:(NSNotification *)notice{
   
    NSNumber *tempNum = [notice.userInfo objectForKey:@"margin"];
    self.profitDefaultMargin = tempNum;
    NSNumber *tempNumRight = [notice.userInfo objectForKey:@"value"];
    self.profitDefaultValue = tempNumRight;
    NSNumber *tempPrice = [notice.userInfo objectForKey:@"defaultPrice"];
    self.supplyPrice = tempPrice;
    
    CGFloat supplyPrice = self.profitDefaultValue.floatValue / self.profitDefaultMargin.floatValue;
    
    // right value
    CGFloat value = tempNumRight.floatValue;
    self.rightTextField.text = [NSString stringWithFormat:@"%.2f", value];
    
    if (value > self.supplyPrice.floatValue) {
        
        self.leftTextField.text = [NSString stringWithFormat:@"%.2f", self.rightTextField.text.floatValue / self.supplyPrice.floatValue * 100];
        [self.profitSlider setValue:100.0 animated:NO];
        self.profitTitleLabel.text = @"Max+";
        CGFloat horizontalPosition = self.profitSlider.value * (self.profitSlider.frame.size.width / 100.0);
        self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
    }
    else{
        // left value
        CGFloat defaultMargin = tempNum.floatValue * 100;
        NSString *tempStr = [NSString stringWithFormat:@"%.2f", defaultMargin];
        
        [self.profitSlider setValue:defaultMargin animated:NO];
        self.leftTextField.text = tempStr;
        
        self.profitTitleLabel.text = [tempStr stringByAppendingString:@"%"];
        CGFloat horizontalPosition = self.profitSlider.value * (self.profitSlider.frame.size.width / 100.0);
        self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
    }
}

- (void)UISettings{
    
    [OMCustomTool setcornerOfView:self.cancelBtn withRadius:5 color:ClearBackGroundColor];
    [OMCustomTool setcornerOfView:self.saveBtn withRadius:5 color:ClearBackGroundColor];
}

- (void)changePageLeftOrRight:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex == 0) {
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width, 0) animated:YES];
    }
}

- (IBAction)closeBtnClickedAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        
    }];
}

- (IBAction)cancelBtnClickedAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)saveBtnClickedAction:(id)sender {
    
    self.ValueStr = self.rightTextField.text;
    
    [self.delegate saveBnttonClickedEvent_WithTextFieldValue:self.ValueStr];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // cache settings
    [SETTINGs setValue:self.rightTextField.text forKey:OMCACHE_SHOP_MOTI_KEY];
    [SETTINGs synchronize];
}

#pragma mark - Slider Drag Action
- (void)sliderDragAction:(UISlider *)slider{
    
    CGFloat horizontalPosition = slider.value * (slider.frame.size.width / 100.0);
    self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
    
    NSString *str = [NSString stringWithFormat:@"%.2f", slider.value];
    self.profitTitleLabel.text = [NSString stringWithFormat:@"%@", str];
    self.profitTitleLabel.text = [self.profitTitleLabel.text stringByAppendingString:@"%"];
    
    // left value
    self.leftTextField.text = [NSString stringWithFormat:@"%@", str];
    
    // right value
//    CGFloat supplyPrice = self.profitDefaultValue.floatValue / self.profitDefaultMargin.floatValue;
//    CGFloat newPrice = self.supplyPrice.floatValue * slider.value / 100.0;
    self.rightTextField.text = [NSString stringWithFormat:@"%.2f", self.supplyPrice.floatValue * slider.value / 100.0];
}


#pragma mark - TextField Delegate Method
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.leftTextField) {
        // set value for slider
        NSString *regex = @"^[0-9]*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:textField.text];
        
        if (isValid) {
            if ((textField.text.integerValue > 0 || textField.text.integerValue == 0) && (textField.text.integerValue < 100 || textField.text.integerValue == 100)) {
                
                [self.profitSlider setValue:textField.text.floatValue animated:YES];
                
                CGFloat horizontalPosition = textField.text.integerValue * (self.profitSlider.frame.size.width / 100.0);
                self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
                
                self.profitTitleLabel.text = textField.text;
                self.profitTitleLabel.text = [self.profitTitleLabel.text stringByAppendingString:@"%"];
            }
            else{
                [OMCustomTool OMshowAlertViewWithMessage:@"Please input available value with range!" fromViewController:self];
            }
        }
        else{
            [OMCustomTool OMshowAlertViewWithMessage:@"You can only input Arabic numerals!" fromViewController:self];
        }
    }
    else{
        // set value for slider
        NSString *regex = @"^[0-9]+(.[0-9]{1,2})?$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:textField.text];
        
//        CGFloat supplyPrice = self.profitDefaultValue.floatValue / self.profitDefaultMargin.floatValue;
        
        if (isValid) {
            if (textField.text.floatValue > 0 || textField.text.floatValue == 0) {
                
                if (textField.text.floatValue > self.supplyPrice.floatValue) {
                    [self.profitSlider setValue:100.0 animated:YES];
                    self.profitTitleLabel.text = @"Max+";
                    self.leftTextField.text = [NSString stringWithFormat:@"%.2f", self.rightTextField.text.floatValue / self.supplyPrice.floatValue * 100];
                    CGFloat horizontalPosition = self.profitSlider.value * (self.profitSlider.frame.size.width / 100.0);
                    self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
                }
                else{
                    
                    CGFloat newMargin = textField.text.floatValue / self.supplyPrice.floatValue;
                    
                    [self.profitSlider setValue:newMargin * 100.0 animated:YES];
                    
                    CGFloat horizontalPosition = textField.text.integerValue * (self.profitSlider.frame.size.width / 100.0);
                    self.profitTitleLabel.frame = CGRectMake(horizontalPosition, 8, 60, 15);
                    
                    self.profitTitleLabel.text = [NSString stringWithFormat:@"%.2f", newMargin * 100];
                    self.leftTextField.text = [NSString stringWithFormat:@"%.2f", self.rightTextField.text.floatValue / self.supplyPrice.floatValue * 100];
                    
                    self.profitTitleLabel.text = [self.profitTitleLabel.text stringByAppendingString:@"%"];
                }
                
            }
            else{
                [OMCustomTool OMshowAlertViewWithMessage:@"Please input available value with range!" fromViewController:self];
            }
        }
        else{
            [OMCustomTool OMshowAlertViewWithMessage:@"You can only input Arabic numerals!" fromViewController:self];
        }
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
