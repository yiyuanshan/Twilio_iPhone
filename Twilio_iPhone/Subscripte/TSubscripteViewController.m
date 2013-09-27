//
//  TSubscripteViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TSubscripteViewController.h"

@interface TSubscripteViewController ()

@end

@implementation TSubscripteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TSubscripteViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"购买", @"购买");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buyHistoryTableView.tableHeaderView=self.headLable;
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[deleteBtn setImage:[UIImage imageNamed:@"title_button_remove.png"] forState:UIControlStateNormal];
	[deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.leftBarButtonItem=addContact;
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 30.0, 30.0)];
	[buyBtn setImage:[UIImage imageNamed:@"icon_add_contact.png"] forState:UIControlStateNormal];
	[buyBtn addTarget:self action:@selector(productAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buyItem=[[UIBarButtonItem alloc] initWithCustomView:buyBtn];
    self.navigationItem.rightBarButtonItem=buyItem;
    [self setExtraCellLineHidden:self.buyHistoryTableView];
}
-(IBAction)productAction:(id)sender
{
    TProductViewController *productView=[[TProductViewController alloc] init];
    [self.navigationController pushViewController:productView animated:YES];
}
- (IBAction)deleteAction:(id)sender
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示！" message:@"确定删除所有的购买记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else if(buttonIndex==1)
    {
        NSLog(@"确定");
    }
}
//除去空白行
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *TableSampleIdentifier=@"TableSampleIdentifier";
    HistoryCell *cell=(HistoryCell *)[tableView
                                    dequeueReusableCellWithIdentifier: TableSampleIdentifier];
    
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[HistoryCell class]])
                cell = (HistoryCell *)oneObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        databasebean= [listdata objectAtIndex:indexPath.row];
        //        //delete data from sqlite
        //        [helpdatabase deleteTotable:databasebean];
        //        //delete data from array
        //        [listdata removeObjectAtIndex:indexPath.row];
        //delete data from tableview
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
