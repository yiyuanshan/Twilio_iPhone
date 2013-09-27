//
//  TCallConnectingViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-13.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TCallConnectingViewController.h"

@interface TCallConnectingViewController ()

@end

@implementation TCallConnectingViewController
@synthesize addToRecordData,addToRecordUrl;
@synthesize startTimes;
@synthesize moblieNumber;
@synthesize Millisecond;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TCallConnectingViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
    [addToRecordUrl release];
    [addToRecordData release];
    [startTimes release];
    [moblieNumber release];
    [Millisecond release];
}
-(void)initAddRecordToServer:(NSString *)startTime Duration:(NSString *)durationTime PhoneNumber:(NSString *)number
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (addToRecordData!=nil) {
        [addToRecordData release];
    }
    if (addToRecordUrl!=nil) {
        [addToRecordUrl release];
    }
    NSString *urlStr=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/AddRecord?userId=%d&deviceId=%d&startTime=%@&duration=%@&phoneNumber=%@",beanstatus.userId,[DeviceUDID initDeviceID],startTime,durationTime,number ];
//    NSLog(@"url==%@",requestUrl);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    addToRecordUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    addToRecordData=[[NSMutableData alloc] init];
    [array release];
}
-(NSString *)getTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
    NSString *datetime = [formatter stringFromDate:[NSDate date]];
    NSString *now_time = [NSString stringWithFormat:@"%@",datetime];
    [formatter release];
    return now_time;
}
-(float)durationTimes:(NSString *)time
{
    NSString *str1 = [time stringByReplacingOccurrencesOfString :@" " withString:@"-"];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString :@":" withString:@"-"];
    NSString *timeString = [str2 stringByReplacingOccurrencesOfString :@"." withString:@"-"];
    NSArray*timeArray=[timeString componentsSeparatedByString:@"-"];
    //    float years = [[timeArray objectAtIndex:0] floatValue];
    //    float month = [[timeArray objectAtIndex:1] floatValue];
    //    float days = [[timeArray objectAtIndex:2] floatValue];
    float hours= [[timeArray objectAtIndex:3] floatValue];
    float minutes = [[timeArray objectAtIndex:4] floatValue];
    float seconds = [[timeArray objectAtIndex:5] floatValue];
    float millisecond = [[timeArray objectAtIndex:6] floatValue];
    float allTimeToSecond=hours*3600000+minutes*6000+seconds*1000+millisecond;
    return allTimeToSecond;
}
-(void)conection
{
    NSInteger  duration=[self durationTimes:[self getTime]]-[self durationTimes:self.Millisecond];
    NSString *allDurationTime=[NSString stringWithFormat:@"%d",duration];
    [self initAddRecordToServer:self.startTimes Duration:allDurationTime PhoneNumber:self.moblieNumber];
}
-(IBAction)hangupButtonPressed:(id)sender
{
   
    TwilioAppDelegate* appDelegate = (TwilioAppDelegate *)[UIApplication sharedApplication].delegate;
    MonkeyPhone* phone = appDelegate.phone;

    [phone disconnect];
    [self conection];
    [self dismisViewController];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _animationCall.backgroundColor = [UIColor clearColor];
    _animationCall.opaque = NO;
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"animation_call" ofType:@"gif"]];
    [_animationCall loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    // Do any additional setup after loading the view from its nib.
}
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==addToRecordUrl) {
        return [addToRecordData appendData:data];
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
    
    addToRecordUrl=nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
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
-(void)dismisViewController
{
    [self dismissViewControllerAnimated:YES completion:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
//[[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpFrom" object:nil];
}
@end
