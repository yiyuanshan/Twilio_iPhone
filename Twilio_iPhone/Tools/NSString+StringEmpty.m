//
//  NSString+StringEmpty.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-16.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "NSString+StringEmpty.h"

@implementation NSString_StringEmpty
+(Boolean) isEmptyOrNull:(NSString *) str {
    
    if (!str) {
        
        return YES;
        
    } else {
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimedString length] == 0) {
            
            // empty string
            
            return YES;
            
        } else {
            
            // is neither empty nor null 
            
            return NO;
            
        }
        
    }
    
}
@end
