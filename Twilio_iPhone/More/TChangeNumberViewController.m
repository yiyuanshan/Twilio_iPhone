//
//  TChangeNumberViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TChangeNumberViewController.h"


@interface TChangeNumberViewController ()

@end

@implementation TChangeNumberViewController
@synthesize inputPhoneNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TChangeNumberViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title=@"修改号码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationItem];
}
- (void)initNavigationItem
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[backBtn setImage:[UIImage imageNamed:@"title_button_back.png"] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *btntitle=[[UILabel alloc] initWithFrame:CGRectMake(11.0, 0.0, 50.0, 30.0)];
    btntitle.backgroundColor=[UIColor clearColor];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    backview.backgroundColor=[UIColor clearColor];
    btntitle.textColor=[UIColor whiteColor];
    [btntitle setFont:[UIFont systemFontOfSize:15]];
    btntitle.text=@"返回";
    [backview addSubview:backBtn];
    [backBtn addSubview:btntitle];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:backview];
    self.navigationItem.leftBarButtonItem=addContact;
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[buyBtn setImage:[UIImage imageNamed:@"title_button_common.png"] forState:UIControlStateNormal];
	[buyBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *buytitle=[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 50.0, 30.0)];
    buytitle.backgroundColor=[UIColor clearColor];
    UIView *buyview=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    buyview.backgroundColor=[UIColor clearColor];
    buytitle.textColor=[UIColor whiteColor];
    [buytitle setFont:[UIFont systemFontOfSize:15]];
    buytitle.text=@"发送";
    [buyview addSubview:buyBtn];
    [buyBtn addSubview:buytitle];
    UIBarButtonItem *buyProduct=[[UIBarButtonItem alloc] initWithCustomView:buyview];
    self.navigationItem.rightBarButtonItem=buyProduct;
}
- (IBAction)getCodeAction:(id)sender
{
    TChangCodeViewController *getCode=[[TChangCodeViewController alloc] init];
    [self.navigationController pushViewController:getCode animated:YES];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)keyBorderHideAction:(id)sender
{
    [self.inputPhoneNumber resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputPhoneNumber resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
