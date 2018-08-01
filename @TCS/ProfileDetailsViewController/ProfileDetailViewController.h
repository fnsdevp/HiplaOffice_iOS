//
//  ProfileDetailViewController.h
//  @TCS
//
//  Created by FNSPL on 10/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "RadioButton.h"
#import "DashBoardViewController.h"
#import "ChangePasswordViewController.h"

@class RadioButton;

@interface ProfileDetailViewController : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,ChangePasswordViewControllerDelegate>{
    
    UIView *navView;
    NSString *userId;
    NSString *title;
    NSString *host_url;
    
    ChangePasswordViewController *newPassVC;

}
@property (nonatomic, strong) IBOutlet RadioButton* radioButton1;
@property (nonatomic, strong) IBOutlet RadioButton* radioButton2;
@property (weak, nonatomic) IBOutlet UIImageView *profPicImg;
@property (weak, nonatomic) IBOutlet UIScrollView *innerScrollVw;
@property (weak, nonatomic) IBOutlet UIButton *profPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateDeviceInfoBtn;

@property (weak, nonatomic) IBOutlet UIView *dateNotifVw;
@property (weak, nonatomic) IBOutlet UIView *timeOptionVw;

@property (nonatomic, strong) IBOutlet UISwitch *dateNotifSwitch;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic,strong) NSString *isFromAddMeeting;
@property (weak, nonatomic) IBOutlet UILabel *userTypelbl;
@property (weak, nonatomic) IBOutlet UILabel *fnamelbl;
@property (weak, nonatomic) IBOutlet UILabel *lnamelbl;
@property (weak, nonatomic) IBOutlet UILabel *departmentlbl;
@property (weak, nonatomic) IBOutlet UILabel *designationlbl;
@property (weak, nonatomic) IBOutlet UILabel *companylbl;
@property (weak, nonatomic) IBOutlet UILabel *phonelbl;
@property (weak, nonatomic) IBOutlet UILabel *emaillbl;



@end
