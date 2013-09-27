//
//  TChangeNumberViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "TChangCodeViewController.h"

@interface TChangeNumberViewController : TViewController<UITextFieldDelegate>

@property (retain,nonatomic) IBOutlet UITextField *inputPhoneNumber;
- (IBAction)keyBorderHideAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
@end
