//
//  RegistGetCodeViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "NumberViewController.h"

@interface RegistGetCodeViewController : TViewController<UITextFieldDelegate>
{
    UILabel *titleText;
    UITextField *code;
    UITextField *userName;
    UITextField *password;
    UITextField *passwordAgain;
    
    NSURLConnection *registURL;
    NSMutableData *registData;
    
    NSString *phoneNumber;
    NSString *codeNumber;
    
}


@property (retain,nonatomic) NSURLConnection *registURL;
@property (retain,nonatomic) NSMutableData *registData;

@property (retain,nonatomic) NSString *phoneNumber;
@property (retain,nonatomic) NSString *codeNumber;
@property (retain,nonatomic) IBOutlet UILabel *codeLable;

@property (retain,nonatomic) IBOutlet UILabel *titleText;
@property (retain,nonatomic) IBOutlet UITextField *code;
@property (retain,nonatomic) IBOutlet UITextField *userName;
@property (retain,nonatomic) IBOutlet UITextField *password;
@property (retain,nonatomic) IBOutlet UITextField *passwordAgain;

-(IBAction)backAction:(id)sender;
-(IBAction)registAction:(id)sender;
-(IBAction)keyBorderHideAction:(id)sender;

@end
