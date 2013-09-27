//
//  TContactViewController.h
//  Twilio_iPhone
//
//  Created by hcui on 13-9-3.
//  Copyright (c) 2013年 kada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAddContactView.h"
#import "TViewController.h"
#import "TContactInFoController.h"
#import "pinyin.h"
#import "POAPinyin.h"

@interface TContactViewController : TViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,TAddContactViewDelegate>
{
    NSURLConnection *contactListUrl;
    NSMutableData *contactListData;

    NSURLConnection *addContactUrl;
    NSMutableData *addContactData;
    
    NSURLConnection *searchContactUrl;
    NSMutableData *searchContactData;
    
    NSURLConnection *deleateContactUrl;
    NSMutableData *deleateContactData;
    
    NSString *contactName;
    NSString *contactPhoneNumber;
    BOOL searchStatus;
    NSMutableArray *headArray;
    NSMutableDictionary *sectionDic;
    NSArray *keys;
}
@property (retain,nonatomic) NSArray *keys;
@property (retain,nonatomic) NSMutableArray *headArray;
@property (retain,nonatomic) IBOutlet UILabel *noContact;
@property (nonatomic,strong) NSMutableArray* listData;

@property (retain,nonatomic) NSURLConnection *contactListUrl;
@property (retain,nonatomic) NSMutableData *contactListData;

@property (retain,nonatomic) NSURLConnection *searchContactUrl;
@property (retain,nonatomic) NSMutableData *searchContactData;

@property (retain,nonatomic) NSURLConnection *deleateContactUrl;
@property (retain,nonatomic) NSMutableData *deleateContactData;

@property (retain,nonatomic) NSURLConnection *addContactUrl;
@property (retain,nonatomic) NSMutableData *addContactData;
@property (retain,nonatomic) IBOutlet UITableView *contactNameTableView;
@property (retain,nonatomic) IBOutlet UISearchBar *nameSearchBar;

//- (void)pinYinPaiXu:(NSString *)personname RecordName:(id)record;
//-(BOOL)searchResult:(NSString *)contactname searchText:(NSString *)searchT;
@end
