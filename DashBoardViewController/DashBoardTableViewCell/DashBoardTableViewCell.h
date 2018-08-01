//
//  DashBoardTableViewCell.h
//  @TCS
//
//  Created by FNSPL on 04/06/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardViewController.h"
#import "FragmentViewController.h"
#import "FragmentRescheduleViewController.h"
@class DashBoardViewController;

@interface DashBoardTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL isAll;
@property (assign, nonatomic) BOOL isConfirmed;
@property (assign, nonatomic) BOOL isPending;
@property (assign, nonatomic) BOOL isGroupAppointment;

@property (assign, nonatomic) NSInteger Row;
@property (weak, nonatomic) IBOutlet UIView *viewBtns;
@property (weak, nonatomic) IBOutlet UIView *view_CalendarBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Confirm;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimingDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EmailId;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthYear;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_Call;
@property (weak, nonatomic) IBOutlet UIButton *btn_Navigation;
@property (weak, nonatomic) IBOutlet UIButton *btn_Confirm;

@property (weak, nonatomic) IBOutlet UIButton *btn_Reshedule;
@property (strong, nonatomic) NSMutableArray *upcomingMeetingsArr;
@property (strong, nonatomic) NSDictionary *dictMeetingDetails;

@property (strong, nonatomic) DashBoardViewController* dbVC;

@end

