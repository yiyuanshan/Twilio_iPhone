//
//  TLoginStatusBean.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLoginStatusBean : NSObject
{
    NSInteger statusId;
    NSInteger status;
    NSString *userName;
    NSString *userPassword;
    NSInteger  userId;
    NSInteger checkPassowrd;
    NSInteger checkAutoLogin;
    NSInteger nothingCheck;
}
@property (assign,nonatomic) NSInteger nothingCheck;
@property (assign,nonatomic) NSInteger statusId;
@property (assign,nonatomic) NSInteger status;
@property (retain,nonatomic) NSString *userName;
@property (retain,nonatomic) NSString *userPassword;
@property (assign,nonatomic) NSInteger  userId;
@property (assign,nonatomic) NSInteger  checkPassowrd;
@property (assign,nonatomic) NSInteger  checkAutoLogin;

- (id)initLoginStatus:(NSInteger )_id LoginStatus:(NSInteger )loginstatus UserName:(NSString *)username UserPassword:(NSString *)userpassword UserId:(NSInteger )userid CheckPassword:(NSInteger )checkpassword CheckAutoLogin:(NSInteger ) checkautologin NothingCheck:(NSInteger ) nothingcheck;
@end
