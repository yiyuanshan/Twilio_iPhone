//
//  RecordCell.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
@property (retain,nonatomic) IBOutlet UILabel *name;
@property (retain,nonatomic) IBOutlet UILabel *phoneNumber;
@property (retain,nonatomic) IBOutlet UILabel *callTime;
@property (retain,nonatomic) IBOutlet UILabel *callTimes;

@end
