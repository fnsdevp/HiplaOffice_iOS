//
//  NotificationViewController.h
//  @TCS
//
//  Created by FNSPL on 07/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//


#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate,sharedCommonDelegate>{
    
    NSString * strAddress;
    NSString *notificationAddress;
}

@end


@implementation LocationManager

//Class method to make sure the share model is synch across the app

+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


#pragma mark - CLLocationManager

- (void)startMonitoringLocation {
    
    db = [Database sharedDB];
    
    self.objcommon = [Common sharedCommonManager];
    
    self.objcommon.delegate = self;
    
    self.arrMeetings = [NSMutableArray arrayWithArray:self.objcommon.meetingsArr];
    
    [Userdefaults setObject:@"YES" forKey:@"arrAvailable"];
    
    [Userdefaults synchronize];
    
    [self getNearestUpcomingMeeting];
    
    // [self.objcommon getUpcomingMeetings];
    
    if (_anotherLocationManager)
        [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    
    [_anotherLocationManager startUpdatingLocation];
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
    
    self.anotherLocationManager.allowsBackgroundLocationUpdates = YES;
    //    }
    
    [_anotherLocationManager startMonitoringSignificantLocationChanges];
}

- (void)restartMonitoringLocation {
    
    [self stopMonitoringLocation];
    
    [self startMonitoringLocation];
}

- (void)stopMonitoringLocation {
    
    [_anotherLocationManager stopUpdatingLocation];
    
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - sharedCommonDelegate

- (void)getArrayOfUpcommingMeeting:(NSArray *)UpcommingMeetingsArr
{
    //  [SVProgressHUD dismiss];
    
    if ([UpcommingMeetingsArr count]>0) {
        
        self.arrMeetings = [NSMutableArray arrayWithArray:UpcommingMeetingsArr];
        
        [Userdefaults setObject:@"YES" forKey:@"arrAvailable"];
        
        [Userdefaults synchronize];
        
        [self restartMonitoringLocation];
    }
    
}


- (void)getNearestUpcomingMeeting{
    
    if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
    {
        currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
        NSLog(@"%@",currentMeeting);
        fromTime = [currentMeeting objectForKey:@"fromtime"];
    }
    
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations: %@",locations);
    
    if ([locations count]>0) {
        
        for (int i = 0; i < locations.count; i++) {
            
            CLLocation * newLocation = [locations objectAtIndex:i];
            CLLocationCoordinate2D theLocation = newLocation.coordinate;
            CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
            
            self.myLocation = theLocation;
            self.myLocationAccuracy = theAccuracy;
            
        }
        
        
        //NEW CODE
        
        NSDate *hourAgo = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        
        NSString* str = [df stringFromDate:hourAgo];
        NSDate* date1 = [df dateFromString:str];
        
        
        
        
        NSDate* date2=[df dateFromString:fromTime];
        
        
        NSComparisonResult result = [date1 compare:date2];
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *arrAvailable = [Userdefaults objectForKey:@"arrAvailable"];
        
        
        if (fromTime!=nil){
            
            if(result == NSOrderedDescending)
            {
                
                [_anotherLocationManager stopUpdatingLocation];
                
            }
            else if(result == NSOrderedAscending)
            {
                NSLog(@"date2 is later than date1");
                
                BOOL GetDistanceFired = [Userdefaults boolForKey:@"GetDistanceFired"];
                
                
                //                if (GetDistanceFired==NO) {
                //
                //                    //                    [self performSelector:@selector(GetDistance:) withObject:self.anotherLocationManager.location afterDelay:1.0];
                //                    [self performSelector:@selector(GetDistance:) withObject:self.anotherLocationManager.location];
                //
                //                    [Userdefaults setBool:YES forKey:@"GetDistanceFired"];
                //
                //                    [Userdefaults synchronize];
                //
                //                }
                
                [self performSelector:@selector(GetDistance:) withObject:self.anotherLocationManager.location];
                // [self GetDistance:self.anotherLocationManager.location];
                
                
                if (dist>0) {
                    
                    if(dist < 100)
                    {
                        [self checkUserArrivedOfficeOnMeetingTime:self.anotherLocationManager.location];
                        
                        NSDictionary* currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                        
                        BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
                        
                        if  (within400Meter){
                            
                            BOOL lessThan400Meter = [Userdefaults boolForKey:@"lessThan400Meter"];
                            
                            if  (lessThan400Meter==NO){
                                
                                NSString *usertype = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
                                
                                if (![usertype isEqualToString:@"Employee"]) {
                                    
                                    NSString *strNotif = @"Welcome to Future Netwings. Connect to local wifi to gain access control.";
                                    
                                    [Userdefaults setBool:YES forKey:@"stopETA"];
                                    //                                     [Userdefaults setBool:YES forKey:@"stopETA"];
                                    [self startLocalNotification:strNotif];
                                    
                                    
                                    NSString *strPushName = [NSString stringWithFormat:@"%@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
                                    
                                    NSString *strPush = [NSString stringWithFormat:@"%@ has arrived at your campus.",strPushName];
                                    
                                    NSString *strPushAppID = [NSString stringWithFormat:@"%@",[currentMeeting objectForKey:@"id"]];
                                    
                                    [[Common sharedCommonManager] sendPushEmployee:strPushAppID withBody:strPush];
                                    
                                    [Userdefaults setBool:YES forKey:@"lessThan400Meter"];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        } else {
                            
                            //[self fireControl];
                        }
                        
                        [Userdefaults setBool:YES forKey:@"within400Meter"];
                        
                        [Userdefaults synchronize];
                        
                    }
                    else if (dist>100)
                    {
                        NSDictionary* currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                        
                        [Userdefaults setBool:NO forKey:@"within400Meter"];
                        
                        [Userdefaults synchronize];
                        
                        if (dist<800)
                        {
                            BOOL within800To400Meter = [Userdefaults boolForKey:@"within800To400Meter"];
                            
                            if  (within800To400Meter==NO){
                                
                                NSString *usertype = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
                                
                                if (![usertype isEqualToString:@"Employee"]) {
                                    
                                    NSString *strNotif = @"You are about to reach your destination.";
                                    
                                    [self startLocalNotification:strNotif];
                                    
                                    NSString *strPushName = [NSString stringWithFormat:@"%@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
                                    
                                    NSString *strPush = [NSString stringWithFormat:@"%@ is about to reach your campus.",strPushName];
                                    
                                    NSString *strPushAppID = [NSString stringWithFormat:@"%@",[currentMeeting objectForKey:@"id"]];
                                    
                                    [[Common sharedCommonManager] sendPushEmployee:strPushAppID withBody:strPush];
                                    
                                    
                                    [Userdefaults setBool:YES forKey:@"within800To400Meter"];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                NSDate *hourAgo = [NSDate date];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"hh:mm a"];
                
                NSString* str = [df stringFromDate:hourAgo];
                NSDate* date1 = [df dateFromString:str];
                NSDate* date2=[df dateFromString:fromTime];
                
                NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
                
                double time1 = [duration doubleValue];
                double time2 = secondsBetween/60;
                
                NSLog(@"time 1 is %f",time1);
                NSLog(@"time 2 is %f",time2);
                
                double diff = time2 - time1;
                
                if (time2>0 && time2<60){
                    
                if (time2 >time1){
                    // user is not late show ETA
                    
                    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
                    
                    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                    
                    NSString *usertype = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
                    
                    if (![usertype isEqualToString:@"Employee"]) {
                        
                        BOOL stopETA = [Userdefaults boolForKey:@"stopETA"];
                        
                        if ((dist>400) && (stopETA==NO)){
                            //                                if( [Userdefaults boolForKey:@"ETAFired"] ==NO){
                            
                            NSString *strDetails = [NSString stringWithFormat:@"You are about %@ from FNSPL, estimated time of arrival %@",distance,duration];
                            
                            [self checkAndSendNotificationforPushType:@"time of arrival" withDetails:self->currentMeeting AndNotificationText:strDetails];
                            
                            //                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                }else if(time1 == time2){
                    NSDictionary *dict1 = [currentMeeting objectForKey:@"guest"];
                    //                        if( [Userdefaults boolForKey:@"stepOut"] == NO  && [Userdefaults boolForKey:@"stopETA"] ==NO){
                    
                    NSString *strDetails = [NSString stringWithFormat:@"You should step out now or you will be getting late for your meeting with %@.",[dict1 objectForKey:@"contact"]];
                    [Userdefaults setBool:YES forKey:@"stepOut"];
                    
                    
                    [self checkAndSendNotificationforPushType:@"step out" withDetails:currentMeeting AndNotificationText:strDetails];
                    
                    //                        }
                    
                    
                }else{
                    //User is late for the meeting
                    
                    NSDictionary *dict1 = [currentMeeting objectForKey:@"guest"];
                    
                    if( ([Userdefaults boolForKey:@"stopETA"] == NO) && (dist>100) && ([Userdefaults boolForKey:@"late"] == NO) ){
                        
                        NSString *strDetails = [NSString stringWithFormat:@"You are late for your meeting with %@, please reschedule the meeting.",[dict1 objectForKey:@"contact"]];
//
                        [Userdefaults setBool:YES forKey:@"late"];
//                        [Userdefaults setBool:true forKey:@"reschedule"];
                        
                        
                        [self checkAndSendNotificationforPushType:@"late" withDetails:currentMeeting AndNotificationText:strDetails];
                        
                        
                        [_anotherLocationManager stopUpdatingLocation];
                        
                    }
                    
                }
                    
            }
                
                
                //                if ([Userdefaults boolForKey:@"isETAFiredOnce"]==YES) {
                //
                //                    NSLog(@"No ETA fire");
                //
                //
                //                } else {
                //
                //                    [Userdefaults setBool:YES forKey:@"isETAFiredOnce"];
                //                    [Userdefaults synchronize];
                //
                //                    [self performSelector:@selector(IsMeetingToday:) withObject:self.anotherLocationManager.location];
                //
                //                    //[self IsMeetingToday:_locationManager.location];
                //
                //
                //                }
                
                
            }
            else
            {
                NSLog(@"date1 is equal to date2");
            }
            
        }
        
    }
    
    
    //    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    //    localNotification.title = notificationAddress;
    
    //    localNotification.body = [NSString localizedUserNotificationStringForKey:@"Killed" arguments:nil];
    //    localNotification.sound = [UNNotificationSound defaultSound];
    //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    //
    //    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    //
    //    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
    //
    //    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    //        NSLog(@"Notification created");
    //    }];
    
}


-(void)checkUserArrivedOfficeOnMeetingTime:(CLLocation *)loc
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([Userdefaults objectForKey:@"ProfInfo"] != nil) {
            
            
            NSDate *hourAgo = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            
            NSString* str = [df stringFromDate:hourAgo];
            NSDate* date1 = [df dateFromString:str];
            
            
            
            
            NSDate* date2=[df dateFromString:self->fromTime];
            
            
            NSComparisonResult result = [date1 compare:date2];
            
            self->userDict = [Userdefaults objectForKey:@"ProfInfo"];
            
            NSString *arrAvailable = [Userdefaults objectForKey:@"arrAvailable"];
            
            
            if (self->fromTime!=nil){
                
                if(result == NSOrderedDescending)
                {
                    NSLog(@"date1 is later than date2");
                }
                else if(result == NSOrderedAscending){
                    
                    
                    for (NSDictionary *dict in self.arrMeetings) {
                        
                        NSString *statusStr = [dict objectForKey:@"status"];
                        
                        if ([statusStr isEqualToString:@"confirm"]) {
                            
                            NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                            
                            [dt setDateFormat:@"yyyy-MM-dd"];
                            
                            NSDate *currentDate = [dt dateFromString:[dt stringFromDate:[NSDate date]]];
                            
                            NSDate *fromDate = [dt dateFromString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]]];
                            
                            NSComparisonResult compare = [currentDate compare:fromDate];
                            
                            if (compare==NSOrderedSame) {
                                
                                NSString *time = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fromtime"]];
                                
                                //NSString *dateString = [NSString stringWithFormat:@"%@ %@",Fdate,time];
                                
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                
                                [dateFormatter setDateFormat:@"hh:mm a"];
                                
                                NSDate *Date = [dateFormatter dateFromString:time];
                                
                                [dateFormatter setDateFormat:@"HH:mm"];
                                
                                NSString *dateString = [dateFormatter stringFromDate:Date];
                                
                                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                                
                                [dateFormatter setLocale:locale];
                                
                                NSDate *dateFromString = [dateFormatter dateFromString:dateString];
                                
                                NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                                
                                NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:currentDate];
                                
                                int minutes = secondsBetween / 60;
                                
                                if (minutes<=10) {
                                    
                                    [Userdefaults setObject:currentDate forKey:@"DateRecorded"];
                                    
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"isReachedOfficeForAppId:%@",[dict objectForKey:@"id"]]];
                                    
                                    [Userdefaults synchronize];
                                    
                                }
                            }
                        }
                    }
                    
                }else{
                    
                    
                    
                }
                
                
                
            }
            
            
        }
        
    });
}


-(void)IsMeetingToday:(CLLocation *)location
{
    
    
    NSDate *hourAgo = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    NSString* str = [df stringFromDate:hourAgo];
    NSDate* date1 = [df dateFromString:str];
    
    
    NSDate* date2=[df dateFromString:self->fromTime];
    
    
    NSComparisonResult result = [date1 compare:date2];
    
    self->userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *arrAvailable = [Userdefaults objectForKey:@"arrAvailable"];
    
    if (self->fromTime!=nil){
        
        if(result == NSOrderedDescending)
        {
            NSLog(@"date1 is later than date2");
        }
        else if(result == NSOrderedAscending){
            
            if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
            {
                self->currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                NSLog(@"%@",self->currentMeeting);
                self->fromTime = [self->currentMeeting objectForKey:@"fromtime"];
                
            }
            
            
            BOOL isReachedOffice = [Userdefaults boolForKey:[NSString stringWithFormat:@"isReachedOfficeForAppId:%@",[currentMeeting objectForKey:@"id"]]];
            
            if (isReachedOffice==false) {
                
                // [self checkETA:_locationManager.location];==
                
                [self performSelector:@selector(checkETA:) withObject:self.anotherLocationManager.location afterDelay:1.0];
                
                NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
                
                userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                
                NSString *usertype = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
                
                if (![usertype isEqualToString:@"Employee"]) {
                    
                    [self showETA];
                    
                }
                
                // [self reverseGeoCode:self.anotherLocationManager.location];
                
            }
        }
        
        
        
        
    }else{
        
        
        
    }
    
    
    
}




-(void)showETA_withTime{
    
    
    
    
    //NSString *time1 =
    
    
}


-(void)showETA
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f+%f&destinations=%@&key=%@",self.anotherLocationManager.location.coordinate.latitude,self.anotherLocationManager.location.coordinate.longitude,latLong,API_KEY];
    
    [manager GET:hostUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSArray *rows = [dict objectForKey:@"rows"];
        
        if ([rows count]>0) {
            
            NSDictionary *elements = [rows objectAtIndex:0];
            
            NSArray *details = [elements objectForKey:@"elements"];
            
            NSDictionary *ETAinfo = [details objectAtIndex:0];
            
            NSDictionary *distanceDic = [ETAinfo objectForKey:@"distance"];
            
            NSDictionary *durationDic = [ETAinfo objectForKey:@"duration"];
            
            NSString *Distance = [distanceDic objectForKey:@"text"];
            
            NSString *Duration = [durationDic objectForKey:@"text"];
            
            NSArray *arrUnit = [Distance componentsSeparatedByString:@" "];
            
            // [self checkETA:_locationManager.location];
            
            //  [self performSelector:@selector(checkETA:) withObject:_locationManager.location afterDelay:30.0];
            NSArray *arrDuration = [Duration componentsSeparatedByString:@" "];
            
            NSDate *hourAgo = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            
            NSString* str = [df stringFromDate:hourAgo];
            NSDate* date1 = [df dateFromString:str];
            
            
            
            
            NSDate* date2=[df dateFromString:self->fromTime];
            
            
            NSComparisonResult result = [date1 compare:date2];
            
            self->userDict = [Userdefaults objectForKey:@"ProfInfo"];
            
            NSString *arrAvailable = [Userdefaults objectForKey:@"arrAvailable"];
            
            
            if (self->fromTime!=nil){
                
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
                {
                    self->currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                    NSLog(@"%@",self->currentMeeting);
                    self->fromTime = [self->currentMeeting objectForKey:@"fromtime"];
                    
                }
                
                if(result == NSOrderedDescending)
                {
                    NSLog(@"date1 is later than date2");
                }
                else if(result == NSOrderedAscending)
                {
                    
                    
                    
                    BOOL isReachedOffice = [Userdefaults boolForKey:[NSString stringWithFormat:@"isReachedOfficeForAppId:%@",[self->currentMeeting objectForKey:@"id"]]];
                    
                    if (isReachedOffice==0) {
                        
                        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                        
                        [dt setDateFormat:@"yyyy-MM-dd"];
                        
                        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                        
                        [dt setLocale:locale];
                        
                        NSDate *currentDate = [dt dateFromString:[dt stringFromDate:[NSDate date]]];
                        
                        NSDate *fromDate = [dt dateFromString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]]];
                        
                        NSComparisonResult compare = [currentDate compare:fromDate];
                        
                        if (compare==NSOrderedSame) {
                            
                            //NSString *Fdate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
                            
                            NSString *time = [NSString stringWithFormat:@"%@",[self->currentMeeting objectForKey:@"fromtime"]];
                            
                            //NSString *dateString = [NSString stringWithFormat:@"%@ %@",Fdate,time];
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            
                            [dateFormatter setDateFormat:@"hh:mm a"];
                            
                            NSDate *date = [dateFormatter dateFromString:time];
                            
                            [dateFormatter setDateFormat:@"HH:mm"];
                            
                            NSString *dateString = [dateFormatter stringFromDate:date];
                            
                            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                            
                            [dateFormatter setLocale:locale];
                            
                            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                            
                            NSDate *dateFromString = [dateFormatter dateFromString:dateString];
                            
                            NSDate *currentTime= [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                            
                            
                            NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:currentTime];
                            
                            int minutes = secondsBetween / 60;
                            
                            if((minutes<=120) && (minutes>0))
                            {
                                BOOL within200Meter = [Userdefaults boolForKey:@"within400Meter"];
                                
                                if (within200Meter==NO)
                                {
                                    if ([arrUnit containsObject:@"m"]||[arrUnit containsObject:@"km"])
                                    {
                                        NSString *strDetails = [NSString stringWithFormat:@"You are about %@ from FNSPL, estimated time of arrival %@",Distance,Duration];
                                        
                                        [self checkAndSendNotificationforPushType:@"time of arrival" withDetails:self->currentMeeting AndNotificationText:strDetails];
                                    }
                                    else
                                    {
                                        int meter = (int)[[arrUnit objectAtIndex:0] integerValue];
                                        
                                        NSString *strDetails = [NSString stringWithFormat:@"You are about %f from FNSPL, estimated time of arrival %@",(meter *FEET_TO_METERS),Duration];
                                        
                                        [self checkAndSendNotificationforPushType:@"time of arrival" withDetails:self->currentMeeting AndNotificationText:strDetails];
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }else{
                    
                    
                    
                }
            }//
            
            
            
            //NSLog(@"distance: %@", distance);
            // NSLog(@"duration: %@", duration);
            
            [Userdefaults setBool:NO forKey:@"isETALoopFiredOnce"];
            [Userdefaults synchronize];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [Userdefaults setBool:NO forKey:@"isETALoopFiredOnce"];
        [Userdefaults synchronize];
        
    }];
    
    // https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=Washington,DC&destinations=New+York+City,NY&key=YOUR_API_KEY
    
}


-(void)checkETA:(CLLocation *)loc
{
    NSArray *arrDuration = [duration componentsSeparatedByString:@" "];
    
    NSDate *hourAgo = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    NSString* str = [df stringFromDate:hourAgo];
    NSDate* date1 = [df dateFromString:str];
    
    
    NSDate* date2=[df dateFromString:self->fromTime];
    
    
    NSComparisonResult result = [date1 compare:date2];
    
    self->userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *arrAvailable = [Userdefaults objectForKey:@"arrAvailable"];
    
    if (self->fromTime!=nil){
        
        if(result == NSOrderedDescending)
        {
            NSLog(@"date1 is later than date2");
        }
        else if(result == NSOrderedAscending){
            
            if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
            {
                currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                NSLog(@"%@",currentMeeting);
                fromTime = [currentMeeting objectForKey:@"fromtime"];
            }
            
            
            
            NSDateFormatter *dt = [[NSDateFormatter alloc] init];
            
            [dt setDateFormat:@"yyyy-MM-dd"];
            
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            
            [dt setLocale:locale];
            
            NSDate *currentDate = [dt dateFromString:[dt stringFromDate:[NSDate date]]];
            
            NSDate *fromDate = [dt dateFromString:[NSString stringWithFormat:@"%@",[currentMeeting objectForKey:@"fdate"]]];
            
            NSComparisonResult compare = [currentDate compare:fromDate];
            
            if (compare==NSOrderedSame) {
                
                //NSString *Fdate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
                
                NSString *time = [NSString stringWithFormat:@"%@",[currentMeeting objectForKey:@"fromtime"]];
                
                //NSString *dateString = [NSString stringWithFormat:@"%@ %@",Fdate,time];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"hh:mm a"];
                
                NSDate *date = [dateFormatter dateFromString:time];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                
                [dateFormatter setLocale:locale];
                
                [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                
                NSDate *dateFromString = [dateFormatter dateFromString:dateString];
                
                NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                
                
                NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:currentDate];
                
                int minutes = secondsBetween / 60;
                
                if (arrDuration == nil) {
                    
                    // [self reverseGeoCode:self.anotherLocationManager.location];
                    
                    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
                    
                    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                    
                    NSString *usertype = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
                    
                    if (![usertype isEqualToString:@"Employee"]) {
                        
                        [self showETA];
                        
                    }
                    
                }
                else
                {
                    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
                    
                    if (within400Meter==NO)
                    {
                        NSDictionary *dict1 = [currentMeeting objectForKey:@"guest"];
                        
                        int durationMin = (int)[[arrDuration objectAtIndex:0] integerValue];
                        
                        int div = (minutes - durationMin);
                        
                        //code static need to change
                        if(div >= 10  && div <= 15)
                        {
                            NSString *strDetails = [NSString stringWithFormat:@"You have to start planning to go to Future Netwings or you will be getting late for your meeting with %@.",[dict1 objectForKey:@"contact"]];
                            
                            [self checkAndSendNotificationforPushType:@"planning" withDetails:currentMeeting AndNotificationText:strDetails];
                            
                        }
                        else if (div >=3 && div < 10)
                        {
                            NSString *strDetails = [NSString stringWithFormat:@"You should step out now or you will be getting late for your meeting with %@.",[dict1 objectForKey:@"contact"]];
                            
                            [self checkAndSendNotificationforPushType:@"step out" withDetails:currentMeeting AndNotificationText:strDetails];
                        }
                        else if (div <3)
                        {
                            NSString *strDetails = [NSString stringWithFormat:@"You are late for your meeting with %@, please reschedule the meeting.",[dict1 objectForKey:@"contact"]];
                            
                            [self checkAndSendNotificationforPushType:@"late" withDetails:currentMeeting AndNotificationText:strDetails];
                            
                            NSString *strID = [NSString stringWithFormat:@"%@",[[dict1 objectForKey:@"guest"] objectForKey:@"id"]];
                            
                            [self.objcommon sendPushEmployee:strID withBody:[NSString stringWithFormat:@"%@ is late for the upcoming meeting with you. Please reschedule the meeting.",[dict1 objectForKey:@"employee_name"]]];
                        }
                        
                    }
                    
                }
                
            }
            
            
            
            
        }//
        else{
            
            
            
        }
        
        
        
    }
    
    
}


-(IBAction)startLocalNotification:(NSString *)str {
    
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    
    localNotification.title = notificationAddress;
    localNotification.body = [NSString localizedUserNotificationStringForKey:str arguments:nil];
    
    localNotification.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error){
        
        NSLog(@"Notification created");
        
    }];
    
}


-(void)checkAndSendNotificationforPushType:(NSString *)pushtype withDetails:(NSDictionary *)Dict AndNotificationText:(NSString *)strDetails
{
    NSString *strId = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
    
    NSMutableArray *arrETA = [db getETAbyAppointmentId:strId andPushtype:pushtype];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([arrETA count]>0) {
        
        NSString *isSendStr = [[arrETA objectAtIndex:0] objectForKey:@"isSend"];
        
        if ([isSendStr isEqualToString:@"YES"]) {
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            
            [dateFormatter setLocale:locale];
            
            NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
            
            NSDate *fromDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[arrETA objectAtIndex:0] objectForKey:@"date"]]];
            
            NSComparisonResult compare = [currentDate compare:fromDate];
            
            if (compare==NSOrderedSame){
                
                NSString *time = [NSString stringWithFormat:@"%@",[[arrETA objectAtIndex:0] objectForKey:@"time"]];
                
                //NSString *dateString = [NSString stringWithFormat:@"%@ %@",Fdate,time];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                
                NSDate *date = [dateFormatter dateFromString:time];
                
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                
                [dateFormatter setLocale:locale];
                
                [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                
                NSDate *dateFromString = [dateFormatter dateFromString:dateString];
                
                NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                
                
                NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:currentDate];
                
                int minutes = secondsBetween / 60;
                
                if (minutes > 0)
                {
                    minutes = minutes;
                }
                else if (minutes < 0)
                {
                    minutes = (0 - minutes);
                }
                
                if ([pushtype isEqualToString:@"late"]) {
                    
                    if (minutes>=2) {
                        
                        [self startLocalNotification:strDetails];
                        
                        // [objcommon sendPushLogforAppid:[Dict objectForKey:@"id"] andFromid:userId andToid:[Dict objectForKey:@"employee_id"] andPushType:pushtype];
                        
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString *cDateStr = [dateFormatter stringFromDate:[NSDate date]];
                        
                        [dateFormatter setDateFormat:@"HH:mm"];
                        
                        NSString *cTimeStr = [dateFormatter stringFromDate:[NSDate date]];
                        
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        
                        NSString *strId = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
                        
                        //NSNumber *myNumber = [f numberFromString:strId];
                        
                        if ([arrETA count]>0) {
                            
                            [db UpdateETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
                        }
                        else
                        {
                            [db insertInETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
                        }
                        
                    }
                }
                else
                {
                    if (minutes>=3) {
                        
                        [self startLocalNotification:strDetails];
                        
                        // [objcommon sendPushLogforAppid:[Dict objectForKey:@"id"] andFromid:userId andToid:[Dict objectForKey:@"employee_id"] andPushType:pushtype];
                        
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSString *cDateStr = [dateFormatter stringFromDate:[NSDate date]];
                        
                        [dateFormatter setDateFormat:@"HH:mm"];
                        
                        NSString *cTimeStr = [dateFormatter stringFromDate:[NSDate date]];
                        
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        
                        NSString *strId = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
                        
                        //NSNumber *myNumber = [f numberFromString:strId];
                        
                        if ([arrETA count]>0) {
                            
                            [db UpdateETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
                        }
                        else
                        {
                            [db insertInETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
                        }
                        
                    }
                }
            }
            
        }
        else
        {
            
            [self startLocalNotification:strDetails];
            
            // [objcommon sendPushLogforAppid:[Dict objectForKey:@"id"] andFromid:userId andToid:[Dict objectForKey:@"employee_id"] andPushType:pushtype];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString *cDateStr = [dateFormatter stringFromDate:[NSDate date]];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            NSString *cTimeStr = [dateFormatter stringFromDate:[NSDate date]];
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            
            f.numberStyle = NSNumberFormatterDecimalStyle;
            
            NSString *strId = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
            
            //NSNumber *myNumber = [f numberFromString:strId];
            
            if ([arrETA count]>0) {
                
                [db UpdateETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
            }
            else
            {
                [db insertInETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
            }
            
        }
        
    }
    else
    {
        [self startLocalNotification:strDetails];
        
        // [objcommon sendPushLogforAppid:[Dict objectForKey:@"id"] andFromid:userId andToid:[Dict objectForKey:@"employee_id"] andPushType:pushtype];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *cDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        
        NSString *cTimeStr = [dateFormatter stringFromDate:[NSDate date]];
        
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSString *strId = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"id"]];
        
        //NSNumber *myNumber = [f numberFromString:strId];
        
        [db insertInETATableWithUserId:userId andAppointmentId:strId andToid:[Dict objectForKey:@"employee_id"] andPushtype:pushtype andDate:cDateStr andTime:cTimeStr andIsSend:@"YES"];
        
    }
    
}


-(void)GetDistance:(CLLocation *)location
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f+%f&destinations=%@&key=%@",location.coordinate.latitude,location.coordinate.longitude,latLong,API_KEY];
    
    // 22.593484+88.434506
    //22.573075+88.452580 - future netwings
    //  NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=park+street,kolkata&destinations=future+netwings&key=%@",API_KEY];
    
    [manager GET:hostUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSArray *rows = [dict objectForKey:@"rows"];
        
        if ([rows count]>0) {
            
            NSDictionary *elements = [rows objectAtIndex:0];
            
            NSArray *details = [elements objectForKey:@"elements"];
            
            NSDictionary *ETAinfo = [details objectAtIndex:0];
            
            NSDictionary *distanceDic = [ETAinfo objectForKey:@"distance"];
            
            NSDictionary *durationDic = [ETAinfo objectForKey:@"duration"];
            
            self->distance = [distanceDic objectForKey:@"text"];
            
            self->duration = [durationDic objectForKey:@"text"];
            
            NSArray *arrUnit = [self->distance componentsSeparatedByString:@" "];
            NSArray *durUnit = [self->duration componentsSeparatedByString:@" "];
            if ([arrUnit count]>0) {
                
                NSString *addressStr = [arrUnit firstObject];
                NSString *durationStr = [durUnit firstObject];
                self->dist = [addressStr doubleValue];
                
                if ([arrUnit containsObject:@"km"]) {
                    
                    self->dist = self->dist *1000;
                    
                }
                if([durUnit count] >2){
                    
                    double hour = [[durUnit objectAtIndex:0] doubleValue];
                    double min = [[durUnit objectAtIndex:2] doubleValue];
                    self->dur = hour*60+min;
                    
                    
                }else{
                    if([durUnit containsObject:@"min"]){
                        self->dur = [durationStr doubleValue];
                    }
                }
            }
            
        }
        
        [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
        
        [Userdefaults synchronize];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
        
        [Userdefaults synchronize];
        
    }];
    
}


-(void)fireControl
{
    ControlPanelViewController *ctrlVC = [[ControlPanelViewController alloc] initWithNibName:@"ControlPanelViewController" bundle:nil];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:ctrlVC animated:YES];;
}


@end
