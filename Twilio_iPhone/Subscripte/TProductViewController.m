//
//  TProductViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TProductViewController.h"


@interface TProductViewController ()

@end

@implementation TProductViewController
@synthesize productTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TProductViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title=@"产品";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.productTableView.scrollEnabled=NO;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    [backBtn setTitle:@"购买" forState:UIControlStateNormal];
	[backBtn setImage:[UIImage imageNamed:@"title_button_back.png"] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *btntitle=[[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, 50.0, 30.0)];
    btntitle.backgroundColor=[UIColor clearColor];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
    view.backgroundColor=[UIColor clearColor];
    btntitle.textColor=[UIColor whiteColor];
    [btntitle setFont:[UIFont systemFontOfSize:15]];
    btntitle.text=@"购买";
    
    [view addSubview:backBtn];
    [backBtn addSubview:btntitle];
    UIBarButtonItem *addContact=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem=addContact;
}

#pragma mark UITablViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *TableSampleIdentifier=@"TableSampleIdentifier";
    ProductCell *cell=(ProductCell *)[tableView
                                      dequeueReusableCellWithIdentifier: TableSampleIdentifier];
    
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[ProductCell class]])
                cell = (ProductCell *)oneObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==0) {
        cell.productInfo.text=@"($0.09/分钟)";
        cell.productName.text=@"按分钟";
    }
    if (indexPath.row==1) {
        cell.productInfo.text=@"($1.99/小时)";
        cell.productName.text=@"按小时";
    }
    if (indexPath.row==2) {
        cell.productInfo.text=@"($10.99/天)";
        cell.productName.text=@"按天";
    }
    if (indexPath.row==3) {
        cell.productInfo.text=@"($60.99/月)";
        cell.productName.text=@"按月";
    }
    
    return cell;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *produceName=nil;
    NSString *productPrices=nil;
    if (indexPath.row==0) {
        produceName=@"分钟";
        productPrices=@"0.09";
    }
    if (indexPath.row==1) {
        produceName=@"小时";
        productPrices=@"1.99";
    }
    if (indexPath.row==2) {
        produceName=@"天";
        productPrices=@"10.99";
    }
    if (indexPath.row==3) {
        produceName=@"月";
        productPrices=@"60.99";
    }

    TBuyProductViewController *buyProduct=[[TBuyProductViewController alloc] init];
    buyProduct.productPrice=productPrices;
    buyProduct.productName=produceName;
    [self.navigationController pushViewController:buyProduct animated:YES];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
