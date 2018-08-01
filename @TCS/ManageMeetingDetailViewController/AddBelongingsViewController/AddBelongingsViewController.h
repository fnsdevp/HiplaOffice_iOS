//
//  AddBelongingsViewController.h
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBelongingsViewCell.h"
#import "BaseViewController.h"

@interface AddBelongingsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *userId;
    NSString *meeting_id;
    NSString *property_type;
    NSString *property_value;
}
@property (strong, nonatomic) NSDictionary *dictMeetingDetails;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_ItemName;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Value;
@property (weak, nonatomic) IBOutlet UIButton *btn_Add;
@property (strong, nonatomic) NSMutableArray *arrAddBelongings;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_AddBelongings;

@end
