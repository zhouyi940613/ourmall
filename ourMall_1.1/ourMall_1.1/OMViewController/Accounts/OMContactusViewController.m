//
//  OMContactusViewController.m
//  ourMall_1.1
//
//  Created by Jay on 16/5/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import "OMContactusViewController.h"


@interface OMContactusViewController ()

@property (weak, nonatomic) IBOutlet UIButton *contactFBBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactTWBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactIGBtn;

@end

@implementation OMContactusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Contact us URL With iOS Browser
- (IBAction)contactFacrbookAction:(id)sender {
    [APPLICATION_SETTING openURL:[NSURL URLWithString:OMCONTACT_FACEBOOK]];
}
- (IBAction)contactTwitterAction:(id)sender {
    [APPLICATION_SETTING openURL:[NSURL URLWithString:OMCONTACT_TWITTER]];
}
- (IBAction)contactInstagramAction:(id)sender {
    [APPLICATION_SETTING openURL:[NSURL URLWithString:OMCONTACT_INSTAGRAM]];
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
