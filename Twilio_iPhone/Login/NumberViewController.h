//
//  NumberViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"

@interface NumberViewController : TViewController
{
    UITextView *successView;
}
@property (retain,nonatomic) IBOutlet UITextView *successView;
-(IBAction)loginAction:(id)sender;
-(IBAction)backAction:(id)sender;
@end
