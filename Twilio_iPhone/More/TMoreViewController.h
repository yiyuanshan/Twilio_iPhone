//
//  TMoreViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "TChangeNumberViewController.h"
#import "TContactAdminViewController.h"
#import "TLoginViewController.h"
#import "TwilioViewController.h"

@interface TMoreViewController : TViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSURLConnection *logoutUrl;
    NSMutableData *logoutData;
}
@property (retain,nonatomic) NSMutableData *logoutData;
@property (retain,nonatomic) NSURLConnection *logoutUrl;
@property (retain,nonatomic) IBOutlet UITableView *moreTableView;
@property (retain,nonatomic) NSMutableArray *dataArray;
@end
