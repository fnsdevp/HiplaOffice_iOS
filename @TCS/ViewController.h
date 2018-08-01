//
//  ViewController.h
//  Navigine Example
//
//  Created by Dmitry Stavitsky on 01/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MapPin.h"
#import "CurrentLocation.h"
#import "RouteEventView.h"
#import "ErrorView.h"
#import "Navigine/NavigineSDK.h"
#import "KxMenu.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,NavigineCoreDelegate,NavigineCoreNavigationDelegate>
{
    NSMutableArray *arrPointx;
    NSMutableArray *arrPointy;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// Buttons
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentFloor;
@property (weak, nonatomic) IBOutlet UIStackView *btnStackFloor;
@property (nonatomic, strong) MapPin *pressedPin; // Selected venue
@property (nonatomic, strong) CurrentLocation *curPosition;
@property (nonatomic, assign) int floor; // Selected sublocation

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
// Path
@property (nonatomic, strong) UIBezierPath *routePath;
@property (nonatomic, strong) CAShapeLayer *routeLayer;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, strong) RouteEventView *eventView;
@property (nonatomic, strong) ErrorView *errorView;
// NCore attributes
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NCLocation *location;
@property (nonatomic, strong) NCSublocation *sublocation;
@end
