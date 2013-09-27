//
//  TLoginViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-2.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "RegistViewController.h"
#import "TwilioViewController.h"

@interface TLoginViewController : TViewController<UITextFieldDelegate>
{
    UITextField *userName;
    UITextField *password;
    NSURLConnection *loginConnection;
    NSMutableData *loginData;
    
    BECheckBox *passwordCheck;
	BECheckBox *autologinCheck;
    BOOL checkPassword;
    BOOL checkAutoLogin;
    BOOL checkP;
    BOOL checkA;
    NSDictionary *userDiction;
    
    id <loginStateDelegate> loginDelegate;
}
@property(assign,nonatomic) id <loginStateDelegate> loginDelegate;
@property (retain,nonatomic) NSDictionary *userDiction;
@property (nonatomic,retain) BECheckBox *passwordCheck;
@property (nonatomic,retain) BECheckBox *autologinCheck;
@property (retain,nonatomic) NSURLConnection *loginConnection;
@property (retain,nonatomic) NSMutableData *loginData;

@property (retain,nonatomic) IBOutlet UITextField *userName;
@property (retain,nonatomic) IBOutlet UITextField *password;

-(IBAction)keyBorderHideAction:(id)sender;
-(IBAction)userLoginAction:(id)sender;
-(IBAction)userRegistAction:(id)sender;
-(IBAction)forgetPassword:(id)sender;

@end
