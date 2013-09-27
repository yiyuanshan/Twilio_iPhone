//
//  TSubscripteViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "HistoryCell.h"
#import "TProductViewController.h"

@interface TSubscripteViewController : TViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (retain,nonatomic) IBOutlet UILabel *headLable;
@property (retain,nonatomic) IBOutlet UITableView *buyHistoryTableView;
-(IBAction)deleteAction:(id)sender;
-(IBAction)productAction:(id)sender;
@end
