//
//  ChangePasswordViewController.h
//  SmartOffice
//
//  Created by FNSPL on 11/05/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "Constants.h"
#import "AFNetworking.h"

IB_DESIGNABLE

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@protocol ChangePasswordViewControllerDelegate;
@class ChangePasswordViewController;

@protocol ChangePasswordViewControllerDelegate <NSObject>

@optional

-(void)ChangePasswordViewController:(ChangePasswordViewController *)obj didremove:(BOOL)isRemove;

@end


@interface ChangePasswordViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSString *userId;
}
@property (nonatomic)id<ChangePasswordViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backbgImg;
@property (weak, nonatomic) IBOutlet UIView *backVw;

@property (weak, nonatomic) IBOutlet UIView *popupVw;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *NewPasswordlbl;
@property (weak, nonatomic) IBOutlet UITextField *NewPasswordTxt;

@end
