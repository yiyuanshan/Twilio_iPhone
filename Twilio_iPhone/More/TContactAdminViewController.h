//
//  TContactAdminViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-5.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"

@interface TContactAdminViewController : TViewController<UITextFieldDelegate,UITextViewDelegate>
@property (retain,nonatomic) IBOutlet UITextField *subject;
@property (retain,nonatomic) IBOutlet UITextView *subjectBody;
- (IBAction)keyBorderHideAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)sendSubjectAction:(id)sender;
@end
