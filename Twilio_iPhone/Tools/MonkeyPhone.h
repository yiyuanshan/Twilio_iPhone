//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <Foundation/Foundation.h>

#import "TCDevice.h"
#import "TCConnection.h"

@interface MonkeyPhone : NSObject<TCConnectionDelegate,TCDeviceDelegate>
{
@private
	TCDevice* _device;
    TCConnection* _connection;
    id <TCDeviceDelegate> delegate;
}
@property (retain,nonatomic) id <TCDeviceDelegate> delegate;
-(void)connect:(NSString*)phoneNumber;
-(void)disconnect;

@end
