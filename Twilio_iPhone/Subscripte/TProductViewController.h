//
//  TProductViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "ProductCell.h"
#import "TBuyProductViewController.h"

@interface TProductViewController : TViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) IBOutlet UITableView *productTableView;

- (IBAction)backAction:(id)sender;
@end
