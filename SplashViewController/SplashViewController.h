//
//  SplashViewController.h
//  @TCS
//
//  Created by FNSPL on 20/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LNBRippleEffect.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "DashBoardViewController.h"
#import "UIColor+HexString.h"

@class LoginViewController;
@class DashBoardViewController;

@interface SplashViewController : BaseViewController<CAAnimationDelegate>
{
    CATransition *animation;
    LoginViewController *login;
    DashBoardViewController *dashboard;
    NSString *isLoggedIn;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgview_logo;

@property (weak, nonatomic) UIImageView *imgView_splashLogo;

@end
