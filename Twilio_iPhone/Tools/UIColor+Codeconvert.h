//
//  UIColor+Codeconvert.h
//  DoctorCom
//
//  Created by KADA on 12-9-21.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Codeconvert)
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+ (UIColor *) colorWithHexString: (NSString *) hexString;
@end
