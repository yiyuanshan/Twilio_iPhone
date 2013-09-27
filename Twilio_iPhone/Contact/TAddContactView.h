//
//  TAddContactView.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-18.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAddContactView;
@protocol TAddContactViewDelegate<NSObject>
@optional

- (void)addContactViewCancel:(TAddContactView *)addContactView;
- (void)addContactButtonIndex:(NSInteger )index ;
- (void)addContactTextFieldTextName:(NSString *)name PhoneNumber:(NSString *)number;
@end


@interface TAddContactView : UIView<UITextFieldDelegate>
{
    UILabel     *_titleView;
    UIControl   *_overlayView;
    int keyBoardMargin_;
    UITextField *_contactName;
    UITextField *_contactPassword;
    id <TAddContactViewDelegate>   _delegate;
}

@property (strong,nonatomic) id <TAddContactViewDelegate>   delegate;
@property (strong,nonatomic) UITextField *contactName;
@property (strong,nonatomic) UITextField *contactPassword;
- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;
-(IBAction)OkButtonclick:(id)sender;
-(IBAction)CancelButtonclick:(id)sender;
@end
