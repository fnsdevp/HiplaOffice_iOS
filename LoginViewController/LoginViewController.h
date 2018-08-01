//
//  LoginViewController.h
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFCheckbox.h"
#import "BaseViewController.h"
#import "DashBoardViewController.h"
#import "RegistrationViewController.h"
#import "ForgotPassViewController.h"

@class DashBoardViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    NSString *userType;
    BOOL isEmployee;
    DashBoardViewController *dashboard;
}

@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_userName;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_passWord;
@property (weak, nonatomic) IBOutlet ZFCheckbox *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOutlet;

@end
