//
//  TContactInFoController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-22.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TContactInFoController.h"


@interface TContactInFoController ()

@end

@implementation TContactInFoController
@synthesize editContactInfoLable;

@synthesize Name,Phone;
@synthesize editContactInfoData;
@synthesize editContactInfoConnection;
@synthesize contactId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TContactInFoController" bundle:nibBundleOrNil];
    if (self) {
        self.title=@"联系人信息";
    }
    return self;
}
-(void)dealloc
{
    [editContactInfoConnection release];
    [editContactInfoData release];
    [editContactInfoLable release];

    [Name release];
    [contactId release];
    [Phone release];
    [super dealloc];
    
}
- (void)viewDidLoad
{
    editStatus=YES;
    [self initNavigationItem];
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.contactName.text=Name;
    self.contactPhone.text=Phone;
}
-(void)textfieldEmpty
{
    if ([NSString_StringEmpty isEmptyOrNull:self.contactName.text] ) {
        [self messageTitle:@"提示！" Message:@"联系人姓名不能为空"];
    }else
    {
        if ([NSString_StringEmpty isEmptyOrNull:self.contactPhone.text] ) {
            [self messageTitle:@"提示！" Message:@"联系人号码不能为空"];
        }else
        {
            editContactInfoLable.text=@"编辑";
            editStatus=YES;
            [self initEditContactInfoConnection ];
            [self editUnTouch];
        }
    }
}

-(void)initEditContactInfoConnection
{
    [SVProgressHUD showWithStatus:@"修改联系人信息..." maskType:SVProgressHUDMaskTypeGradient];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    
    if (editContactInfoConnection!=nil) {
        [editContactInfoConnection release];
    }
    if (editContactInfoData!=nil) {
        [editContactInfoData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/AddContact?userId=%d&deviceId=%d&contactName=%@&contactNumber=%@&contactId=%@",beanstatus.userId,[DeviceUDID initDeviceID],self.contactName.text,self.contactPhone.text,contactId];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    editContactInfoConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    editContactInfoData=[[NSMutableData alloc] init];
    [array release];
    
}

-(IBAction)callAction:(id)sender
{
    TwilioAppDelegate* appDelegate = (TwilioAppDelegate*)[UIApplication sharedApplication].delegate;
    MonkeyPhone* phone = appDelegate.phone;
    [phone connect:self.contactPhone.text];
    NSString *str = [self.contactPhone.text stringByReplacingOccurrencesOfString :@"-" withString:@""];
    NSString *number = [str stringByReplacingOccurrencesOfString :@"+86" withString:@""];
    TCallConnectingViewController *callView=[[TCallConnectingViewController alloc] init];
    NSString *times = [[self getTime] stringByReplacingOccurrencesOfString :@" " withString:@"+"];
    callView.startTimes=times;
    callView.moblieNumber=number;
    callView.Millisecond=[self getMillisecond];
    [self presentViewController:callView animated:YES completion:nil];
    [callView release];
}
-(NSString *)getTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datetime = [formatter stringFromDate:[NSDate date]];
    NSString *now_time = [NSString stringWithFormat:@"%@",datetime];
    [formatter release];
    return now_time;
}
-(NSString *)getMillisecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
    NSString *datetime = [formatter stringFromDate:[NSDate date]];
    NSString *now_time = [NSString stringWithFormat:@"%@",datetime];
    [formatter release];
    return now_time;
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)editContactInfoAction:(id)sender
{
    if (editStatus) {
        editContactInfoLable.text=@"保存";
        editStatus=NO;
        [self editTouch];
        
    }else{
        [self textfieldEmpty];
    }
}
-(void)editTouch
{
    self.contactAddress.enabled=YES;
    self.contactAddress.textColor=[UIColor blackColor];
    self.contactName.enabled=YES;
    self.contactName.textColor=[UIColor blackColor];
    self.contactPhone.enabled=YES;
    self.contactPhone.textColor=[UIColor blackColor];
    self.otherText.enabled=YES;
    self.otherText.textColor=[UIColor blackColor];
}
-(void)editUnTouch
{
    self.contactAddress.enabled=NO;
    self.contactAddress.textColor=[UIColor lightGrayColor];
    self.contactName.enabled=NO;
    self.contactName.textColor=[UIColor lightGrayColor];
    self.contactPhone.enabled=NO;
    self.contactPhone.textColor=[UIColor lightGrayColor];
    self.otherText.enabled=NO;
    self.otherText.textColor=[UIColor lightGrayColor];
}
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==editContactInfoConnection) {
        return [editContactInfoData appendData:data];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD dismissWithError:@"获取失败"];
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

    editContactInfoConnection =nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if (connection==editContactInfoConnection) {
        NSString *getlist = [[NSString alloc] initWithData:editContactInfoData encoding:NSUTF8StringEncoding];

        NSDictionary *rootDic = [parser objectWithString:getlist error:&error];
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        
        if ([loginStatus isEqualToString:@"ok"]) {
            [SVProgressHUD dismissWithSuccess:@"修改成功！" afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showErrorWithStatus:response duration:0.5];
        }
        [getlist release];
    }
    [parser release];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIButton *editContactInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[editContactInfoBtn setImage:[UIImage imageNamed:@"title_button_common.png"] forState:UIControlStateNormal];
	[editContactInfoBtn addTarget:self action:@selector(editContactInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    editContactInfoLable=[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 50.0, 30.0)];
    editContactInfoLable.backgroundColor=[UIColor clearColor];
    UIView *editView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    editView.backgroundColor=[UIColor clearColor];
    editContactInfoLable.textColor=[UIColor whiteColor];
    [editContactInfoLable setFont:[UIFont systemFontOfSize:15]];
    editContactInfoLable.text=@"编辑";
    [editView addSubview:editContactInfoBtn];
    [editContactInfoBtn addSubview:editContactInfoLable];
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc] initWithCustomView:editView];
    self.navigationItem.rightBarButtonItem=editItem;
    [backBtn release];
    [btntitle release];
    [backview release];
    [addContact release];
    [editItem release];
    [editView release];
    [editContactInfoBtn release];
}
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self moveView:textField leaveView:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contactAddress resignFirstResponder];
    [self.contactName resignFirstResponder];
    [self.contactPhone resignFirstResponder];
    [self.otherText resignFirstResponder];
    return YES;
}
-(IBAction)keyBorderHideAction:(id)sender
{
    [self.contactAddress resignFirstResponder];
    [self.contactName resignFirstResponder];
    [self.contactPhone resignFirstResponder];
    [self.otherText resignFirstResponder];
}

@end
