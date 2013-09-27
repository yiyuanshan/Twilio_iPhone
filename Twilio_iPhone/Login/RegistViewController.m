//
//  RegistViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
@synthesize phoneNumber;
@synthesize fromView;
@synthesize sendPhoneURL,sendPhoneData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RegistViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    [sendPhoneData release];
    [sendPhoneURL release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)getCodeAction:(id)sender
{
    if ([NSString_StringEmpty isEmptyOrNull:self.phoneNumber.text]) {
        [self messageTitle:@"提示！" Message:@"手机号码不能为空"];
    }else {
        [self getCodeConnection];
    }
}
-(void)getCodeConnection
{
    [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeGradient ];
    NSString *url;
    if (sendPhoneData!=nil) {
        [sendPhoneData release];
    }
    if (sendPhoneURL!=nil) {
        [sendPhoneURL release];
    }
    if (fromView) {
        url=[NSString stringWithFormat:@"http://122.193.29.102:82/GetRegisterCode?mobile_phone=%@",self.phoneNumber.text];
    }else
    {
        url=[NSString stringWithFormat:@"http://122.193.29.102:82/ForgetPasswordGetCode?mobile_phone=%@",self.phoneNumber.text];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:5.0];
    sendPhoneURL = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    sendPhoneData =[[NSMutableData alloc] init];
}

#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==sendPhoneURL) {
        return [sendPhoneData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
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
    
    sendPhoneURL = nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==sendPhoneURL) {
        NSString *getCode = [[NSString alloc] initWithData:sendPhoneData encoding:NSUTF8StringEncoding];
//        NSLog(@"getCode===>%@",getCode);
        if (fromView) {
            if ([getCode isEqualToString:@"电话已经被注册"]) {
                [SVProgressHUD showErrorWithStatus:getCode duration:1.0];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送" duration:1.0];
                RegistGetCodeViewController *getCodeView=[[RegistGetCodeViewController alloc] init];
                getCodeView.phoneNumber=self.phoneNumber.text;
                getCodeView.codeNumber=getCode;
                [self.navigationController pushViewController:getCodeView animated:YES];
                [getCodeView release];
            }
        }else{
            if ([getCode isEqualToString:@"电话号码未注册"]) {
                [SVProgressHUD showErrorWithStatus:getCode duration:1.0];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送" duration:1.0];
                TForgetPasswordViewController *forgetView=[[TForgetPasswordViewController alloc] init];
                forgetView.phoneNumber=self.phoneNumber.text;
                forgetView.codeNumber=getCode;
                [self.navigationController pushViewController:forgetView animated:YES];
                [forgetView release];
            }
        }
       
        [getCode release];
    }
}
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接异常"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneNumber resignFirstResponder];
    return YES;
}
-(IBAction)keyBorderHide:(id)sender
{
    [self.phoneNumber resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self scrllIntoView:textField leaveView:NO isLogin:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self scrllIntoView:textField leaveView:YES isLogin:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneNumber resignFirstResponder];
}
@end
