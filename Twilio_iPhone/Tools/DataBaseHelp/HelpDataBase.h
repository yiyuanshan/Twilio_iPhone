//
//  HelpDataBase.h
//  ContactInformation
//
//  Created by apple  on 12-10-31.
//  Copyright (c) 2012年 apple . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TLoginStatusBean.h"

@interface HelpDataBase : NSObject
{
    sqlite3 *database;
}
+(HelpDataBase *) instance;
-(void)opendatabase;

-(void)insertTotable:(TLoginStatusBean *)info;
-(void)updateTotable:(TLoginStatusBean *)info;
-(void)updateCheckAutoLoginTotable;
-(void)deleteTotable;
-(void)queryTotable:(NSMutableArray *)_arr;
@end
