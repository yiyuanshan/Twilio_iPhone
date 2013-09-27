//
//  TwilioViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-2.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDataBase.h"
#import "TLoginStatusBean.h"
//#import "SBJson.h"
#import "DeviceUDID.h"

@protocol loginStateDelegate <NSObject>

-(void)loginState:(BOOL)sta;

@end

@interface TwilioViewController : UIViewController<UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,UINavigationBarDelegate,loginStateDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
    UITabBarController *tabbarcontroller;
    BOOL autoLoginStatus;
    
    NSURLConnection *loginConnection;
    NSMutableData *loginData;
    
    NSDictionary *userDiction;
}
@property (retain,nonatomic) NSDictionary *userDiction;
@property (retain,nonatomic) NSURLConnection *loginConnection;
@property (retain,nonatomic) NSMutableData *loginData;
@property (retain,nonatomic) UITabBarController *tabbarcontroller;
@property (retain,nonatomic) NSMutableArray *autoArray;


@end
