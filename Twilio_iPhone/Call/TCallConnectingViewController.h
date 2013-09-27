//
//  TCallConnectingViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-13.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwilioAppDelegate.h"
#import "TwilioClient.h"
#import "MonkeyPhone.h"
#import "HelpDataBase.h"
#import "TLoginStatusBean.h"
#import "DeviceUDID.h"

@interface TCallConnectingViewController : UIViewController<NSURLConnectionDelegate>
{
	UIButton* _hangupButton;
    NSURLConnection *addToRecordUrl;
    NSMutableData *addToRecordData;
    NSString *startTimes;
    NSString *moblieNumber;
    NSString *Millisecond;
}

@property (retain,nonatomic) NSString *Millisecond;
@property (retain,nonatomic) NSString *startTimes;
@property (retain,nonatomic) NSString *moblieNumber;
@property (retain,nonatomic) NSURLConnection *addToRecordUrl;
@property (retain,nonatomic) NSMutableData *addToRecordData;

@property (strong, nonatomic) IBOutlet UIWebView *animationCall;
@property (nonatomic, retain) IBOutlet UIButton* hangupButton;
-(IBAction)hangupButtonPressed:(id)sender;
-(NSString *)getTime;
-(float)durationTimes:(NSString *)time;
@end
