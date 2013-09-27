//
//  TLoginViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-2.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TLoginViewController.h"

@interface TLoginViewController ()

@end

@implementation TLoginViewController
@synthesize password,userName;
//@synthesize statusArray;
@synthesize loginConnection,loginData;
@synthesize passwordCheck;
@synthesize autologinCheck;
@synthesize userDiction;
//@synthesize autoArray;
@synthesize loginDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TLoginViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.passwordCheck=nil;
	self.autologinCheck=nil;
}

- (void)dealloc {
//	[autoArray release];
	[passwordCheck release];
	[autologinCheck release];
    [loginConnection release];
    [loginData release];
//    [statusArray release];
    [userDiction release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [password setSecureTextEntry:YES];
    [self loadCheckBoxView];
    [self autoUserLogin];
    checkAutoLogin=NO;
    checkPassword=NO;
    checkA=NO;
    checkP=NO;
//    NSLog(@"md5====%@",[self md5:@"123"]);
}
- (void)loadCheckBoxView {
	BECheckBox *passCheckBox=[[BECheckBox alloc]initWithFrame:CGRectMake(57, 239, 80, 30)];
	[passCheckBox setTitle:@"记住密码" forState:UIControlStateNormal];
	[passCheckBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	passCheckBox.titleLabel.font=[UIFont systemFontOfSize:16];
	[passCheckBox setTarget:self fun:@selector(passCheckBoxClick:)];
	self.passwordCheck=passCheckBox;
	[self.view addSubview:self.passwordCheck];
	[passCheckBox release];
	
	
	BECheckBox *autoLoginBox=[[BECheckBox alloc]initWithFrame:CGRectMake(175, 239, 80, 30)];
	[autoLoginBox setTitle:@"自动登录" forState:UIControlStateNormal];
	autoLoginBox.titleLabel.font=[UIFont systemFontOfSize:16];
	[autoLoginBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[autoLoginBox setTarget:self fun:@selector(autoLoginCheckBoxClick:)];
	self.autologinCheck=autoLoginBox;
	[self.view addSubview:autoLoginBox];
	[autoLoginBox release];
}
//记住密码点击
-(void)passCheckBoxClick:(id)sender
{
	if ([self.passwordCheck isChecked]) {
//		self.infoLabel.text=@"记住密码";
        checkPassword=YES;
	}
	else {
//		self.infoLabel.text=@"取消记住密码";
        checkPassword=NO;
        checkAutoLogin=NO;
        self.autologinCheck.isChecked=NO;
        checkP=YES;
        checkA=YES;
	}
}
//自动登录点击
-(void)autoLoginCheckBoxClick:(id)sender
{
	if ([self.autologinCheck isChecked]) {
//		self.infoLabel.text=@"自动登录";
        checkAutoLogin=YES;
        checkPassword=YES;
        self.passwordCheck.isChecked=YES;
	}
	else {
//		self.infoLabel.text=@"取消自动登录";
        checkAutoLogin=NO;
        checkA=YES;
	}
}

-(IBAction)userLoginAction:(id)sender
{
    if ([NSString_StringEmpty isEmptyOrNull:self.userName.text]) {
        
        [self messageTitle:@"提示！" Message:@"用户名不能为空！"];
    }else
    {
        if([NSString_StringEmpty isEmptyOrNull:self.password.text]){
            
            [self messageTitle:@"提示！" Message:@"密码不能为空！"];
            
        }else{
            [self userLoginConnection];
        }

    }
}
-(void)saveUserInfo
{
//    NSLog(@"checkPassword==>%d",checkPassword);
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    if ([array count]==0) {
        
    }else
    {
    TLoginStatusBean *bean=[array objectAtIndex:0];
        if (checkPassword==NO) {
            if (bean.checkPassowrd==1) {
                if (checkP==NO) {
                   checkPassword=YES; 
                }
            }
        }
        if (checkAutoLogin==NO) {
            if (bean.checkAutoLogin==1) {
                if (checkA==NO) {
                    checkAutoLogin=YES;
                }
            }
        }
    }
    if (checkAutoLogin==YES) {
        if (checkPassword==YES) {
           NSMutableArray* statusArray=[[NSMutableArray alloc] init];
            [[HelpDataBase instance] queryTotable:statusArray];
            TLoginStatusBean *beanstatus=[[TLoginStatusBean alloc]init];
            beanstatus.userName=self.userName.text;
            beanstatus.status=1;
            beanstatus.userId= [[userDiction objectForKey:@"userId"] integerValue];
            beanstatus.userPassword=self.password.text;
            beanstatus.checkAutoLogin=1;
            beanstatus.checkPassowrd=1;
            beanstatus.nothingCheck=1;
            if ([statusArray count]==0) {
                [[HelpDataBase instance] insertTotable:beanstatus];
            }else
            {
                [[HelpDataBase instance] updateTotable:beanstatus];
            }
            [beanstatus release];
            [statusArray  release];
        }else
        {
            NSMutableArray* statusArray=[[NSMutableArray alloc] init];
            [[HelpDataBase instance] queryTotable:statusArray];
            TLoginStatusBean *beanstatus=[[TLoginStatusBean alloc]init];
            beanstatus.userName=self.userName.text;
            beanstatus.status=1;
            beanstatus.userId= [[userDiction objectForKey:@"userId"] integerValue];
            beanstatus.userPassword=self.password.text;
            beanstatus.checkAutoLogin=1;
            beanstatus.checkPassowrd=0;
            beanstatus.nothingCheck=1;
            if ([statusArray count]==0) {
                [[HelpDataBase instance] insertTotable:beanstatus];
            }else
            {
                [[HelpDataBase instance] updateTotable:beanstatus];
            }
            [beanstatus release];
            [statusArray  release];
        }
        
    }else
    {
        if (checkPassword==YES) {
            NSMutableArray* statusArray=[[NSMutableArray alloc] init];
            [[HelpDataBase instance] queryTotable:statusArray];
            TLoginStatusBean *beanstatus=[[TLoginStatusBean alloc]init];
            beanstatus.userName=self.userName.text;
            beanstatus.status=1;
            beanstatus.userId= [[userDiction objectForKey:@"userId"] integerValue];
            beanstatus.userPassword=self.password.text;
            beanstatus.checkAutoLogin=0;
            beanstatus.checkPassowrd=1;
            beanstatus.nothingCheck=0;
            if ([statusArray count]==0) {
                [[HelpDataBase instance] insertTotable:beanstatus];
            }else
            {
                [[HelpDataBase instance] updateTotable:beanstatus];
            }
            [beanstatus release];
            [statusArray  release];
        }else
        {
            NSMutableArray* statusArray=[[NSMutableArray alloc] init];
            [[HelpDataBase instance] queryTotable:statusArray];
            TLoginStatusBean *beanstatus=[[TLoginStatusBean alloc]init];
            beanstatus.userName=@"";
            beanstatus.status=0;
            beanstatus.userId= [[userDiction objectForKey:@"userId"] integerValue];
            beanstatus.userPassword=@"";
            beanstatus.checkAutoLogin=0;
            beanstatus.checkPassowrd=0;
            beanstatus.nothingCheck=0;
            if ([statusArray count]==0) {
                [[HelpDataBase instance] insertTotable:beanstatus];
            }else
            {
                [[HelpDataBase instance] updateTotable:beanstatus];
            }
            [beanstatus release];
            [statusArray  release];
        }
    }
    [array release];
}
-(void)autoUserLogin
{
     NSMutableArray *autoArray=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:autoArray];
    if ([autoArray count]==0) {
    }else
    {
        TLoginStatusBean *beanstatus=[autoArray objectAtIndex:0];
        if (beanstatus.checkPassowrd==1) {
            if (beanstatus.checkAutoLogin==1) {
                self.userName.text=beanstatus.userName;
                self.password.text=beanstatus.userPassword;
                self.passwordCheck.isChecked=YES ;
                self.autologinCheck.isChecked=YES;
               // [self loginConnection];
            }else
            {
                self.userName.text=beanstatus.userName;
                self.password.text=beanstatus.userPassword;
                self.passwordCheck.isChecked=YES ;
            }
        }else
        {
            if (beanstatus.checkAutoLogin==1) {
                self.userName.text=beanstatus.userName;
                self.password.text=beanstatus.userPassword;
                self.passwordCheck.isChecked=YES ;
                self.autologinCheck.isChecked=YES;
                //[self loginConnection];
            }
        }
//        NSLog(@"%d",[self.autoArray count]);
    }
    [autoArray release];
}
-(void)userLoginConnection
{
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeGradient];
    
//    NSLog(@"deviceID==>%@",deviceUID);
    if (loginConnection!=nil) {
        [loginConnection release];
    }
    if (loginData!=nil) {
        [loginData release];
    }
    NSString *url=[NSString stringWithFormat:@"http://122.193.29.102:82/Login?username=%@&password=%@&deviceId=%d",self.userName.text,[TEncryptionPassword encryptionPasswordForMd5:self.password.text]  ,[DeviceUDID initDeviceID]];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    loginConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    loginData =[[NSMutableData alloc] init];
}

#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==loginConnection) {
        return [loginData appendData:data];
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
    
    loginConnection = nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSError *error = nil;
    if (connection==loginConnection) {
        NSString *getCode = [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSDictionary *rootDic = [parser objectWithString:getCode error:&error];
        
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        
        if ([loginStatus isEqualToString:@"ok"]) {
            NSDictionary *response = [rootDic objectForKey:@"response"];
            self.userDiction=response;
            [self saveUserInfo];
            [SVProgressHUD dismissWithSuccess:@"登陆成功！" afterDelay:1.0];
            [self.loginDelegate loginState:YES];
            [self dismissViewControllerAnimated:YES completion:nil];

        }else
        {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showErrorWithStatus:response duration:1.0];
        }
        
//        NSLog(@"loginStatus===>%@",loginStatus);
        [parser release];
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

-(IBAction)userRegistAction:(id)sender
{
    RegistViewController *regist=[[RegistViewController alloc] init];
    regist.fromView=YES;
    [self.navigationController pushViewController:regist animated:YES];
    [regist release];
}
-(IBAction)forgetPassword:(id)sender
{
    RegistViewController *regist=[[RegistViewController alloc] init];
    regist.fromView=NO;
    [self.navigationController pushViewController:regist animated:YES];
    [regist release];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}
-(IBAction)keyBorderHideAction:(id)sender
{
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
}
@end
