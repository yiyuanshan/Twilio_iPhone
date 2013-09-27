//
//  TRecordViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "TCallConnectingViewController.h"
#import "RecordCell.h"

@interface TRecordViewController : TViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSURLConnectionDelegate>
{
    NSURLConnection *getRecordListUrl;
    NSMutableData *getRecordData;
    
    NSURLConnection *deleateRecordUrl;
    NSMutableData *deleateRecordData;
}

@property (retain,nonatomic) IBOutlet UILabel *noContact;
@property (nonatomic,strong) NSMutableArray* listData;
@property (retain,nonatomic) NSURLConnection *getRecordListUrl;
@property (retain,nonatomic) NSMutableData *getRecordData;

@property (retain,nonatomic) NSURLConnection *deleateRecordUrl;
@property (retain,nonatomic) NSMutableData *deleateRecordData;

@property (retain,nonatomic) IBOutlet UITableView *recoreTableView;
-(IBAction)deleteAction:(id)sender;
@end
