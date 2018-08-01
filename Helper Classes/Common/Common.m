//
//  Common.m
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "Common.h"

static Common *sharedCommon = nil;

@implementation Common

+(Common *) sharedCommonManager {
    
    @synchronized([Common class])
    {
        if (!sharedCommon) {
            
            sharedCommon = [[self alloc] init];
            
        }
        
        return sharedCommon;
    }
    
    return nil;
    
}

-(NSString *)routineFilePath {
    
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
    NSString* docsDir = [dirPaths objectAtIndex:0];
    NSString* newDir = [docsDir stringByAppendingPathComponent:@"@TCS Folder"];
    NSString* fileName = @"@TCS.json";
    NSString* fileAtPath = [newDir stringByAppendingPathComponent:fileName];
    
    return fileAtPath;
}

- (void)writeStringToFile:(NSString*)aString {
    
    NSString* fileAtPath = [self routineFilePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}


- (NSString*)readStringFromFile {
    
    NSString *strJson = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[self routineFilePath]] encoding:NSUTF8StringEncoding];
    
    return strJson;
}


- (NSDictionary *)JSONFromFile
{
    NSData *data = [NSData dataWithContentsOfFile:[self routineFilePath]];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


-(void)sendPushEmployee:(NSString *)appid withBody:(NSString *)body{
    
    // [SVProgressHUD show];
    
    if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
        
    }
    
    NSDictionary *params;
    
    params = @{@"userid":userId,@"appid":appid,@"body":body};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@customepush_employee.php",BASE_URL];
    
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            //  [SVProgressHUD dismiss];
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
           // [SVProgressHUD dismiss];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
        
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
        
    }];
    
}


-(void)sendPushGuest:(NSString *)appid withBody:(NSString *)body{
    
    // [SVProgressHUD show];
    
    if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
        
    }
    
    NSDictionary *params;
    
    params = @{@"userid":userId,@"appid":appid,@"body":body};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@customepush_guest.php",BASE_URL];
    
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            //  [SVProgressHUD dismiss];
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
           // [SVProgressHUD dismiss];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       // [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
        
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
        
    }];
    
}


-(void)getUpcomingMeetings
{
    if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
        
    }
    
    if ([userId length]>0) {
        
        //[SVProgressHUD show];
        
        NSDictionary *params = @{@"userid":userId};
        
        NSString *host_url = [NSString stringWithFormat:@"%@upcoming_appointments.php",BASE_URL];
        
        NSLog(@"params : %@",params);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary *responseDict = responseObject;
            
            NSString *success = [responseDict objectForKey:@"status"];
            
            if ([success isEqualToString:@"success"]) {
                
                //[SVProgressHUD dismiss];
                
                self.meetingsArr = [responseDict objectForKey:@"apointments"];
                
                if ([self.meetingsArr count]>0) {
                    
                    self.shareModel = [LocationManager sharedManager];
                    self.shareModel.afterResume = YES;
                    
                    [self.shareModel restartMonitoringLocation];
                    
                }
                else
                {
                    self.shareModel = [LocationManager sharedManager];
                    self.shareModel.afterResume = NO;
                    
                    [self.shareModel stopMonitoringLocation];
                    
                }
                
                //NSLog(@"meetingsArr: %@", meetingsArr);
                
            }else{
                
            }
            
            if (self.delegate) {
                
                [self.delegate getArrayOfUpcommingMeeting:self.meetingsArr];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];
        
    }
    
}


- (void)setTodaysMeetings:(NSArray *)todaysMeetings {
    
    NSMutableArray* meetings = [NSMutableArray array];
    
    for (NSDictionary* dic in todaysMeetings) {
        
        NSMutableDictionary* dicMet = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        NSString *ftString = [dicMet objectForKey:@"fromtime"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        
        NSDate* dat=[df dateFromString:ftString];
        
        
        [dicMet setObject:dat forKey:@"fromtime24"];
        
        NSString *toString = [dicMet objectForKey:@"totime"];
        dat=[df dateFromString:toString];
        
        
        [dicMet setObject:dat forKey:@"totime24"];
        
        [meetings addObject:(NSDictionary *)dicMet];
        
    }
    
    _todaysMeetings = (NSArray *)meetings;
    
}


- (NSArray *)getTodaysMeetings {
    
    self.todaysMeetings = [NSMutableArray arrayWithArray:self.meetingsArr];
    
    if ([self.todaysMeetings count]>0) {
        
        NSDate *hourAgo = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        
        NSString* str = [df stringFromDate:hourAgo];
        
        NSDate* currentTime = [df dateFromString:str];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((%@ >= fromtime24 AND %@ <= totime24) OR (%@ <= fromtime24))",currentTime,currentTime,currentTime];
        
        NSArray *currentMeetings = [self.todaysMeetings filteredArrayUsingPredicate:predicate];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fromtime24" ascending:YES];
        
        NSArray* sortedArray=[currentMeetings sortedArrayUsingDescriptors:@[sort]];
        
        
        return sortedArray;
        
    } else {
        
        return nil;
    }
    
}


- (NSDictionary *)meetingDetailsForCurrentMeetings {
    
    self.todaysMeetings = [NSMutableArray arrayWithArray:self.meetingsArr];
    
    NSDictionary* dicCurrentMeeting;
    
    NSDate *hourAgo = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    NSString* str = [df stringFromDate:hourAgo];
    
    NSDate* currentTime = [df dateFromString:str];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((%@ >= fromtime24 AND %@ <= totime24) OR (%@ <= fromtime24))",currentTime,currentTime,currentTime];
    
    NSArray *currentMeetings = [self.todaysMeetings filteredArrayUsingPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fromtime24" ascending:YES];
    
    NSArray* sortedArray=[currentMeetings sortedArrayUsingDescriptors:@[sort]];
    
    if ([sortedArray count]) {
        
        dicCurrentMeeting = [sortedArray firstObject];
        
    } else {
        
        dicCurrentMeeting = nil;
    }
    
    return dicCurrentMeeting;
    
}


- (BOOL)hasAnyMeetingBetweenTwoHours {
    
    NSDate *hourAgo = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    NSString* str = [df stringFromDate:hourAgo];
    NSDate* currentTime = [df dateFromString:str];
    
    NSDictionary* dicCurrentMeeting = [self meetingDetailsForCurrentMeetings];
    
    if (dicCurrentMeeting!=nil) {
        
        NSDate* fromDate24 = [dicCurrentMeeting objectForKey:@"fromtime24"];
        NSDate* toDate24 = [dicCurrentMeeting objectForKey:@"totime24"];
        
        if (([currentTime timeIntervalSinceDate:fromDate24] >= 0  && [currentTime timeIntervalSinceDate:toDate24] <= 0) || ([fromDate24 timeIntervalSinceDate:currentTime] <= 3600*2)) {
            
            return YES;
            
        } else {
            
            return NO;
        }
        
    } else {
        
        return NO;
    }
    
}


@end
