//
//  Database.m
//  SmartOffice
//
//  Created by FNSPL on 18/03/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "Database.h"

#define databaseName @"TCS.sqlite"

static sqlite3 *database = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static Database* _shareddb = nil;

@implementation Database

+(Database*) sharedDB
{
    @synchronized([Database class])
    {
        if (!_shareddb)
            _shareddb = [[self alloc] init];
        
        return _shareddb;
    }
    
    return nil;
}

-(void)createdb{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        [self createUserTable];
        
    }
}

- (NSString *) getDBPath {
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    return databasePath;
}


-(void)createUserTable
{
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        char *errMsg;
        
        const char *sqlStatement =  "CREATE TABLE IF NOT EXISTS user(ID INTEGER PRIMARY KEY AUTOINCREMENT,userid TEXT,username TEXT,password TEXT,usertype TEXT,status TEXT,department TEXT,designation TEXT,email TEXT,fname TEXT,lname TEXT)";
        
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK) {
            
            NSLog(@"Failed to create user table");
        }
        else
        {
            NSLog(@"user table is created");
            
            [self createMeetingTable];
        }
        
        sqlite3_close(database);
        
    }
    else {
        
        char *error = NULL;
        
        NSLog(@"Unable to create table %s", error);
        
        sqlite3_free(error);
        
        error = NULL;
    }
}

-(void)createMeetingTable
{
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        char *errMsg;
        
        const char *sqlStatement =  "CREATE TABLE IF NOT EXISTS meeting(ID INTEGER PRIMARY KEY AUTOINCREMENT,appointmentId TEXT,employeeId TEXT,employeeName TEXT,employeeEmail TEXT,employeePhone TEXT,department TEXT,appointmentTime TEXT,duration TEXT,agenda TEXT,fdate TEXT,sdate TEXT,appointmentType TEXT,readStatus TEXT,status TEXT,otp TEXT,eventId TEXT)";
        
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK) {
            
            NSLog(@"Failed to create meeting table");
        }
        else
        {
            NSLog(@"meeting table is created");
            
            [self createNotificationTable];
        }
        
        sqlite3_close(database);
        
    }
    else {
        
        char *error = NULL;
        
        NSLog(@"Unable to create table %s", error);
        
        sqlite3_free(error);
        
        error = NULL;
    }
}

-(void)createNotificationTable
{
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        char *errMsg;
        
        const char *sqlStatement =  "CREATE TABLE IF NOT EXISTS notification(ID INTEGER PRIMARY KEY AUTOINCREMENT,userid TEXT,notificationid TEXT,appointmentid TEXT,details TEXT)";
        
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK) {
            
            NSLog(@"Failed to create notification table");
        }
        else
        {
            NSLog(@"notification table is created");
            
            [self createUserAvaillability];
        }
        
        sqlite3_close(database);
        
    }
    else {
        
        char *error = NULL;
        
        NSLog(@"Unable to create table %s", error);
        
        sqlite3_free(error);
        
        error = NULL;
    }
}

-(void)createUserAvaillability
{
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        char *errMsg;
        
        const char *sqlStatement =  "CREATE TABLE IF NOT EXISTS useravail(ID INTEGER PRIMARY KEY AUTOINCREMENT, Tag TEXT, date TEXT, day TEXT, fromTime TEXT, toTime TEXT, isON TEXT)";
        
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK) {
            
            NSLog(@"Failed to create user table");
        }
        else
        {
            NSLog(@"user table is created");
            
            [self createETATrack];
        }
        
        sqlite3_close(database);
        
    }
    else {
        
        char *error = NULL;
        
        NSLog(@"Unable to create table %s", error);
        
        sqlite3_free(error);
        
        error = NULL;
    }
}

-(void)createETATrack
{
    const char *dbpath = [[self getDBPath] UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        char *errMsg;
        
        const char *sqlStatement =  "CREATE TABLE IF NOT EXISTS eta(ID INTEGER PRIMARY KEY AUTOINCREMENT,userid TEXT,appointmentId TEXT,toid TEXT,pushtype TEXT,date TEXT,time TEXT,isSend TEXT)";
        
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK) {
            
            NSLog(@"Failed to create user table");
        }
        else
        {
            NSLog(@"eta table is created");
        }
        
        sqlite3_close(database);
        
    }
    else {
        
        char *error = NULL;
        
        NSLog(@"Unable to create table %s", error);
        
        sqlite3_free(error);
        
        error = NULL;
    }
}


#pragma mark - Insert tables

- (void) insertInUserTableWithUsername:(NSString *)username andPassword:(NSString *)password andUserid:(NSString *)userid andUsertype:(NSString *)usertype andStatus:(NSString *)status andDepartment:(NSString *)department andDesignation:(NSString *)designation andEmail:(NSString *)email andFname:(NSString *)fname anLname:(NSString *)lname {
    
    NSString *dbPath = [self getDBPath];
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        const char *sqlDB = "Insert into user(userid,username,password,usertype,status,department,designation,email,fname,lname) VALUES (?,?,?,?,?,?,?,?,?,?)";
        
        
        sqlite3_prepare_v2(database, sqlDB,-1, &addStmt, NULL);
        
        if (sqlite3_step(addStmt) == SQLITE_DONE)
        {
            sqlite3_bind_text(addStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 3, [password UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 4, [usertype UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 5, [status UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 6, [department UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 7, [designation UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 8, [email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 9, [fname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 10, [lname UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_reset(addStmt);
        }
        else {
            
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_close(database);
        
    }
}


- (void) insertInMeetingTableWithAppointmentId:(NSString *)appointmentId andEmployeeId:(NSString *)employeeId andEmployeeName:(NSString *)employeeName andEmployeeEmail:(NSString *)employeeEmail andEmployeePhone:(NSString *)employeePhone andDepartment:(NSString *)department andAppointmentTime:(NSString *)appointmentTime anDuration:(NSString *)duration anAgenda:(NSString *)agenda andFdate:(NSString *)fdate anSdate:(NSString *)sdate andAppointmentType:(NSString *)appointmentType andReadStatus:(NSString *)readStatus andStatus:(NSString *)status andOtp:(NSString *)otp andEventId:(NSString *)eventId{
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        addStmt = nil;
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        if(addStmt == nil) {
            
            const char *sqlDB = "Insert into meeting(appointmentId,employeeId,employeeName,employeeEmail,employeePhone,department,appointmentTime,duration,agenda,fdate,sdate,appointmentType,readStatus,status,otp,eventId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            
            if(sqlite3_prepare_v2(database, sqlDB, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            
                sqlite3_close(database);
            
        }
        
        
        sqlite3_bind_text(addStmt, 1, [appointmentId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [employeeId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [employeeName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [employeeEmail UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 5, [employeePhone UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [department UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 7, [appointmentTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 8, [duration UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 9, [agenda UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 10, [fdate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 11, [sdate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 12, [appointmentType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 13, [readStatus UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 14, [status UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 15, [otp UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 16, [eventId UTF8String], -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(addStmt)!= SQLITE_DONE){
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        
        
        sqlite3_reset(addStmt);
        sqlite3_finalize(addStmt);
        sqlite3_close(database);
        
    }
   
}


- (void) insertInNotificationTableWithNotificationid:(NSString *)notificationid anDetails:(NSString *)details andUserid:(NSString *)userid andappointmentid:(NSString *)appointmentid {
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        const char *sqlDB = "Insert into notification(userid,notificationid,appointmentid,details) VALUES (?,?,?,?)";
        
        if(sqlite3_prepare_v2(database, sqlDB, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_bind_text(addStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [notificationid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [appointmentid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [details UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        
        
        sqlite3_reset(addStmt);
        sqlite3_close(database);
        
    }
}


- (void) insertInUseravailTableWithTag:(NSString *)Tag andDate:(NSString *)date andday:(NSString *)day andFromTime:(NSString *)fromTime andToTime:(NSString *)toTime andisON:(NSString *)isON {
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        const char *sqlDB = "Insert into useravail(Tag,date,day,fromTime,toTime,isON) VALUES (?,?,?,?,?,?)";
        
        if(sqlite3_prepare_v2(database, sqlDB, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_bind_text(addStmt, 1, [Tag UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [day UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [fromTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 5, [toTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [isON UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        
        
        sqlite3_reset(addStmt);
        sqlite3_close(database);
        
    }
}


- (void) insertInETATableWithUserId:(NSString *)userid andAppointmentId:(NSString *)appointmentId andToid:(NSString *)toid andPushtype:(NSString *)pushtype andDate:(NSString *)date andTime:(NSString *)time andIsSend:(NSString *)isSend{
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        addStmt = nil;
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        if(addStmt == nil) {
            
            const char *sqlDB = "Insert into eta(userid,appointmentId,toid,pushtype,date,time,isSend) VALUES (?,?,?,?,?,?,?)";
            
            
            if(sqlite3_prepare_v2(database, sqlDB, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            
            sqlite3_close(database);
            
        }
        
        
        sqlite3_bind_text(addStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [appointmentId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [toid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [pushtype UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 5, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [time UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 7, [isSend UTF8String], -1, SQLITE_TRANSIENT);
        
        
        if(sqlite3_step(addStmt)!= SQLITE_DONE){
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        
        
        sqlite3_reset(addStmt);
        sqlite3_finalize(addStmt);
        sqlite3_close(database);
        
    }
    
}


#pragma mark - Update tables

- (void) UpdateMeetingTableWithAppointmentId:(NSString *)appointmentId andEventId:(NSString *)eventId{
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        NSString *query = [NSString stringWithFormat:@"UPDATE meeting SET eventId = %@ WHERE appointmentId = %@",eventId,appointmentId];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK)
        {
            
            NSLog(@"error: %s", sqlite3_errmsg(database));
            
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSLog(@"error: %s", sqlite3_errmsg(database));
            }
            else
            {
                NSLog(@"update SUCCESS - executed command %@",query);
            }
            sqlite3_reset(statement);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            // sqlite3_finalize(statement);
        }
        else
            NSLog(@"error: %s", sqlite3_errmsg(database));
        
        
        sqlite3_reset(addStmt);
        sqlite3_close(database);
        
    }
    
}


- (void) UpdateUseravailTableWithTag:(NSString *)Tag andDate:(NSString *)date andday:(NSString *)day andFromTime:(NSString *)fromTime andToTime:(NSString *)toTime andisON:(NSString *)isON {
    
    NSString *dbPath = [self getDBPath];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        NSString *query = [NSString stringWithFormat:@"UPDATE useravail SET date = \"%@\",day = \"%@\",fromTime = \"%@\",toTime = \"%@\",isON = \"%@\" WHERE Tag = \"%@\"",date,day,fromTime,toTime,isON,Tag];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
            
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSLog(@"error: %s", sqlite3_errmsg(database));
            }
            else
            {
                NSLog(@"update SUCCESS - executed command %@",query);
            }
            sqlite3_reset(statement);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            // sqlite3_finalize(statement);
        }
        else
            NSLog(@"error: %s", sqlite3_errmsg(database));
        
        
        sqlite3_reset(addStmt);
        sqlite3_close(database);
        
    }

}


- (void) UpdateETATableWithUserId:(NSString *)userid andAppointmentId:(NSString *)appointmentId andToid:(NSString *)toid andPushtype:(NSString *)pushtype andDate:(NSString *)date andTime:(NSString *)time andIsSend:(NSString *)isSend{
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"Opened sqlite database at %@", dbPath);
        
        NSString *query = [NSString stringWithFormat:@"UPDATE eta SET userid = \"%@\",toid = \"%@\",pushtype = \"%@\",date = \"%@\",time = \"%@\",isSend = \"%@\" WHERE appointmentId = \"%@\"",userid,toid,pushtype,date,time,isSend,appointmentId];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK)
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
            
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSLog(@"error: %s", sqlite3_errmsg(database));
            }
            else
            {
                NSLog(@"update SUCCESS - executed command %@",query);
            }
            sqlite3_reset(statement);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            // sqlite3_finalize(statement);
        }
        else
            NSLog(@"error: %s", sqlite3_errmsg(database));
        
        
        sqlite3_close(database);
        
    }
    
}


#pragma mark - Select tables

- (NSMutableArray*)getUser
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {

        const char *sql = "SELECT * FROM user";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *userid = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 1)] : nil;
                
                NSString *username = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 2)] : nil;
                
                NSString *password = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 3)] : nil;
                
                NSString *usertype = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 4)] : nil;
                
                NSString *status = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 5)] : nil;
                
                NSString *department = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 6)] : nil;
                
                NSString *designation = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 7)] : nil;
                
                NSString *email = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 8)] : nil;
                
                NSString *fname = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 9)] : nil;
                
                NSString *lname = ((char *)sqlite3_column_text(statement, 1)) ?
                [NSString stringWithUTF8String:
                 (char *)sqlite3_column_text(statement, 10)] : nil;
                
                if ([userid length]>0) {
                    
                    [dataStored setObject:userid forKey:@"userid"];
                }
                
                if ([username length]>0) {
                    
                    [dataStored setObject:username forKey:@"username"];
                }
                
                if ([password length]>0) {
                    
                    [dataStored setObject:password forKey:@"password"];
                }
                
                if ([usertype length]>0) {
                    
                    [dataStored setObject:usertype forKey:@"usertype"];
                }
                
                if ([usertype length]>0) {
                    
                    [dataStored setObject:usertype forKey:@"usertype"];
                }
                
                if ([usertype length]>0) {
                    
                    [dataStored setObject:usertype forKey:@"usertype"];
                }
                
                if ([status length]>0) {
                    
                    [dataStored setObject:status forKey:@"status"];
                }
                
                if ([department length]>0) {
                    
                    [dataStored setObject:department forKey:@"department"];
                }
                
                if ([designation length]>0) {
                    
                    [dataStored setObject:designation forKey:@"designation"];
                }
                
                if ([email length]>0) {
                    
                    [dataStored setObject:email forKey:@"email"];
                }
                
                if ([fname length]>0) {
                    
                    [dataStored setObject:fname forKey:@"fname"];
                }
                
                if ([lname length]>0) {
                    
                    [dataStored setObject:lname forKey:@"lname"];
                }
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}


- (NSMutableArray*)getMeetings
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = "SELECT * FROM meeting";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *appointmentId =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *employeeId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *employeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *employeeEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *employeePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                NSString *appointmentTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *duration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                NSString *agenda = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                NSString *fdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                NSString *sdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                NSString *appointmentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                NSString *readStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                
                NSString *otp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                NSString *eventId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                [dataStored setObject:appointmentId forKey:@"appointmentId"];
                [dataStored setObject:employeeId forKey:@"employeeId"];
                [dataStored setObject:employeeName forKey:@"employeeName"];
                [dataStored setObject:employeeEmail forKey:@"employeeEmail"];
                [dataStored setObject:employeePhone forKey:@"employeePhone"];
                [dataStored setObject:department forKey:@"department"];
                [dataStored setObject:appointmentTime forKey:@"appointmentTime"];
                [dataStored setObject:duration forKey:@"duration"];
                [dataStored setObject:agenda forKey:@"agenda"];
                [dataStored setObject:fdate forKey:@"fdate"];
                [dataStored setObject:sdate forKey:@"sdate"];
                [dataStored setObject:appointmentType forKey:@"appointmentType"];
                [dataStored setObject:readStatus forKey:@"readStatus"];
                [dataStored setObject:status forKey:@"status"];
                [dataStored setObject:otp forKey:@"otp"];
                [dataStored setObject:eventId forKey:@"eventId"];
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}


- (NSMutableArray*)getMeetingsById:(NSString *)Id
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM meeting WHERE appointmentId=%@",Id];
        
        const char *sql = [queryStr UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *appointmentId =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *employeeId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *employeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *employeeEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *employeePhone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                NSString *appointmentTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *duration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                NSString *agenda = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                NSString *fdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                NSString *sdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                NSString *appointmentType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                NSString *readStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                
                NSString *otp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                NSString *eventId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                [dataStored setObject:appointmentId forKey:@"appointmentId"];
                [dataStored setObject:employeeId forKey:@"employeeId"];
                [dataStored setObject:employeeName forKey:@"employeeName"];
                [dataStored setObject:employeeEmail forKey:@"employeeEmail"];
                [dataStored setObject:employeePhone forKey:@"employeePhone"];
                [dataStored setObject:department forKey:@"department"];
                [dataStored setObject:appointmentTime forKey:@"appointmentTime"];
                [dataStored setObject:duration forKey:@"duration"];
                [dataStored setObject:agenda forKey:@"agenda"];
                [dataStored setObject:fdate forKey:@"fdate"];
                [dataStored setObject:sdate forKey:@"sdate"];
                [dataStored setObject:appointmentType forKey:@"appointmentType"];
                [dataStored setObject:readStatus forKey:@"readStatus"];
                [dataStored setObject:status forKey:@"status"];
                [dataStored setObject:otp forKey:@"otp"];
                [dataStored setObject:eventId forKey:@"eventId"];
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}


- (NSMutableArray*)getNotifications
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {

        const char *sql = "SELECT * FROM notification";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *userid =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *notificationid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *appointmentid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *details = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                [dataStored setObject:userid forKey:@"userid"];
                [dataStored setObject:notificationid forKey:@"notificationid"];
                [dataStored setObject:appointmentid forKey:@"appointmentid"];
                [dataStored setObject:details forKey:@"details"];
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}


- (NSMutableArray*)getUseravail
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = "SELECT * FROM useravail";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *Tag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *day = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *fromTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *toTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *isON = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                [dataStored setObject:Tag forKey:@"Tag"];
                [dataStored setObject:date forKey:@"date"];
                [dataStored setObject:day forKey:@"day"];
                [dataStored setObject:fromTime forKey:@"fromTime"];
                [dataStored setObject:toTime forKey:@"toTime"];
                [dataStored setObject:isON forKey:@"isON"];
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}


- (NSMutableArray*)getETA
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        const char *sql = "SELECT * FROM eta";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *userid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *appointmentId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *toid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *pushtype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                NSString *isSend = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                [dataStored setObject:userid forKey:@"userid"];
                [dataStored setObject:appointmentId forKey:@"appointmentId"];
                [dataStored setObject:toid forKey:@"toid"];
                [dataStored setObject:pushtype forKey:@"pushtype"];
                [dataStored setObject:date forKey:@"date"];
                [dataStored setObject:time forKey:@"time"];
                [dataStored setObject:isSend forKey:@"isSend"];
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}

- (NSMutableArray*)getETAbyAppointmentId:(NSString *)appointmentId andPushtype:(NSString *)pushtype
{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM eta WHERE appointmentId=\"%@\" AND pushtype=\"%@\"",appointmentId,pushtype];
        
        const char *sql = [query UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *userid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *appointmentId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *toid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *pushtype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *time = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                NSString *isSend = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                [dataStored setObject:userid forKey:@"userid"];
                [dataStored setObject:appointmentId forKey:@"appointmentId"];
                [dataStored setObject:toid forKey:@"toid"];
                [dataStored setObject:pushtype forKey:@"pushtype"];
                [dataStored setObject:date forKey:@"date"];
                [dataStored setObject:time forKey:@"time"];
                [dataStored setObject:isSend forKey:@"isSend"];
                
                
                [dataArray addObject:[dataStored copy]];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return dataArray;
}

- (BOOL)iftableExists:(NSString *)tableName
{
    NSString *dbPath = [self getDBPath];
    
    bool isExist = FALSE;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",tableName];
        
        const char *sql = [queryStr UTF8String];
        
        sqlite3_stmt *statement;
        
        sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            isExist = TRUE;
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
    return isExist;
}


#pragma mark - Delete tables

- (void) deleteAllUsers
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            const char *sql = "DELETE FROM user";
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}

- (void) deleteAllNotifications
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            const char *sql = "DELETE FROM notification";
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                          sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}

- (void) deleteAllUserAvailTimes
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            const char *sql = "DELETE FROM useravail";
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                          sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}

- (void) deleteNotificationwithID:(NSString *)iD
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM notification WHERE notificationid=%@",iD];
            
            const char *sql = [deleteQuery UTF8String];
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                          sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}


- (void) deleteAllETA
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            const char *sql = "DELETE FROM eta";
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                          sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}


- (void) deleteETAByAppointmentId:(NSString *)appointmentId
{
    NSString *dbPath = [self getDBPath];
    
    sqlite3_stmt *delete_statment = nil;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        if (delete_statment == nil) {
            
            NSString *query = [NSString stringWithFormat:@"DELETE FROM eta WHERE appointmentId=\"%@\"",appointmentId];
            
            const char *sql = [query UTF8String];
            
            if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK) {
                
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.",
                          
                          sqlite3_errmsg(database));
            }
        }
        
        int success = sqlite3_step(delete_statment);
        
        if (success != SQLITE_DONE) {
            
            NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
            
        } else {
            
            sqlite3_reset(delete_statment);
        }
    }
    
    sqlite3_close(database);
}


@end
