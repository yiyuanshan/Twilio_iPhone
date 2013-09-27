//
//  TEncryptionPassword.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-24.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"

@interface TEncryptionPassword : NSObject
+(NSString *) encryptionPasswordForMd5: (NSString *) inPutText;
@end
