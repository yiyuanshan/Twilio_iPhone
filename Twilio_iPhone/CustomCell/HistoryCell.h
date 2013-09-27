//
//  HistoryCell.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (retain,nonatomic) IBOutlet UILabel *buyTime;
@property (retain,nonatomic) IBOutlet UILabel *productName;
@property (retain,nonatomic) IBOutlet UILabel *productPrice;

@end
