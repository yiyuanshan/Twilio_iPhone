//
//  TViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "HelpDataBase.h"
#import "TLoginStatusBean.h"
#import "DeviceUDID.h"
#import "SBJson.h"
#import "NSString+StringEmpty.h"
#import "BECheckBox.h"
#import "UIColor+Codeconvert.h"
#import "TwilioAppDelegate.h"
#import "TwilloHeaders/TwilioClient.h"
#import "MonkeyPhone.h"
#import <AVFoundation/AVFoundation.h>
#import "TEncryptionPassword.h"

@interface TViewController : UIViewController
{
    int keyBoardMargin_;
}
- (int)scrllIntoView:(UIView *)textField leaveView:(BOOL)leave isLogin:(BOOL)islogin;
- (void)messageTitle:(NSString *)title Message:(NSString *)message;
- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave;
@end
