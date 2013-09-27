//
//  TwilioAppDelegate.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-2.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwilioViewController;
@class MonkeyPhone;

@interface TwilioAppDelegate : UIResponder <UIApplicationDelegate>
{
    MonkeyPhone* _phone;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TwilioViewController *viewController;
@property (nonatomic, retain) MonkeyPhone* phone;
@end
