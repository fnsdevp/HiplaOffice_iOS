//
//  AddRecepientViewController.h
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "AddRecepientViewCell.h"
#import "BaseViewController.h"
#import "ContactsTableController.h"
#import "VenueSelectionView.h"
#import "VeeContactPickerViewController.h"

@interface AddRecepientViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ContactsTableControllerDelegate,VeeContactPickerDelegate>
{
    NSString *userId;
    NSString *meeting_id;
    NSString *username;
    NSString *fname;
    NSString *lname;
    NSString *phone;
    
    ContactsTableController *contactVC;
    
    VenueSelectionView *venueSelect;
}
@property (strong, nonatomic) NSDictionary *dictMeetingDetails;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Name;
@property (weak, nonatomic) IBOutlet UIButton *btn_Add;
@property (strong, nonatomic) NSMutableArray *arrAddRecepients;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_AddRecepients;

@end
