//
//  TContactInFoController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-22.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "TCallConnectingViewController.h"

@interface TContactInFoController : TViewController<UITextFieldDelegate,NSURLConnectionDelegate>
{
    UILabel *editContactInfoLable;
    BOOL editStatus;
    NSString *Name;
    NSString *contactId;
    NSString *contactNumber;
    
    NSURLConnection *editContactInfoConnection;
    NSMutableData *editContactInfoData;
}
@property (nonatomic,strong) NSMutableArray* listData;
@property (retain,nonatomic) NSString *Name;
@property (retain,nonatomic) NSString *contactId;
@property (retain,nonatomic) NSString *Phone;
@property (retain,nonatomic) IBOutlet UITextField *contactName;
@property (retain,nonatomic) IBOutlet UITextField *contactPhone;
@property (retain,nonatomic) IBOutlet UITextField *contactAddress;
@property (retain,nonatomic) IBOutlet UITextField *otherText;
@property (retain,nonatomic) UILabel *editContactInfoLable;
@property (retain,nonatomic) NSURLConnection *editContactInfoConnection;
@property (retain,nonatomic) NSMutableData *editContactInfoData;

-(IBAction)backAction:(id)sender;
-(IBAction)editContactInfoAction:(id)sender;
-(IBAction)keyBorderHideAction:(id)sender;
-(IBAction)callAction:(id)sender;
@end
