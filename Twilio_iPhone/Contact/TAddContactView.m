//
//  TAddContactView.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-18.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TAddContactView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+StringEmpty.h"

#define portrait_keybord_y 200
@interface  TAddContactView()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end
@implementation TAddContactView
@synthesize delegate = _delegate;
@synthesize contactName=_contactName;
@synthesize contactPassword=_contactPassword;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];
    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    _titleView.textAlignment = UITextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    _titleView.lineBreakMode = UILineBreakModeTailTruncation;
    _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:_titleView];
    CGRect frame1=CGRectMake(20, 185, 90, 35);
    UIButton *CancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    CancelButton.frame=frame1;
    [CancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [CancelButton setBackgroundImage:[[UIImage imageNamed:@"dialog_button_normal.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateNormal];
    [CancelButton setBackgroundImage:[[UIImage imageNamed:@"dialog_button_active.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateHighlighted];
    [CancelButton addTarget:self action:@selector(CancelButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:CancelButton ];
    CGRect frame2=CGRectMake(190, 185, 90, 35);
    UIButton *OkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    OkButton.frame=frame2;
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton setBackgroundImage:[[UIImage imageNamed:@"dialog_button_normal.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateNormal];
    [OkButton setBackgroundImage:[[UIImage imageNamed:@"dialog_button_active.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateHighlighted];
    [OkButton addTarget:self action:@selector(OkButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:OkButton ];

    _contactName=[[UITextField alloc] initWithFrame:CGRectMake(20, 45, 260, 40)];
    [_contactName setBorderStyle:UITextBorderStyleRoundedRect];
    _contactName.delegate=self;
    _contactName.font=[UIFont systemFontOfSize:26];
    _contactName.placeholder=@"联系人姓名";
    [_contactName setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_contactName];
    
    _contactPassword=[[UITextField alloc] initWithFrame:CGRectMake(20, 105, 260, 40)];
    [_contactPassword setBorderStyle:UITextBorderStyleRoundedRect];
    _contactPassword.delegate=self;
    _contactPassword.font=[UIFont systemFontOfSize:26];
//    _contactPassword.keyboardType=UIKeyboardTypeNumberPad;
    _contactPassword.placeholder=@"电话号码";
    [_contactPassword setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_contactPassword];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)OkButtonclick:(id)sender
{
    if ([NSString_StringEmpty isEmptyOrNull:_contactName.text]) {
        [self messageTitle:@"提示！" Message:@"联系人姓名不能为空！"];

    }else
    {
        if ([NSString_StringEmpty isEmptyOrNull:_contactPassword.text]) {
            [self messageTitle:@"提示！" Message:@"联系人号码不能为空！"];
        }else
        {
            [self.delegate addContactTextFieldTextName:_contactName.text PhoneNumber:_contactPassword.text];
            [self.delegate addContactButtonIndex:1];
            [self dismiss];
        }
    }
}
-(IBAction)CancelButtonclick:(id)sender
{
    [self.delegate addContactButtonIndex:0];
    [self dismiss];
}
- (void)messageTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1, 0.0);
    self.alpha = 0;
    [UIView animateWithDuration:.45 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}
#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(addContactViewCancel:)]) {
        [self.delegate addContactViewCancel:self];
    }
    // dismiss self
    [_contactPassword resignFirstResponder];
    [_contactName resignFirstResponder];
    [self dismiss];
}
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self moveView:textField leaveView:YES];
//    [self scrllIntoView:textField leaveView:NO isLogin:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:NO];
//    [self scrllIntoView:textField leaveView:YES isLogin:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contactPassword resignFirstResponder];
    [_contactName resignFirstResponder];
    return YES;
}

- (int)scrllIntoView:(UIView *)textField leaveView:(BOOL)leave isLogin:(BOOL)islogin
{
    CGRect viewframe = self.bounds;
	
    
	float offsetY = textField.frame.origin.y+textField.frame.size.height-portrait_keybord_y;
	if (islogin) {
		offsetY = offsetY+49;
	}
	else
	{
		if (offsetY<=0) {
			return 0;
		}
	}
    if (leave)
    {//hide
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
		
		self.bounds = CGRectMake(viewframe.origin.x, viewframe.origin.y+offsetY, viewframe.size.width,
									 viewframe.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
		self.bounds = CGRectMake(viewframe.origin.x, viewframe.origin.y-offsetY, viewframe.size.width,
									 viewframe.size.height);
        [UIView commitAnimations];
    }
    return offsetY;
}
#pragma make  keyboard

- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    float screenHeight = 480; //screen size
    float keyboardHeight = 216; //keyboard size
    float statusBarHeight,tableCellHeight,textFieldFromButtomHeigth;
    int margin;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    NavBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    //UITableViewCell *tableViewCell=(UITableViewCell *)textField.superview;
    tableCellHeight = textField.frame.origin.y+2*textField.frame.size.height;
    
    
    textFieldFromButtomHeigth = screenHeight - statusBarHeight  - tableCellHeight;
//    NSLog(@"height=====>%f",textFieldFromButtomHeigth);
    if(!leave) {
        if(textFieldFromButtomHeigth < keyboardHeight) {
            margin = keyboardHeight - textFieldFromButtomHeigth;
            keyBoardMargin_ = margin;
        } else {
            margin= 0;
            keyBoardMargin_ = 0;
        }
    }
    const float movementDuration = 0.4f;
    
    int movement = (leave ? keyBoardMargin_ : -margin);
    
    [UIView beginAnimations: @"textFieldAnim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.bounds = CGRectOffset(self.bounds, 0, movement);
    [UIView commitAnimations];
}

@end
