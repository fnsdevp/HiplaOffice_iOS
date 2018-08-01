//
//  Database.h
//  SmartOffice
//
//  Created by FNSPL on 18/03/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject

+(Database *) sharedDB;

-(void) createdb;
-(void)createUserTable;
-(void)createMeetingTable;
-(void)createNotificationTable;
-(void)createETATrack;
-(NSString *) getDBPath;

#pragma mark - Insert tables

- (void) insertInUserTableWithUsername:(NSString *)username andPassword:(NSString *)password andUserid:(NSString *)userid andUsertype:(NSString *)usertype andStatus:(NSString *)status andDepartment:(NSString *)department andDesignation:(NSString *)designation andEmail:(NSString *)email andFname:(NSString *)fname anLname:(NSString *)lname;

- (void) insertInMeetingTableWithAppointmentId:(NSString *)appointmentId andEmployeeId:(NSString *)employeeId andEmployeeName:(NSString *)employeeName andEmployeeEmail:(NSString *)employeeEmail andEmployeePhone:(NSString *)employeePhone andDepartment:(NSString *)department andAppointmentTime:(NSString *)appointmentTime anDuration:(NSString *)duration anAgenda:(NSString *)agenda andFdate:(NSString *)fdate anSdate:(NSString *)sdate andAppointmentType:(NSString *)appointmentType andReadStatus:(NSString *)readStatus andStatus:(NSString *)status andOtp:(NSString *)otp andEventId:(NSString *)eventId;

- (void) insertInNotificationTableWithNotificationid:(NSString *)notificationid anDetails:(NSString *)details andUserid:(NSString *)userid andappointmentid:(NSString *)appointmentid;

- (void) insertInUseravailTableWithTag:(NSString *)Tag andDate:(NSString *)date andday:(NSString *)day andFromTime:(NSString *)fromTime andToTime:(NSString *)toTime andisON:(NSString *)isON;

- (void) insertInETATableWithUserId:(NSString *)userid andAppointmentId:(NSString *)appointmentId andToid:(NSString *)toid andPushtype:(NSString *)pushtype andDate:(NSString *)date andTime:(NSString *)time andIsSend:(NSString *)isSend;

#pragma mark - Update tables

- (void) UpdateMeetingTableWithAppointmentId:(NSString *)appointmentId andEventId:(NSString *)eventId;

- (void) UpdateUseravailTableWithTag:(NSString *)Tag andDate:(NSString *)date andday:(NSString *)day andFromTime:(NSString *)fromTime andToTime:(NSString *)toTime andisON:(NSString *)isON;

- (void) UpdateETATableWithUserId:(NSString *)userid andAppointmentId:(NSString *)appointmentId andToid:(NSString *)toid andPushtype:(NSString *)pushtype andDate:(NSString *)date andTime:(NSString *)time andIsSend:(NSString *)isSend;

#pragma mark - Select tables

- (NSMutableArray*) getUser;
- (NSMutableArray*) getMeetings;
- (NSMutableArray*) getMeetingsById:(NSString *)Id;
- (NSMutableArray*) getNotifications;
- (NSMutableArray*) getUseravail;
- (NSMutableArray*)getETA;
- (NSMutableArray*)getETAbyAppointmentId:(NSString *)appointmentId andPushtype:(NSString *)pushtype;

#pragma mark - Delete tables

- (void) deleteAllUsers;
- (void) deleteAllNotifications;
- (void) deleteAllUserAvailTimes;
- (void) deleteNotificationwithID:(NSString *)iD;
- (void) deleteAllETA;
- (void) deleteETAByAppointmentId:(NSString *)appointmentId;

@end
