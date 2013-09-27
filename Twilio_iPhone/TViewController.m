//
//  TViewController.m
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import "TViewController.h"

#define portrait_keybord_y 200
@interface TViewController ()

@end

@implementation TViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (int)scrllIntoView:(UIView *)textField leaveView:(BOOL)leave isLogin:(BOOL)islogin
{
    CGRect viewframe = self.view.frame;
	
    
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
		
		self.view.frame = CGRectMake(viewframe.origin.x, viewframe.origin.y+offsetY, viewframe.size.width,
									 viewframe.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
		self.view.frame = CGRectMake(viewframe.origin.x, viewframe.origin.y-offsetY, viewframe.size.width,
									 viewframe.size.height);
        [UIView commitAnimations];
    }
    return offsetY;
}
- (void)messageTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma make  keyboard

- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    float screenHeight = 480; //screen size
    float keyboardHeight = 216; //keyboard size
    float statusBarHeight,NavBarHeight,tableCellHeight,textFieldFromButtomHeigth;
    int margin;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NavBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    //UITableViewCell *tableViewCell=(UITableViewCell *)textField.superview;
    tableCellHeight = textField.frame.origin.y+2*textField.frame.size.height;
    
    
    textFieldFromButtomHeigth = screenHeight - statusBarHeight - NavBarHeight - tableCellHeight-35;
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
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
