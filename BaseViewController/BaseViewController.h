//
//  BaseViewController.h
//  @TCS
//
//  Created by FNSPL on 20/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ZoneDetection.h"
#import "MapPin.h"
#import "Common.h"
#import "KxMenu.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIColor+HexString.h"
#import "LocationManager.h"
#import "JJMaterialTextfield.h"
#import <UserNotifications/UserNotifications.h>

@interface BaseViewController : UIViewController<UNUserNotificationCenterDelegate>

- (IBAction)btnDrawerMenuDidTap:(id)sender;

@end
