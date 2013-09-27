//
//  TMoreViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TMoreViewController.h"

@interface TMoreViewController ()

@end

@implementation TMoreViewController
@synthesize moreTableView;
@synthesize dataArray;
@synthesize logoutData,logoutUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TMoreViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"更多", @"更多");
    }
    return self;
}
-(void)dealloc
{
    [moreTableView release];
    [dataArray release];
    [logoutData release];
    [logoutUrl release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moreTableView.scrollEnabled=NO;
    dataArray=[[NSMutableArray alloc] initWithObjects:@"修改号码",@"联系管理员",@"登出", nil];
    [self setExtraCellLineHidden:self.moreTableView];
}
-(void)initLogoutConnection
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (logoutUrl!=nil) {
        [logoutUrl release];
    }
    if (logoutData!=nil) {
        [logoutData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/Logout?userId=%d&deviceId=%d",beanstatus.userId,[DeviceUDID initDeviceID]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    logoutUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    logoutData=[[NSMutableData alloc] init];
    [array release];
}
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==logoutUrl) {
        return [logoutData appendData:data];
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
    
    logoutUrl = nil;
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

#pragma  mark UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier ]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.section];
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
//除去空白行
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        TChangeNumberViewController *changeNumber=[[TChangeNumberViewController alloc] init];
        [self.navigationController pushViewController:changeNumber animated:YES];
        [changeNumber release];
    }else if(indexPath.section==1){
        TContactAdminViewController *contactAdmin=[[TContactAdminViewController alloc] init];
        [self.navigationController pushViewController:contactAdmin animated:YES];
        [contactAdmin release];
    }else if (indexPath.section==2) {
        [self messageTitles:@"提示！" Message:@"确定退出吗？"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[HelpDataBase instance] updateCheckAutoLoginTotable];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOut" object:nil];
                [self initLogoutConnection];
            });
            dispatch_async(dispatch_get_current_queue(), ^{
                int64_t delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.tabBarController setSelectedIndex:0];
                });
            });
        });
    }
}

- (void)messageTitles:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
