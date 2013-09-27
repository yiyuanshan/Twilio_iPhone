//
//  RegistViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "RegistGetCodeViewController.h"
#import "TForgetPasswordViewController.h"

@interface RegistViewController : TViewController<UITextFieldDelegate>
{
    UITextField *phoneNumber;
    NSURLConnection *sendPhoneURL;
    NSMutableData *sendPhoneData;
}
@property (retain,nonatomic) NSURLConnection *sendPhoneURL;
@property (retain,nonatomic) NSMutableData *sendPhoneData;

@property (retain,nonatomic) IBOutlet UITextField *phoneNumber;
@property (assign,nonatomic) BOOL fromView;

-(IBAction)backAction:(id)sender;
-(IBAction)getCodeAction:(id)sender;
-(IBAction)keyBorderHide:(id)sender;
@end
