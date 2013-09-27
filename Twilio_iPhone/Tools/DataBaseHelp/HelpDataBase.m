//
//  HelpDataBase.m
//  ContactInformation
//
//  Created by apple  on 12-10-31.
//  Copyright (c) 2012年 apple . All rights reserved.
//

#import "HelpDataBase.h"

#define DB_NAME @"Twilio.sqlite"

@implementation HelpDataBase

- (id)init
{
    self = [super init];
    if (self) {
        [self opendatabase];
    }
    return self;
}
+(HelpDataBase *) instance
{
    static HelpDataBase *parserInstance;
	@synchronized(self) {
		if (!parserInstance) {
			parserInstance = [[HelpDataBase alloc] init];
		}
	}
	return parserInstance;
}
- (NSString *)dataFilePath
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:
                   writableDBPath error:&error];
        if (!success) {
           
        }
    }
    return writableDBPath;
}
-(void)opendatabase
{
        int open=sqlite3_open([self.dataFilePath UTF8String], &database);
        //NSLog(@"open=%d",open);
        if ( open!= SQLITE_OK) {
             sqlite3_close(database);
            NSLog(@"open database error! ");
        }
}

-(void)insertTotable:(TLoginStatusBean *)info
{  
    char *error;
    NSString *insertsql=[NSString stringWithFormat:@"insert into UserLogin (status,username,userpassword,userid,checkpassword,checkautologin,nothingCheck) VALUES ('%d','%@','%@','%d','%d','%d',%d)",info.status,info.userName,info.userPassword,info.userId,info.checkPassowrd,info.checkAutoLogin,info.nothingCheck];
    int insert=sqlite3_exec(database, [insertsql UTF8String], NULL, NULL, &error);
        //NSLog(@"insert=%d",insert);
       // NSLog(@"error=%s",error);
        if (insert!=SQLITE_OK) {
           NSLog(@"insert data error !");
        sqlite3_close(database);
            
        }
        else
        {
//            NSLog(@"insert data OK !");
        }
    
}

- (void)updateTotable:(TLoginStatusBean *)info
{
    char *error;
	NSString *sql = [NSString stringWithFormat:@"update UserLogin set status= '%d',username= '%@',userpassword= '%@' ,userid='%d' ,checkpassword='%d' ,checkautologin='%d' ,nothingCheck='%d' where id = 1",info.status,info.userName,info.userPassword,info.userId,info.checkPassowrd,info.checkAutoLogin,info.nothingCheck];
    int updata=sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error) ;
	if (updata!= SQLITE_OK) {
        NSLog(@"update error");
		sqlite3_close(database);
	}
	
}
-(void)updateCheckAutoLoginTotable
{
    char *error;
	NSString *sql = [NSString stringWithFormat:@"update UserLogin set status='0' where id = 1"];
    int updata=sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error) ;
	if (updata!= SQLITE_OK) {
        NSLog(@"update error");
		sqlite3_close(database);
	}
}
-(void)deleteTotable
{
    char *szError = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from UserLogin where id = 1;"];
   // NSLog(@"info.UserId=%d",info._id);
    int result = sqlite3_exec(database, [sql UTF8String], 0, 0, &szError);
    if (result != SQLITE_OK) {
        NSLog(@"delete data error!");
        sqlite3_close(database);
    }
    else{
        //NSLog(@"delete data OK!");
    }
   // [sql release];
    
}

-(void)queryTotable:(NSMutableArray *)_arr
{
    sqlite3_stmt *statement=nil;
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from UserLogin;"] ;
    int get=sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil);
   // NSLog(@"get=%d",get);
    if (get==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW)
		{
            NSInteger _id=sqlite3_column_int(statement, 0);
			NSInteger status=sqlite3_column_int(statement,1);
            NSString *name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *password=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            NSInteger user_id=sqlite3_column_int(statement, 4);
            NSInteger checkpassword=sqlite3_column_int(statement, 5);
            NSInteger checkautologin=sqlite3_column_int(statement, 6);
            NSInteger nothingcheck=sqlite3_column_int(statement, 7);
            TLoginStatusBean *bean=[[TLoginStatusBean alloc] initLoginStatus:_id LoginStatus:status UserName:name UserPassword:password UserId:user_id CheckPassword:checkpassword CheckAutoLogin:checkautologin NothingCheck:nothingcheck];
            [_arr addObject:bean];
		}
		sqlite3_finalize(statement);
        statement = nil;
       
    } else
    {
        sqlite3_close(database);
    }
}
//-(NSInteger )getitemcountTotable
//{
//    sqlite3_stmt *pStmt=nil;
//    NSString *sqlcount = @"select * from students";
//    sqlite3_prepare_v2(database, [sqlcount UTF8String], -1, &pStmt, nil);
//    if (SQLITE_ROW == sqlite3_step(pStmt)) {
//    return sqlite3_column_int(pStmt, 0);
//   }
//    return 0;
//}
//

@end
