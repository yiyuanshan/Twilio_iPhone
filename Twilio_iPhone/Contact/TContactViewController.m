//
//  TContactViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TContactViewController.h"


@interface TContactViewController ()

@end

@implementation TContactViewController
@synthesize contactNameTableView;
@synthesize nameSearchBar;
@synthesize noContact;
@synthesize contactListData,contactListUrl;
@synthesize addContactData,addContactUrl;
@synthesize searchContactData,searchContactUrl;
@synthesize deleateContactData,deleateContactUrl;
@synthesize headArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TContactViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"联系人", @"联系人");
        sectionDic= [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [contactNameTableView release];
    [noContact release];
    [nameSearchBar release];
    [searchContactData release];
    [searchContactUrl release];
    [contactListData release];
    [contactListUrl release];
    [addContactUrl release];
    [addContactData release];
    [deleateContactData release];
    [deleateContactUrl release];
    [headArray release];
    [sectionDic            release];
    [super dealloc];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tabBarController.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self initNavigationItem];
     [sectionDic removeAllObjects];
    for (int i = 0; i < 26; i++) [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    
}
-(void)pinyinpaixu:(NSString *)personname RecordName:(id)record
{
    char first=pinyinFirstLetter([personname characterAtIndex:0]);
    NSString *sectionName;
    if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
        if([self searchResult:personname searchText:@"曾"])
            sectionName = @"Z";
        else if([self searchResult:personname searchText:@"解"])
            sectionName = @"X";
        else if([self searchResult:personname searchText:@"仇"])
            sectionName = @"Q";
        else if([self searchResult:personname searchText:@"朴"])
            sectionName = @"P";
        else if([self searchResult:personname searchText:@"查"])
            sectionName = @"Z";
        else if([self searchResult:personname searchText:@"能"])
            sectionName = @"N";
        else if([self searchResult:personname searchText:@"乐"])
            sectionName = @"Y";
        else if([self searchResult:personname searchText:@"单"])
            sectionName = @"S";
        else
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
    }
    else {
        sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
    }
    
    [[sectionDic objectForKey:sectionName] addObject:record];
}
-(BOOL)searchResult:(NSString *)contactname searchText:(NSString *)searchT{
	NSComparisonResult result = [contactname compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    searchStatus=NO;
    self.noContact.hidden=YES;
    self.contactNameTableView.hidden=YES;
    [self initGetContactListConnection];
    [self setExtraCellLineHidden:self.contactNameTableView];
}
-(void)jsonParseTest:(NSString *)jsonString
{
    NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
    NSString *stateInfo = [rootDic objectForKey:@"state"];
    if ([stateInfo isEqualToString:@"ok"]) {
        NSString *responseInfo = [rootDic objectForKey:@"response"];
        if ([responseInfo isEqualToString:@""]) {
            if (searchStatus) {
            }else
            {
            self.contactNameTableView.hidden=YES;
            self.noContact.hidden=NO;
            }
        }else
        {
            self.contactNameTableView.hidden=NO;
            self.noContact.hidden=YES;
        self.listData = [responseInfo JSONValue];
        NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [self.listData sortUsingDescriptors:[NSArray arrayWithObject:sortByA]];
         }
    }
    NSMutableArray *presonArray=[[NSMutableArray alloc] init ];
    for (int i=0;i<[self.listData count];i++) {
//        NSLog(@"%@",self.listData);
        NSDictionary*  dict = [self.listData objectAtIndex:i];
        NSString *name=[dict objectForKey:@"name"];
        [presonArray addObject:name];
    }
    for (int i=0;i<[presonArray count];i++) {
        NSString *preson=[presonArray objectAtIndex:i];
        RecordRef record= [presonArray objectAtIndexedSubscript:i] ;
        [self pinyinpaixu:preson RecordName:record];
    }
    [self.contactNameTableView reloadData];
    [parser release];
    [presonArray release];
}

-(void)showAddView
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 250.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    TAddContactView *addview = [[TAddContactView alloc] initWithFrame:CGRectMake(0, yOffset, xWidth, yHeight)];
    addview.delegate = self;
    addview.backgroundColor=[UIColor lightGrayColor];
    [addview setTitle:@"添加联系人"];
    [addview show];
    [addview release];
}
-(void)addContactButtonIndex:(NSInteger)index
{
    if (index==0) {
        
    }else if(index==1)
    {
        [self addContactConnection];
        [self initGetContactListConnection ];
    }
}
-(void)addContactTextFieldTextName:(NSString *)name PhoneNumber:(NSString *)number
{
    contactName=name;
    contactPhoneNumber=number;
}
-(void)addContactConnection
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (addContactData!=nil) {
        [addContactData release];
    }
    if (addContactUrl!=nil) {
        [addContactUrl release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/AddContact?userId=%d&deviceId=%d&contactName=%@&contactNumber=%@",beanstatus.userId,[DeviceUDID initDeviceID],contactName,contactPhoneNumber];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    addContactUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    addContactData=[[NSMutableData alloc] init];
    [array release];
}

-(void)initGetContactListConnection
{
    headArray=[[NSMutableArray alloc] initWithObjects:@" ", nil];
    [SVProgressHUD showWithStatus:@"获取联系人..." maskType:SVProgressHUDMaskTypeNone];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    if (contactListUrl!=nil) {
        [contactListUrl release];
    }
    if (contactListData!=nil) {
        [contactListData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/ContactList?userId=%d&deviceId=%d",beanstatus.userId,[DeviceUDID initDeviceID]];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    contactListUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    contactListData=[[NSMutableData alloc] init];
    [array release];
}

-(void)initGetContactInfoConnection:(NSString *)userName
{
    [SVProgressHUD showWithStatus:@"搜索联系人..." maskType:SVProgressHUDMaskTypeNone];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    
    if (searchContactUrl!=nil) {
        [searchContactUrl release];
    }
    if (searchContactData!=nil) {
        [searchContactData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/ContactList?userId=%d&deviceId=%d&sSearch=%@",beanstatus.userId,[DeviceUDID initDeviceID],userName];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    searchContactUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    searchContactData=[[NSMutableData alloc] init];
    [array release];
}
-(void)initDeleateContactInfoConnection:(NSString *)userId
{
    [SVProgressHUD showWithStatus:@"删除联系人..." maskType:SVProgressHUDMaskTypeNone];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [[HelpDataBase instance] queryTotable:array];
    TLoginStatusBean *beanstatus=[array objectAtIndex:0];
    
    if (deleateContactUrl!=nil) {
        [deleateContactUrl release];
    }
    if (deleateContactData!=nil) {
        [deleateContactData release];
    }
    NSString *requestUrl=[NSString stringWithFormat:@"http://122.193.29.102:82/loginfilter/DeleteContact?userId=%d&deviceId=%d&contactId=%@",beanstatus.userId,[DeviceUDID initDeviceID],userId];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    deleateContactUrl=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    deleateContactData=[[NSMutableData alloc] init];
    [array release];
}
#pragma make NSURLCONNECTION
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection==contactListUrl) {
        return [contactListData appendData:data];
    }
    if (connection==addContactUrl) {
        return [addContactData appendData:data];
    }
    if (connection==searchContactUrl) {
        return [searchContactData appendData:data];
    }
    if (connection==deleateContactUrl) {
        return [deleateContactData appendData:data];
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
    self.tabBarController.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    contactListUrl = nil;
    addContactUrl=nil;
    deleateContactUrl=nil;
    searchContactUrl=nil;
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if (connection==addContactUrl) {
        NSString *getlist = [[NSString alloc] initWithData:addContactData encoding:NSUTF8StringEncoding];
        NSDictionary *rootDic = [parser objectWithString:getlist error:&error];
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        
        if ([loginStatus isEqualToString:@"ok"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:1.0];
            [self initGetContactListConnection];
        }else if([loginStatus isEqualToString:@"sessionerr"])
        {
            [SVProgressHUD showSuccessWithStatus:@"请重新登录" duration:1.0];
        }else if([loginStatus isEqualToString:@"err"])
        {
            [SVProgressHUD showSuccessWithStatus:@"用户名不能为空" duration:1.0];
        }
        [getlist release];
    }
    if (connection==contactListUrl) {
        NSString *getlist = [[NSString alloc] initWithData:contactListData encoding:NSUTF8StringEncoding];
        [SVProgressHUD dismiss];
        [self jsonParseTest:getlist];
        
        [getlist release];
    }
    if (connection==searchContactUrl) {
        NSString *getlist = [[NSString alloc] initWithData:searchContactData encoding:NSUTF8StringEncoding];
        
        [self jsonParseTest:getlist];
        [SVProgressHUD dismiss];
        [getlist release];
    }
    if (connection==deleateContactUrl) {
        [self.listData removeAllObjects];
        NSString *getlist = [[NSString alloc] initWithData:deleateContactData encoding:NSUTF8StringEncoding];
        
        NSDictionary *rootDic = [parser objectWithString:getlist error:&error];
        NSString *loginStatus = [rootDic objectForKey:@"state"];
        
        if ([loginStatus isEqualToString:@"ok"]) {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:1.0];
            [self initGetContactListConnection];
        }else {
            NSString *response = [rootDic objectForKey:@"response"];
            [SVProgressHUD showSuccessWithStatus:response duration:1.0];
        }
        [getlist release];
    }
    
    [parser release];
    self.tabBarController.view.userInteractionEnabled = YES;
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

#pragma  mark UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
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
    }
    NSDictionary*  dict = self.listData[indexPath.section];
    NSString *name=[dict objectForKey:@"name"];
    NSString *contactNumber=[dict objectForKey:@"number"];
    if ([name isEqualToString:@""]) {
        cell.textLabel.text = [ NSString stringWithFormat:@"   %@",contactNumber];
    }else{
        cell.textLabel.text = [ NSString stringWithFormat:@"   %@",name];
    }
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
//    NSDictionary * dict = [self.listData objectAtIndex:section];
//    NSString *name=[dict objectForKey:@"name"];
//    NSString *head = [[name capitalizedString] substringToIndex:1];
////    NSLog(@"head===%@",head);
//    if ([head isEqualToString:[headArray objectAtIndex:0]]) {
//        return nil;
//    }
//    [headArray insertObject:head atIndex:0];
//    return head;
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary*  dict = self.listData[indexPath.section];
        NSString *userID=[dict objectForKey:@"id"];
        [self initDeleateContactInfoConnection:userID];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*  dict = self.listData[indexPath.section];
    TContactInFoController *infoView=[[TContactInFoController alloc] init];
    infoView.Name=[dict objectForKey:@"name"];
    infoView.Phone=[dict objectForKey:@"number"];
    infoView.contactId=[dict objectForKey:@"id"];
    [self.navigationController pushViewController:infoView animated:YES];
    [infoView release];
}
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self initGetContactInfoConnection:searchBar.text];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    searchStatus=YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self initGetContactListConnection];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNavigationItem
{
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[addBtn setImage:[UIImage imageNamed:@"title_button_common.png"] forState:UIControlStateNormal];
	[addBtn addTarget:self action:@selector(showAddView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addTitle=[[UILabel alloc] initWithFrame:CGRectMake(9.0, 0.0, 50.0, 30.0)];
    addTitle.backgroundColor=[UIColor clearColor];
    
    UIView *addView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    addView.backgroundColor=[UIColor clearColor];
    addTitle.textColor=[UIColor whiteColor];
    [addTitle setFont:[UIFont systemFontOfSize:15]];
    addTitle.text=@"添加";
    [addView addSubview:addBtn];
    [addBtn addSubview:addTitle];
    
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:addView];
    self.navigationItem.rightBarButtonItem=addContact;
    self.contactNameTableView.tableHeaderView=self.nameSearchBar;
    [addBtn release];
    [addTitle release];
    [addView release];
    [addContact release];
}

@end
