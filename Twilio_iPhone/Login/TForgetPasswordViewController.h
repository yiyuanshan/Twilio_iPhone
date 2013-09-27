//
//  TForgetPasswordViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"

@interface TForgetPasswordViewController : TViewController<UITextFieldDelegate>
{
    UITextField *code;
    UITextField *password;
    UITextField *passwordAgain;
    
    NSString *phoneNumber;
    NSString *codeNumber;
    
    NSURLConnection *forgetConnection;
    NSMutableData *forgetData;
}

@property (retain,nonatomic) NSURLConnection *forgetConnection;
@property (retain,nonatomic) NSMutableData *forgetData;
@property (retain,nonatomic) NSString *phoneNumber;
@property (retain,nonatomic) NSString *codeNumber;
@property (retain,nonatomic) IBOutlet UILabel *codeLable;

@property (retain,nonatomic) IBOutlet UITextField *code;
@property (retain,nonatomic) IBOutlet UITextField *password;
@property (retain,nonatomic) IBOutlet UITextField *passwordAgain;

-(IBAction)backAction:(id)sender;
-(IBAction)savePasswordAction:(id)sender;
-(IBAction)keyBorderHideAction:(id)sender;

@end
