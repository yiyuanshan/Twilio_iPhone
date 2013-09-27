//
//  RegistGetCodeViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "RegistGetCodeViewController.h"

@interface RegistGetCodeViewController ()

@end

@implementation RegistGetCodeViewController
@synthesize code;
@synthesize titleText;
@synthesize userName,password,passwordAgain;
@synthesize phoneNumber;
@synthesize codeLable;
@synthesize registURL,registData;
@synthesize codeNumber;

-(void)dealloc
{
    [registData release];
    [registURL release];
    [code release];
    [titleText release];
    [userName release];
    [passwordAgain release];
    [password release];
    [phoneNumber release];
    [codeLable release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RegistGetCodeViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.codeLable.text=self.codeNumber;
    [password setSecureTextEntry:YES];
    [passwordAgain setSecureTextEntry:YES];
    self.code.text=self.codeNumber;
}

- (void)registerConnection
{
    [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeGradient];
    if (registData!=nil) {
        [registData release];
    }
    if (registURL!=nil) {
        [registURL release];
    }
    NSString *url=[NSString stringWithFormat:@"http://122.193.29.102:82/Register?password=%@&password2=%@&mobile_phone=%@&code=%@&user_name=%@",self.password.text,self.passwordAgain.text,self.phoneNumber,self.code.text,self.userName.text];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"url==>%@",url);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:5.0];
    registURL = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    registData =[[NSMutableData alloc] init];
}
-(IBAction)registAction:(id)sender
{
    if ([NSString_StringEmpty isEmptyOrNull:self.code.text]) {
        [self messageTitle:@"提示！" Message:@"请输入验证码！"];
    }else
    {
        if ([NSString_StringEmpty isEmptyOrNull:self.userName.text]) {
            [self messageTitle:@"提示！" Message:@"请输入用户名！"];
        }else
        {
            if ([NSString_StringEmpty isEmptyOrNull:self.password.text]) {
                [self messageTitle:@"提示！" Message:@"请输入密码！"];
            }else
            {
                if ([NSString_StringEmpty isEmptyOrNull:self.passwordAgain.text]) {
                    [self messageTitle:@"提示！" Message:@"请再次输入密码！"];
                }else
                {
                    if ([self.password.text isEqualToString:self.passwordAgain.text]) {
                        [self registerConnection];
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:@"密码不一样，请重新输入！" duration:1.0];
                    }
                    
                }
            }
        }
    }
    
    
    
    
//    NumberViewController *getNumber=[[NumberViewController alloc] init];
//    [self.navigationController pushViewController:getNumber animated:YES];
}

#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==registURL) {
        return [registData appendData:data];
    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"注册失败！" duration:1.0];
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
    
    registURL=nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==registURL) {
        NSString *getStatus = [[NSString alloc] initWithData:registData encoding:NSUTF8StringEncoding];
//        NSLog(@"info===>%@",getStatus);
        if ([getStatus isEqualToString:@"成功"]) {
            
            [SVProgressHUD showSuccessWithStatus:getStatus duration:1.0 ];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:getStatus duration:1.0];
        }
        [getStatus release];
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
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    [self.code resignFirstResponder];
    return YES;
}
-(IBAction)keyBorderHideAction:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    [self.code resignFirstResponder];
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
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    [self.code resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
