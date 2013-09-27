//
//  TLoginStatusBean.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TLoginStatusBean.h"

@implementation TLoginStatusBean

@synthesize statusId,status,userName,userPassword;
@synthesize userId;
@synthesize checkAutoLogin,checkPassowrd;
@synthesize nothingCheck;
- (id)initLoginStatus:(NSInteger )_id LoginStatus:(NSInteger )loginstatus UserName:(NSString *)username UserPassword:(NSString *)userpassword UserId:(NSInteger )userid CheckPassword:(NSInteger )checkpassword CheckAutoLogin:(NSInteger ) checkautologin NothingCheck:(NSInteger ) nothingcheck
{
    self=[super init];
    
    if (self) {
        self.statusId=_id;
        self.status=loginstatus;
        self.userName=username;
        self.userPassword=userpassword;
        self.userId=userid;
        self.checkAutoLogin=checkautologin;
        self.checkPassowrd=checkpassword;
        self.nothingCheck=nothingcheck;
    }
    
    return self;
}
@end
