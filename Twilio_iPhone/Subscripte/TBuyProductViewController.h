//
//  TBuyProductViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-4.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewController.h"
#import "PayPalMobile.h"

@interface TBuyProductViewController : TViewController<PayPalPaymentDelegate,NSURLConnectionDelegate>
{
    NSInteger  prodrctCount;
    NSString *productName;
    NSString *productPrice;
}
@property (strong ,nonatomic) NSURLConnection *payUrl;
@property (strong ,nonatomic) NSMutableData *payData;
@property (retain,nonatomic) IBOutlet UILabel *price;
@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productPrice;
@property (nonatomic, strong) NSString *environment;
@property (assign,nonatomic)  NSInteger prodrctCount;
@property (nonatomic, strong) PayPalPayment *completedPayment;
@property (retain,nonatomic) IBOutlet UILabel *buyMinuteCount;
@property (retain,nonatomic) IBOutlet UILabel *buyCount;
@property(nonatomic, assign) BOOL acceptCreditCards;

- (IBAction)addCountAction:(id)sender;
- (IBAction)reduceCountAction:(id)sender;

- (IBAction)backAction:(id)sender;
- (IBAction)buyProductAction:(id)sender;
- (void)pay;
@end
