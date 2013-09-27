//
//  TCallViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
// com.kada.${PRODUCT_NAME:rfc1034identifier}

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TwilioAppDelegate.h"
#import "TwilioClient.h"
#import "MonkeyPhone.h"
#import "HelpDataBase.h"
#import "TLoginStatusBean.h"
#import "DeviceUDID.h"
#import "SBJson.h"
#import "SVProgressHUD.h"
#import "NSString+StringEmpty.h"
#import "TViewController.h"

@interface TCallViewController : TViewController<UIAlertViewDelegate,NSURLConnectionDelegate>
{
    NSURLConnection *addContactUrl;
    NSMutableData *addContactData;

}

@property (retain,nonatomic) NSURLConnection *addContactUrl;
@property (retain,nonatomic) NSMutableData *addContactData;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLbl;
@property (strong, nonatomic) NSString *paramPhone;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *zeroBtn;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (retain,nonatomic) UIButton *okBtn,*cancelBtn;

- (IBAction)clickNumberBtn:(id)sender;
- (IBAction)callAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)addContactAction:(id)sender;

//- (BOOL) isPracticeMgr;
//- (BOOL) hasSavedPhone;
- (void) switchCharater:(UILongPressGestureRecognizer *) gestureRecognizer;
- (void) playSoundEffect:(NSURL *) soundUrl;
- (void) appendString;
//- (BOOL)checkNumber:(NSString *)number;
//- (void) callArbitraryResponse: (NSString *) number;
-(NSString *)getTime;
@end
