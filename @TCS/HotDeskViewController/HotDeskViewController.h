//
//  HotDeskViewController.h
//  Hotdesking
//
//  Created by FNSPL5 on 07/06/18.
//  Copyright © 2018 futureNetwings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DashBoardViewController.h"

@interface HotDeskViewController : BaseViewController

@property(strong,nonatomic) NSMutableArray *array_ZoneList;
@property(strong,nonatomic) NSMutableArray *bookedArray;
@property(strong,nonatomic) NSString *str_TimeDuration;
@property(strong,nonatomic) NSString *isPresent;
@property (weak, nonatomic) IBOutlet UIView *view_defaultView;
@property (weak, nonatomic) IBOutlet UIView *view_WifiUserDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_password;
@property (weak, nonatomic) IBOutlet UILabel *lbl_username;
@property (weak, nonatomic) IBOutlet UITextView *txtview_DefaultView;

@property (weak, nonatomic) IBOutlet UIButton *btn_1A;
@property (weak, nonatomic) IBOutlet UIButton *btn_1B;
@property (weak, nonatomic) IBOutlet UIButton *btn_1C;
@property (weak, nonatomic) IBOutlet UIButton *btn_1D;
@property (weak, nonatomic) IBOutlet UIButton *btn_2A;
@property (weak, nonatomic) IBOutlet UIButton *btn_2B;
@property (weak, nonatomic) IBOutlet UIButton *btn_2C;
@property (weak, nonatomic) IBOutlet UIButton *btn_2D;
@property (weak, nonatomic) IBOutlet UIButton *btn_releaseButton;
@property (weak, nonatomic) IBOutlet UIButton *btn_navigateButton;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wifiUsername;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wifiPassword;
@property (weak, nonatomic) IBOutlet UIButton *btn_showPassword;
@property(strong,nonatomic) NSMutableArray *array_UserName;
@property(strong,nonatomic) NSMutableArray *array_Password;

@end
