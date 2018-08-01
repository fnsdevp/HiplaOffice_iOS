////
////  NavigationViewController.h
////  @TCS
////
////  Created by FNSPL on 28/04/18.
////  Copyright © 2018 FNSPL. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
//#import "UIColor+HexString.h"
//#import "ZoneDetection.h"
//#import "popView.h"
//
//#define kColorFromHex(color)[UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0]
//
//@interface NavigationViewController : UIViewController<UIScrollViewDelegate,sharedZoneDetectionDelegate,popViewDelegate>
//{
//    int indexId;
//    NSMutableArray *arrNames;
//    NSMutableArray *arrPointx;
//    NSMutableArray *arrPointy;
//    
//    NSString *userId;
//    BOOL isStarted;
//    
//    popView *pop;
//    
//    UINavigationController *localNavigationController;
//    
//    UIBezierPath   *uipath;
//    CAShapeLayer   *routeLayer;
//    NSDictionary *userInfo;
//}
//@property (nonatomic, strong) NavigineCore *navigineCore;
//@property (nonatomic, strong) NSString *currentRoom;
//@property (nonatomic, strong) NSString *currentZoneName;
//@property (nonatomic, strong) NSArray *zoneArray;
//@property (nonatomic, strong) UIImageView *current;
//@property (nonatomic, strong) MapPin *pressedPin;
//@property (nonatomic, assign) BOOL isRouting;
//@property (nonatomic, strong) NSString *className;
//@property (weak, nonatomic) IBOutlet UIScrollView *sv;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (nonatomic, assign) CGPoint targetPoint;
//@property (nonatomic, strong) UIImageView *custom;
//
//@end
