//
//  TChangCodeViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"

@interface TChangCodeViewController : TViewController<UITextFieldDelegate>

@property (retain,nonatomic) IBOutlet UITextField *iputCode;
- (IBAction)keyBorderHideAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
