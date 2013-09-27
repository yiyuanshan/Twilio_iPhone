//
//  TRecordViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TRecordViewController.h"


@interface TRecordViewController ()

@end

@implementation TRecordViewController
@synthesize recoreTableView;
@synthesize getRecordData;
@synthesize getRecordListUrl;
@synthesize deleateRecordData;
@synthesize deleateRecordUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TRecordViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"联系记录", @"联系记录");
    }
    return self;
}
-(void)dealloc
{
    [getRecordData release];
    [getRecordListUrl release];
    [deleateRecordData release];
    [deleateRecordUrl release];
    [super dealloc];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self setExtraCellLineHidden:self.recoreTableView];
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 50.0, 30.0)];
	[deleteBtn setImage:[UIImage imageNamed:@"title_button_remove.png"] forState:UIControlStateNormal];
	[deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem=addContact;
    [deleteBtn release];
    [addContact release];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.noContact.hidden=YES;
    self.recoreTableView.hidden=YES;
    [self initGetRecordListConnection];
    self.recoreTableView.userInteractionEnabled=NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}
-(void)initGetRecordListConnection
{
    [SVProgressHUD showWithStatus:@"获取联系记录..." maskType:SVProgressHUDMaskTypeNone];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (getRecordData!=nil) {
        [getRecordData release];
    }
    if (getRecordListUrl!=nil) {
        [getRecordListUrl release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/RecordList?userId=%d&deviceId=%d",beanstatus.userId,[DeviceUDID initDeviceID]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    getRecordListUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    getRecordData=[[NSMutableData alloc] init];
    [array release];
}
-(void)initDeleateRecordToServer:(NSString *)recordID
{
    [SVProgressHUD showWithStatus:@"删除联系记录..." maskType:SVProgressHUDMaskTypeNone];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (deleateRecordUrl!=nil) {
        [deleateRecordUrl release];
    }
    if (deleateRecordData!=nil) {
        [deleateRecordData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/DeleteRecord?userId=%d&deviceId=%d&recordId=%@",beanstatus.userId,[DeviceUDID initDeviceID],recordID];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    deleateRecordUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    deleateRecordData=[[NSMutableData alloc] init];
    [array release];

}
-(void)jsonParseTest:(NSString *)jsonString
{
    NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
    NSString *stateInfo = [rootDic objectForKey:@"state"];
    if ([stateInfo isEqualToString:@"ok"]) {
        NSString *responseInfo = [rootDic objectForKey:@"response"];
        NSString *str = [responseInfo stringByReplacingOccurrencesOfString :@"'" withString:@"\""];
        if ([responseInfo isEqualToString:@""]) {
            self.recoreTableView.hidden=YES;
            self.noContact.hidden=NO;
        }else
        {
            self.recoreTableView.hidden=NO;
            self.noContact.hidden=YES;
            self.listData = [str JSONValue];
        }
    }
//    NSLog(@"listdata===%@",self.listData);
    [self.recoreTableView reloadData];
    [parser release];
}

- (IBAction)deleteAction:(id)sender
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示！" message:@"确定删除所有的通话记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else if(buttonIndex==1)
    {
        NSLog(@"确定");
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *TableSampleIdentifier=@"TableSampleIdentifier";
    RecordCell *cell=(RecordCell *)[tableView
                                    dequeueReusableCellWithIdentifier: TableSampleIdentifier];
    
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[RecordCell class]])
                cell = (RecordCell *)oneObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary*  dict = self.listData[indexPath.section];
    NSString *name=[dict objectForKey:@"name"];
    if ([name isEqualToString:@""]) {
        cell.name.text =@"未知";
    }else{
        cell.name.text =name;
    }
    cell.phoneNumber.text =[dict objectForKey:@"number"];
    cell.callTime.text=[self getMillisecond:[dict objectForKey:@"duration"]];
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary*  dict = self.listData[indexPath.section];
        NSString *recordID=[dict objectForKey:@"id"];

        [self initDeleateRecordToServer:recordID];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSDictionary*  dict = [self.listData objectAtIndex:section];;
    NSString *head=[dict objectForKey:@"startTime"];
    return head;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*  dict = self.listData[indexPath.section];
    TwilioAppDelegate* appDelegate = (TwilioAppDelegate*)[UIApplication sharedApplication].delegate;
    MonkeyPhone* phone = appDelegate.phone;
    [phone connect:[dict objectForKey:@"number"]];
    NSString *str = [[dict objectForKey:@"number"] stringByReplacingOccurrencesOfString :@"-" withString:@""];
    NSString *number = [str stringByReplacingOccurrencesOfString :@"+86" withString:@""];
    TCallConnectingViewController *callView=[[TCallConnectingViewController alloc] init];
    NSString *times = [[self getTime] stringByReplacingOccurrencesOfString :@" " withString:@"+"];
    callView.startTimes=times;
    callView.moblieNumber=number;
    callView.Millisecond=[self getMillisecond];
    [self presentViewController:callView animated:YES completion:nil];
    [callView release];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
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
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==getRecordListUrl) {
        return [getRecordData appendData:data];
    }
    if (connection==deleateRecordUrl) {
        return [deleateRecordData appendData:data];
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
    self.recoreTableView.userInteractionEnabled=YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    getRecordListUrl = nil;
    deleateRecordUrl =nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if (connection==deleateRecordUrl) {
        NSString *getlist = [[NSString alloc] initWithData:deleateRecordData encoding:NSUTF8StringEncoding];
        NSDictionary *rootDic = [parser objectWithString:getlist error:&error];
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        
        if ([loginStatus isEqualToString:@"ok"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:1.0];
            [self initGetRecordListConnection];
        }else {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:1.0];
        }
        [getlist release];
    }
    if (connection==getRecordListUrl) {
        NSString *getlist = [[NSString alloc] initWithData:getRecordData encoding:NSUTF8StringEncoding];
        [self jsonParseTest:getlist];
        [SVProgressHUD dismiss];
        [getlist release];
    }
    [parser release];
    self.recoreTableView.userInteractionEnabled=YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
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
-(NSString *)getMillisecond:(NSString *)data
{
    NSString *getTimes;
    int allTime=[data intValue];
    int hours=allTime/3600000;
    int minutes=allTime%3600000/60000;
    int seconds=allTime%3600000%60000/1000;
    //    float millisecond=allTime%3600000%60000%1000;
    if (hours==0) {
        if (minutes==0) {
            if (seconds<10) {
                getTimes=[NSString stringWithFormat:@"0%d:0%d",minutes,seconds];
            }else
            {
                getTimes=[NSString stringWithFormat:@"0%d:%d",minutes,seconds];
            }
        }else
        {
            if (minutes>=10) {
                if (seconds<10) {
                    getTimes=[NSString stringWithFormat:@"%d:0%d",minutes,seconds];
                }else
                {
                    getTimes=[NSString stringWithFormat:@"%d:%d",minutes,seconds];
                }
            }else
            {
                if (seconds<10) {
                    getTimes=[NSString stringWithFormat:@"%d:0%d",minutes,seconds];
                }else
                {
                    getTimes=[NSString stringWithFormat:@"0%d:%d",minutes,seconds];
                }
            }
        }
    }else
    {
        if (hours>=10) {
            if (minutes==0) {
                if (seconds<10) {
                    getTimes=[NSString stringWithFormat:@"%d:0%d:0%d",hours,minutes,seconds];
                }else
                {
                    getTimes=[NSString stringWithFormat:@"%d:0%d:%d",hours,minutes,seconds];
                }
            }else
            {
                if (minutes>=10) {
                    if (seconds<10) {
                        getTimes=[NSString stringWithFormat:@"%d:%d:0%d",hours,minutes,seconds];
                    }else
                    {
                        getTimes=[NSString stringWithFormat:@"%d:%d:%d",hours,minutes,seconds];
                    }
                }else
                {
                    if (seconds<10) {
                        getTimes=[NSString stringWithFormat:@"%d:%d:0%d",hours,minutes,seconds];
                    }else
                    {
                        getTimes=[NSString stringWithFormat:@"%d:0%d:%d",hours,minutes,seconds];
                    }
                }
            }
            
        }else
        {
            if (minutes==0) {
                if (seconds<10) {
                    getTimes=[NSString stringWithFormat:@"0%d:0%d:0%d",hours,minutes,seconds];
                }else
                {
                    getTimes=[NSString stringWithFormat:@"0%d:0%d:%d",hours,minutes,seconds];
                }
            }else
            {
                if (minutes>=10) {
                    if (seconds<10) {
                        getTimes=[NSString stringWithFormat:@"0%d:%d:0%d",hours,minutes,seconds];
                    }else
                    {
                        getTimes=[NSString stringWithFormat:@"0%d:%d:%d",hours,minutes,seconds];
                    }
                }else
                {
                    if (seconds<10) {
                        getTimes=[NSString stringWithFormat:@"0%d:%d:0%d",hours,minutes,seconds];
                    }else
                    {
                        getTimes=[NSString stringWithFormat:@"0%d:0%d:%d",hours,minutes,seconds];
                    }
                }
            }
            
        }
        
    }
    return getTimes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
