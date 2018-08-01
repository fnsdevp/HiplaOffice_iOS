//
//  RegistrationViewController.h
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "BaseViewController.h"
#import "DashBoardViewController.h"
#import "departmentTableCell.h"

@class DashBoardViewController;

#define SystemSharedServices [SystemServices sharedServices]

@interface RegistrationViewController : BaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSString *userType;
    BOOL isEmployee;
    DashBoardViewController *dashboard;
    UIBarButtonItem *previousButton,*flexBarButton,*nextButton,*doneButton;
    UIToolbar *keyboardDoneButtonView;
    CGFloat keyboardHeight;
    UITextField *activeTextField;
    CGFloat doneKeyboardHeight;
    NSMutableArray *arrDepartMents;
    UIAlertController *alertController;
    UISegmentedControl *segmentedControl;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSignUpOutlet;
@property (weak, nonatomic) IBOutlet UIButton *btnDepartments;
@property (strong, nonatomic) UITableView *tblDepartments;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userSelectionSegControl;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_UserName;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Password;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_FirstName;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_LastName;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Email;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Phone;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Department;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Designation;
@property (weak, nonatomic) IBOutlet JJMaterialTextfield *txtfld_Company;


@end
