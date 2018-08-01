//
//  CustomTabBarController.h
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "RightSideDrawerViewController.h"
#import "MessageBoxViewController.h"
#import "DynamicUIAnimation.h"
#import "ControlPanelViewController.h"
#import "SplashViewController.h"
#import "DashBoardViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ProfileDetailViewController.h"
#import "AboutUsViewController.h"
#import "SetAvailabilityViewController.h"
#import "HotDeskViewController.h"
#import "ControlPanelViewController.h"

@class SplashViewController;
@class ControlPanelViewController;

@interface CustomTabBarController : UITabBarController
{
    UIButton *btn_Button;
    UIButton *btn_Button2;
    bool isBtnSelected;
    Database *db;
    
    MessageBoxViewController *inbox;
    SplashViewController *splash;
    
    RightSideDrawerViewController *drawer;
    ControlPanelViewController *ctrlVC;
    
    SetAvailabilityViewController *setAvailabilty;
    NSMutableArray *arrayNotif;
    NSDictionary *userDict;
}
@property UIDynamicAnimator *animator;

@end
