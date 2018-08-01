//
//  NotificationViewController.h
//  @TCS
//
//  Created by FNSPL on 07/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "Common.h"
#import "Database.h"
#import "ControlPanelViewController.h"

@class Common;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    Database *db;
    NSString *userId;
    double dist;
    double dur;
    NSString *distance;
    NSString *duration;
    NSDictionary *userDict;
    NSDictionary *currentMeeting;
    NSString *fromTime;
}
@property (nonatomic) CLLocationManager * anotherLocationManager;

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (nonatomic,assign) CLLocationCoordinate2D myLocation;
@property (nonatomic,assign) CLLocationAccuracy myLocationAccuracy;
@property (nonatomic, strong) NSMutableArray *arrMeetings;
@property (nonatomic, strong) Common *objcommon;

@property (nonatomic) BOOL afterResume;

+ (id)sharedManager;

- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)stopMonitoringLocation;

@end
