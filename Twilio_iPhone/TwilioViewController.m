//
//  TwilioViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-2.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TwilioViewController.h"
#import "TCallViewController.h"
#import "TRecordViewController.h"
#import "TContactViewController.h"
#import "TSubscripteViewController.h"
#import "TMoreViewController.h"
#import "TLoginViewController.h"
#import "SBJson.h"
#import "SVProgressHUD.h"


@interface TwilioViewController ()

@end

@implementation TwilioViewController
@synthesize tabbarcontroller;
@synthesize autoArray;
@synthesize loginConnection,loginData;
@synthesize userDiction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TwilioViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//        dispatch_async(dispatch_get_current_queue(), ^{
            
//        });
//    });
    [self initTabBarItem];
}
-(void)initTabBarItem
{
    self.tabbarcontroller=[[UITabBarController alloc] init];
	TCallViewController *callView=[[TCallViewController alloc] init];
    UINavigationController *callView_NV=[[UINavigationController alloc] initWithRootViewController:callView];
    [[callView_NV navigationBar ] setBackgroundImage:[UIImage imageNamed:@"top_bar.png" ] forBarMetrics:UIBarMetricsDefault];
    callView_NV.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"拨号" image:[UIImage imageNamed:@"tab_call.png"] tag:0] ;
    
    TContactViewController *contactView=[[TContactViewController alloc] init];
    UINavigationController *contactView_NV=[[UINavigationController alloc] initWithRootViewController:contactView];
    [[contactView_NV navigationBar ] setBackgroundImage:[UIImage imageNamed:@"top_bar.png" ] forBarMetrics:UIBarMetricsDefault];
    contactView_NV.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"tab_call.png"] tag:0] ;
    
    TRecordViewController *recodView=[[TRecordViewController alloc] init];
    UINavigationController *recodView_NV=[[UINavigationController alloc] initWithRootViewController:recodView];
    [[recodView_NV navigationBar ] setBackgroundImage:[UIImage imageNamed:@"top_bar.png" ] forBarMetrics:UIBarMetricsDefault];
    recodView_NV.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"联系记录" image:[UIImage imageNamed:@"tab_call.png"] tag:0] ;
    
    TSubscripteViewController *subscripteView=[[TSubscripteViewController alloc] init];
    UINavigationController *subscripteView_NV=[[UINavigationController alloc] initWithRootViewController:subscripteView];
    [[subscripteView_NV navigationBar ] setBackgroundImage:[UIImage imageNamed:@"top_bar.png" ] forBarMetrics:UIBarMetricsDefault];
    subscripteView_NV.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"购买" image:[UIImage imageNamed:@"tab_call.png"] tag:0] ;
    
    TMoreViewController *moreView=[[TMoreViewController alloc] init];
    UINavigationController *moreView_NV=[[UINavigationController alloc] initWithRootViewController:moreView];
    [[moreView_NV navigationBar ] setBackgroundImage:[UIImage imageNamed:@"top_bar.png" ] forBarMetrics:UIBarMetricsDefault];
    moreView_NV.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"tab_more.png"] tag:0] ;
    
    [[self.tabbarcontroller tabBar]setBackgroundImage:[[UIImage imageNamed:@"top_bar.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0]];
    
    self.tabbarcontroller.viewControllers=@[callView_NV,contactView_NV,recodView_NV,subscripteView_NV,moreView_NV];
    [self.view addSubview:self.tabbarcontroller.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidAppear:)//接收消息方法
                                                 name:@"LoginOut"//消息识别名称
                                               object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    autoArray=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:self.autoArray];

    if ([self.autoArray count]==0) {
        TLoginViewController *loginView=[[TLoginViewController alloc] init ];
        UINavigationController *login_NV=[[UINavigationController alloc] initWithRootViewController:loginView];
        loginView.loginDelegate=self;
        [self presentViewController:login_NV animated:YES completion:nil];
    }else{
        TLoginStatusBean *beanstatus=[self.autoArray objectAtIndex:0];
        if (beanstatus.status==1 && beanstatus.checkAutoLogin==1) {
            if (autoLoginStatus) {
            }else
            {
                [self autoUserLogin];
            }
        }else if(beanstatus.nothingCheck==0 ){
            beanstatus.nothingCheck=1;
            [[HelpDataBase instance] updateTotable:beanstatus];
          
         
        }else{
            TLoginViewController *loginView=[[TLoginViewController alloc] init ];
            UINavigationController *login_NV=[[UINavigationController alloc] initWithRootViewController:loginView];
            loginView.loginDelegate=self;
            [self presentViewController:login_NV animated:YES completion:nil];
        }
    }
}
-(void)autoUserLogin
{
     NSMutableArray *Array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:Array];
    TLoginStatusBean *beanstatus=[Array objectAtIndex:0];
    [self userLoginConnection:beanstatus.userName AutoPassword:beanstatus.userPassword];
}

-(void)saveUserInfo
{
    NSMutableArray *Array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:Array];
    TLoginStatusBean *bean=[Array objectAtIndex:0];
    TLoginStatusBean *beanstatus=[[TLoginStatusBean alloc]init];
    beanstatus.userName=[userDiction objectForKey:@"username"];
    beanstatus.userId= [[userDiction objectForKey:@"userId"] integerValue];
    beanstatus.status=1;
    beanstatus.userPassword=bean.userPassword;
    beanstatus.checkAutoLogin=1;
    beanstatus.checkPassowrd=1;
    beanstatus.nothingCheck=1;
    [[HelpDataBase instance] updateTotable:beanstatus];
}
-(void)userLoginConnection:(NSString *)userName AutoPassword:(NSString *)password
{
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeGradient];

    NSString *url=[NSString stringWithFormat:@"http://122.193.29.102:82/Login?username=%@&password=%@&deviceId=%d",userName,[TEncryptionPassword encryptionPasswordForMd5:password],[DeviceUDID initDeviceID]];
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
            [SVProgressHUD dismissWithSuccess:@"登陆成功！" afterDelay:0.5];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showErrorWithStatus:response duration:0.5];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        TLoginViewController *loginView=[[TLoginViewController alloc] init ];
        UINavigationController *login_NV=[[UINavigationController alloc] initWithRootViewController:loginView];
        loginView.loginDelegate=self;
        [self presentViewController:login_NV animated:YES completion:nil];
    }
}

-(void)loginState:(BOOL)sta
{
    autoLoginStatus=sta;
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginOut" object:nil];
    [super viewWillDisappear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
