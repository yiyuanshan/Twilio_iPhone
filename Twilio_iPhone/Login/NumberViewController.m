//
//  NumberViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "NumberViewController.h"

@interface NumberViewController ()

@end

@implementation NumberViewController
@synthesize successView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"NumberViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *string=[NSString stringWithFormat:@"我们将随机分配给您一个号码，请您记住这个号码，或者在您登录成功后可以进入个人资料里面查看此号码：%@，这个号码用于显示在对方的手机上。",@"18913162828"];
    self.successView.scrollEnabled=NO;
    self.successView.text=string;
}
-(IBAction)loginAction:(id)sender
{

}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
