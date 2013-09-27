//
//  TBuyProductViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TBuyProductViewController.h"

@interface TBuyProductViewController ()

@end

@implementation TBuyProductViewController
//@synthesize addCount,reduceCount,buyMinuteCount;
@synthesize buyMinuteCount,buyCount;
@synthesize prodrctCount;
@synthesize productName,productPrice;

#define kPayPalClientId @"AYGhABDwnjS7rz609rWFpFVA1DWmdA1PilKGHjSTP2jgf6QUWI0bAtYhbSzG"
#define kPayPalReceiverEmail @"dlu-facilitator@suzhoukada.com"
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TBuyProductViewController" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.title=self.productName;
    self.environment = PayPalEnvironmentSandbox;
    [self initNavigationItem];
    prodrctCount=1;
    self.buyMinuteCount.text=[NSString stringWithFormat:@"您一共购买服务%d%@,共花费%.2f美元",prodrctCount,productName,prodrctCount*[productPrice floatValue]];
    self.acceptCreditCards = YES;
    [super viewDidLoad];
}
- (IBAction)addCountAction:(id)sender
{
    prodrctCount++;
    self.buyCount.text=[NSString stringWithFormat:@"%d",prodrctCount];
    
    self.buyMinuteCount.text=[NSString stringWithFormat:@"您一共购买服务%d%@,共花费%.2f美元",prodrctCount,productName,prodrctCount*[productPrice floatValue]];
}
- (IBAction)reduceCountAction:(id)sender
{
    if (prodrctCount>1) {
        prodrctCount--;
    }else
    {
        prodrctCount=0;
    }
    self.buyCount.text=[NSString stringWithFormat:@"%d",prodrctCount];
    self.buyMinuteCount.text=[NSString stringWithFormat:@"您一共购买服务%d%@,共花费%.2f美元",prodrctCount,productName,prodrctCount*[productPrice floatValue]];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.price.text=[NSString stringWithFormat:@"%@$",self.productPrice];
    
    [PayPalPaymentViewController setEnvironment:self.environment];
    [PayPalPaymentViewController prepareForPaymentUsingClientId:kPayPalClientId];
}
- (void)pay {
//    NSString *getCode = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
    NSString *prodects=[NSString stringWithFormat:@"%d%@",prodrctCount,self.productName];
    self.completedPayment = nil;
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%.2f",prodrctCount*[productPrice floatValue] ]];
    payment.currencyCode = @"USD";
    payment.shortDescription =prodects;
    
    if (!payment.processable) {
    }
    
    NSString *customerId = @"32165";
    
    [PayPalPaymentViewController setEnvironment:self.environment];
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientId
                                                                                                 receiverEmail:kPayPalReceiverEmail
                                                                                                       payerId:customerId
                                                                                                       payment:payment
                                                                                                      delegate:self];
    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
    
    paymentViewController.languageOrLocale = @"zh-Hans";
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    [self payConnection:[NSString  stringWithFormat:@"%@",completedPayment.confirmation]];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
//    NSLog(@"PayPal Payment Success!");
    self.completedPayment = completedPayment;
    [self sendCompletedPaymentToServer:completedPayment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
//    NSLog(@"PayPal Payment Canceled");
    self.completedPayment = nil;
//    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)payConnection:(NSString *)payInfo
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
//    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/payInPaypal?userId=%d&deviceId=%d&payInfo=%@",beanstatus.userId,[DeviceUDID initDeviceID],payInfo];
    
    NSString *u_info_url=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/payInPaypal"];
    NSString *info_url=[NSString stringWithFormat:@"userId=%d&deviceId=%d&payInfo=%@",beanstatus.userId,[DeviceUDID initDeviceID],payInfo];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:u_info_url]];
    [urlRequest setHTTPMethod:@"post"];
    [urlRequest setValue:@"PHP-SDK OAuth2.0" forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPBody:[info_url dataUsingEncoding:NSUTF8StringEncoding ]];
    self.payUrl = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.payData =[[NSMutableData alloc] init];
}

#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==self.payUrl) {
        return [self.payData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD dismissWithError:@"登录失败"];
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        [self handleError:error];
    }
    
    self.payUrl = nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    if (connection==self.payUrl) {
        NSString *getCode = [[NSString alloc] initWithData:self.payData encoding:NSUTF8StringEncoding];
//        NSLog(@"get====>%@",getCode);
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSDictionary *rootDic = [parser objectWithString:getCode error:&error];
        
      NSString *payStatus = [rootDic objectForKey:@"state"];
        if ([payStatus isEqualToString:@"ok"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD dismissWithSuccess:response afterDelay:0.5];
        }
        if ([payStatus isEqualToString:@"err"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD dismissWithSuccess:response afterDelay:0.5];
        }
    }
}
- (void)handleError:(NSError *)error
{
    
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接异常,请重新登录！"
														message:errorMessage
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
    [alertView show];
    //    [alertView release];
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
    btntitle.text=@"产品";
    [backview addSubview:backBtn];
    [backBtn addSubview:btntitle];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:backview];
    self.navigationItem.leftBarButtonItem=addContact;
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[buyBtn setImage:[UIImage imageNamed:@"title_button_common.png"] forState:UIControlStateNormal];
	[buyBtn addTarget:self action:@selector(buyProductAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *buytitle=[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 50.0, 30.0)];
    buytitle.backgroundColor=[UIColor clearColor];
    UIView *buyview=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    buyview.backgroundColor=[UIColor clearColor];
    buytitle.textColor=[UIColor whiteColor];
    [buytitle setFont:[UIFont systemFontOfSize:15]];
    buytitle.text=@"购买";
    [buyview addSubview:buyBtn];
    [buyBtn addSubview:buytitle];
    UIBarButtonItem *buyProduct=[[UIBarButtonItem alloc] initWithCustomView:buyview];
    self.navigationItem.rightBarButtonItem=buyProduct;
}
- (IBAction)buyProductAction:(id)sender
{
    if (prodrctCount==0) {
        UIAlertView *alertErrorView=[[UIAlertView alloc]initWithTitle:@"提示！" message:@"购买数量不能为0！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertErrorView show];
    }else
    {
    NSString *message=[NSString stringWithFormat:@"确定花费%.2f美元购买服务？",prodrctCount*[productPrice floatValue]];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示！" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else if(buttonIndex==1)
    {
        [self pay];
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
