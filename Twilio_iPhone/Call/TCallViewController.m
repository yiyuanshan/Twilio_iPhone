//
//  TCallViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TCallViewController.h"
#import "UIColor+Codeconvert.h"
#import "TCallConnectingViewController.h"


@interface TCallViewController ()

@end

@implementation TCallViewController
@synthesize audioPlayer;
@synthesize paramPhone;
@synthesize phoneNumber;
@synthesize okBtn,cancelBtn;
//@synthesize phoneNumberLbl;
//@synthesize zeroBtn;
@synthesize addContactData,addContactUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"拨号", @"拨号");
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
    [addContactData release];
    [addContactUrl release];
    [okBtn release];
    [cancelBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self appendString];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0)];
    [addBtn setBackgroundImage:[[UIImage imageNamed:@"title_button_common.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateNormal];
	[addBtn addTarget:self action:@selector(addContactAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *addTitle=[[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0, 100.0, 30.0)];
    addTitle.backgroundColor=[UIColor clearColor];
    UIView *addView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0)];
    addView.backgroundColor=[UIColor clearColor];
    addTitle.textColor=[UIColor whiteColor];
    [addTitle setFont:[UIFont systemFontOfSize:15]];
    addTitle.text=NSLocalizedString(@"添加到联系人", @"");
    [addView addSubview:addBtn];
    [addBtn addSubview:addTitle];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:addView];
    self.navigationItem.rightBarButtonItem=addContact;
    [addBtn release];
    [addTitle release];
    [addView release];
    [addContact release];
}
-(void)addContactConnection:(NSString *)contactName
{
    if ([NSString_StringEmpty isEmptyOrNull:self.phoneNumberLbl.text]) {
        [self messageTitle:@"提示！" Message:@"电话号码不能为空"];
    }else
    {
        if ([NSString_StringEmpty isEmptyOrNull:contactName]) {
            [self messageTitle:@"提示！" Message:@"联系人姓名不能为空"];
        }else{
            [SVProgressHUD showWithStatus:@"添加联系人"];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            [[HelpDataBase instance] queryTotable:array];
            TLoginStatusBean *beanstatus=[array objectAtIndex:0];
            if (addContactData!=nil) {
                [addContactData release];
            }
            if (addContactUrl!=nil) {
                [addContactUrl release];
            }
            NSString *str = [self.phoneNumberLbl.text stringByReplacingOccurrencesOfString :@"-" withString:@""];
            NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/AddContact?userId=%d&deviceId=%d&contactName=%@&contactNumber=%@",beanstatus.userId,[DeviceUDID initDeviceID],contactName,str];
            requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
            addContactUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            addContactData=[[NSMutableData alloc] init];
            [array release];
        }
    }
}
- (IBAction)addContactAction:(id)sender
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"添加联系人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
    [alertView release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
    }else if(buttonIndex==1){
    UITextField *textField=[alertView textFieldAtIndex:0];
        [self addContactConnection:textField.text];
    }
}
- (void) appendString
{
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(switchCharater:)];
    [self.zeroBtn addGestureRecognizer:gr];
    self.view.autoresizesSubviews = YES;
	
	self.callBtn.enabled = YES;
	if(paramPhone != nil)
	{
        self.phoneNumber = paramPhone;
	}
    
    if (self.phoneNumber == nil) {
        self.phoneNumber = @"";
    }
    if ([self.phoneNumber length] < 3) {
        self.phoneNumberLbl.text = self.phoneNumber;
    }
    
    if ([self.phoneNumber length]>=3 && [self.phoneNumber length] < 6) {
        NSRange range1 = NSMakeRange(0, 3);
        self.phoneNumberLbl.text = [NSString stringWithFormat:@"%@ %@", [phoneNumber substringWithRange:range1], [phoneNumber substringFromIndex:3]] ;
        
    }
    
    if ([self.phoneNumber length] >=6) {
        NSRange range1 = NSMakeRange(0, 3);
        NSRange range2 = NSMakeRange(3, 3);
        self.phoneNumberLbl.text = [NSString stringWithFormat:@"%@ %@ %@", [phoneNumber substringWithRange:range1], [phoneNumber substringWithRange:range2], [phoneNumber substringFromIndex:6]] ;
    }
    [gr release];
}
- (void) switchCharater:(UILongPressGestureRecognizer *) gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"wav"];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        
        [self playSoundEffect:soundUrl];
        
        if ([self.phoneNumberLbl.text length] == 3 || [self.phoneNumberLbl.text length] == 7) {
            self.phoneNumberLbl.text = [self.phoneNumberLbl.text stringByAppendingString:@"-"];
        }
        self.phoneNumberLbl.text = [self.phoneNumberLbl.text stringByAppendingFormat:@"+"];
        self.phoneNumber = [self.phoneNumber stringByAppendingString:@"+"];
    }
}
- (void) playSoundEffect:(NSURL *) soundUrl
{
    if (soundUrl != nil) {
        NSError *error;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error ];
        self.audioPlayer = player;
        if (self.audioPlayer == nil) {
            NSLog(@"%@",[error description]);
        }else {
            [self.audioPlayer play];
        }
        [player release];
    }
}
- (IBAction)backAction:(id)sender {
    if (self.phoneNumberLbl.text.length >0) {
        if (!(self.phoneNumberLbl.text.length == 4 || self.phoneNumberLbl.text.length == 8)) {
            self.phoneNumber = [self.phoneNumber substringToIndex:self.phoneNumber.length - 1];
        }
        self.phoneNumberLbl.text = [self.phoneNumberLbl.text substringToIndex:self.phoneNumberLbl.text.length-1];
    }
}
- (IBAction)clickNumberBtn:(id)sender {
    NSInteger digit = ((UIButton *)sender).tag;
    NSString *soundName = @"";
    if (digit != 10 && digit != 11) {
        soundName = [NSString stringWithFormat:@"%i", digit];
    }else if(digit == 10){
        soundName = @"*";
    }else if(digit == 11){
        soundName = @"#";
    }
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    [self playSoundEffect:soundUrl];
    if ([self.phoneNumberLbl.text length] == 3 || [self.phoneNumberLbl.text length] == 7) {
        self.phoneNumberLbl.text = [self.phoneNumberLbl.text stringByAppendingString:@"-"];
    }
    self.phoneNumberLbl.text = [self.phoneNumberLbl.text stringByAppendingString:soundName];
    self.phoneNumber = [self.phoneNumber stringByAppendingString:soundName];
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
- (IBAction)callAction:(id)sender {
    
    if ([NSString_StringEmpty isEmptyOrNull:self.phoneNumberLbl.text]) {
        [self messageTitle:@"提示！" Message:@"电话号码不能为空"];
    }else
    {
        TwilioAppDelegate* appDelegate = (TwilioAppDelegate*)[UIApplication sharedApplication].delegate;
        MonkeyPhone* phone = appDelegate.phone;
        [phone connect:self.phoneNumberLbl.text];
        NSString *str = [self.phoneNumberLbl.text stringByReplacingOccurrencesOfString :@"-" withString:@""];
        NSString *number = [str stringByReplacingOccurrencesOfString :@"+86" withString:@""];
        TCallConnectingViewController *callView=[[TCallConnectingViewController alloc] init];
        NSString *times = [[self getTime] stringByReplacingOccurrencesOfString :@" " withString:@"+"];
        callView.startTimes=times;
        callView.moblieNumber=number;
        callView.Millisecond=[self getMillisecond];
        [self presentViewController:callView animated:YES completion:nil];
        [callView release];
    }
    
}
-(void)jumpToCallView
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
//[[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpTo" object:nil];
}
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==addContactUrl) {
        return [addContactData appendData:data];
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
    
    addContactUrl = nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if (connection==addContactUrl) {
        NSString *getlist = [[NSString alloc] initWithData:addContactData encoding:NSUTF8StringEncoding];
//        NSLog(@"getlist===%@",getlist);
        NSDictionary *rootDic = [parser objectWithString:getlist error:&error];
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        if ([loginStatus isEqualToString:@"ok"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:0.5];
//            NSLog(@"getlist===%@",getlist);
        }else if([loginStatus isEqualToString:@"sessionerr"])
        {
            [SVProgressHUD showSuccessWithStatus:@"请重新登录" duration:0.5];
        }else if([loginStatus isEqualToString:@"err"])
        {
            [SVProgressHUD showSuccessWithStatus:@"用户名不能为空" duration:0.5];
        }
        [getlist release];
    }
//    [SVProgressHUD dismiss];
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

@end
