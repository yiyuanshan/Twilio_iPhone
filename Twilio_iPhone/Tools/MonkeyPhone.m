//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "MonkeyPhone.h"

@implementation MonkeyPhone
@synthesize delegate;

-(id)init
{
	if ( self = [super init] )
	{
// Replace the URL with your Capabilities Token URL
		NSURL* url = [NSURL URLWithString:@"http://122.193.29.102:82/loginfilter/TwilioAuth"];
		NSURLResponse*  response = nil;
		NSError*  	error = nil;
		NSData* data = [NSURLConnection sendSynchronousRequest:
						[NSURLRequest requestWithURL:url] 
											 returningResponse:&response 
														 error:&error];
		if (data)
		{
			NSHTTPURLResponse*  httpResponse = (NSHTTPURLResponse*)response;
			
			if (httpResponse.statusCode == 200)
			{
				NSString* capabilityToken = [[[NSString alloc] initWithData:data
																	 encoding:NSUTF8StringEncoding] 
											   autorelease];
				
				_device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken
															 delegate:self];
			}
			else
			{
				NSString*  errorString = [NSString stringWithFormat:
											@"HTTP status code %d",                          
											httpResponse.statusCode];
				NSLog(@"Error logging in: %@", errorString);
			}
		}
		else
		{
			NSLog(@"Error logging in: %@", [error localizedDescription]);
		}
	}
	return self;
}
-(void)deviceDidStartListeningForIncomingConnections:(TCDevice*)device
{
    NSLog(@"Device is now listening for incoming connections");
}
-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error
{
    if ( !error )
    {
        NSLog(@"Device is no longer listening for incoming connections");
    }
    else
    {
        NSLog(@"Device no longer listening for incoming connections due to error: %@", [error localizedDescription]);
    }
}
-(void)device:(TCDevice *)device didReceiveIncomingConnection:(TCConnection *)connection
{
//    NSLog(@"device error");
}
-(void)connection:(TCConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
}
-(void)connectionDidConnect:(TCConnection *)connection
{
    NSLog(@"didconnection");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpTo" object:nil];
}
-(void)connectionDidDisconnect:(TCConnection *)connection
{
    NSLog(@"DidDisconnect");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpFrom" object:nil];
}
-(void)connectionDidStartConnecting:(TCConnection *)connection
{
    NSLog(@"DidStartConnecting");
    
}


-(void)connect:(NSString*)phoneNumber
{
    NSDictionary* parameters = nil;
    if ( [phoneNumber length] > 0 )
    {
        parameters = [NSDictionary dictionaryWithObject:phoneNumber forKey:@"PhoneNumber"];
    }
    _connection = [_device connect:parameters delegate:self];
    [_connection retain];
}
-(void)disconnect
{
    [_connection disconnect];
    [_connection release];
    _connection = nil;
}
-(void)dealloc
{
	[_device release];
	[super dealloc];
}


@end
