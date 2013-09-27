//
//  TForgetPasswordViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TForgetPasswordViewController.h"

@interface TForgetPasswordViewController ()

@end

@implementation TForgetPasswordViewController
@synthesize password,passwordAgain,code;
@synthesize phoneNumber;
@synthesize codeLable;
@synthesize codeNumber;
@synthesize forgetConnection;
@synthesize forgetData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TForgetPasswordViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [phoneNumber release];
    [codeNumber release];
    [codeLable release];
    [forgetConnection release];
    [forgetData release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.codeLable.text=self.codeNumber;
    [password setSecureTextEntry:YES];
    [passwordAgain setSecureTextEntry:YES];
}
-(IBAction)savePasswordAction:(id)sender
{
    if ([self.code.text isEqualToString:@""]) {
        [self messageTitle:@"提示！" Message:@"请输入验证码！"];
    }else
    {
        if ([self.password.text isEqualToString:@""]|| [NSString_StringEmpty isEmptyOrNull:self.password.text]) {
            [self messageTitle:@"提示！" Message:@"请输入密码！"];
        }else
        {
            if ([self.passwordAgain.text isEqualToString:@""]|| [NSString_StringEmpty isEmptyOrNull:self.passwordAgain.text]) {
                [self messageTitle:@"提示！" Message:@"请再次输入密码！"];
            }else
            {
                if ([self.password.text isEqualToString:self.passwordAgain.text]) {
                    [self getCodeConnection];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"密码不一样，请重新输入！" duration:1.0];
                }
            }
        }
    }
}
-(void)getCodeConnection
{
    [SVProgressHUD showWithStatus:@"更改密码..." maskType:SVProgressHUDMaskTypeGradient];
    if (forgetData!=nil) {
        [forgetData release];
    }
    if (forgetConnection!=nil) {
        [forgetConnection release];
    }
      NSString *url=[NSString stringWithFormat:@"http://122.193.29.102:82/GetPassword?password=%@&password2=%@&mobile_phone=%@&code=%@",self.password.text,self.passwordAgain.text,self.phoneNumber,self.code.text];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:5.0];
    forgetConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    forgetData =[[NSMutableData alloc] init];
}

#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==self.forgetConnection) {
        return [self.forgetData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"更改密码失败" duration:1.0];
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
    
    self.forgetConnection = nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==self.forgetConnection) {
        NSString *getCode = [[NSString alloc] initWithData:self.forgetData encoding:NSUTF8StringEncoding];
//        NSLog(@"getCode===>%@",getCode);
        if ([getCode isEqualToString:@"电话号码未注册"]) {
            [SVProgressHUD showErrorWithStatus:getCode duration:1.0];
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功" duration:1.0];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.code resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    return YES;
}
-(IBAction)keyBorderHideAction:(id)sender
{
    [self.code resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
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
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    [self.code resignFirstResponder];
}
@end
