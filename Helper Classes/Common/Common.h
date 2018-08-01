//
//  Common.h
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "LocationManager.h"

@class LocationManager;

@protocol sharedCommonDelegate

@optional

//-(void)enterZoneWithZoneName:(NSString *)zoneName;
//-(void)exitZoneWithZoneName:(NSString *)zoneName;

- (void)getArrayOfUpcommingMeeting:(NSArray *)UpcommingMeetingsArr;

@end

@interface Common : NSObject
{
    NSString *userId;
    NSDictionary *userDict;
}
@property(strong,nonatomic) LocationManager *shareModel;
@property (nonatomic, strong) NSArray* meetingsArr;
@property (nonatomic, strong) NSArray* todaysMeetings;
@property (nonatomic, strong) id <sharedCommonDelegate> delegate;

+(Common *) sharedCommonManager;

-(void)getUpcomingMeetings;

-(void)sendPushEmployee:(NSString *)appid withBody:(NSString *)body;

-(void)sendPushGuest:(NSString *)appid withBody:(NSString *)body;
- (NSArray *)getTodaysMeetings;
- (NSDictionary *)meetingDetailsForCurrentMeetings;
- (BOOL)hasAnyMeetingBetweenTwoHours;

@end
