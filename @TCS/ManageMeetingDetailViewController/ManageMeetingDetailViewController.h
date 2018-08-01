//
//  ManageMeetingDetailViewController.h
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import "BaseViewController.h"
#import "CommentTableCell.h"
#import "Common.h"
#import "ManageMeetingViewController.h"
#import "AddRecepientViewController.h"
#import "AddBelongingsViewController.h"
#import "NavigationViewController.h"
#import "RescheduleViewController.h"
#import "FragmentRescheduleViewController.h"

@interface ManageMeetingDetailViewController : BaseViewController<UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat x;
    NSString *meeting_id;
    NSString *guest_id;
    NSString *property_type;
    NSString *property_value;
    NSString *device_id;
    
    NSString *username;
    NSString *userId;
    NSString *fname;
    NSString *lname;
    
    NSString *locationName;
    NSString *fDateSel;
    NSString *savedEventId;
    NSString *appointmentId;
    
    BOOL isConfirmBtn;
    BOOL isCancelBtn;
    BOOL isEndBtn;
    BOOL isResceduleBtn;
    BOOL isCallBtn;
    BOOL isMapBtn;
    BOOL isNavigationBtn;
    
    NSDictionary *currentMeeting;
    NSString *fromTime;
    
    NSString *distance;
    NSString *duration;
    
    AddBelongingsViewController *addBelongingsVC;
    AddRecepientViewController *addRecepientsVC;
}
@property (assign, nonatomic) BOOL fromDashboard;
@property (assign, nonatomic) BOOL isRequestMeeting;
@property (assign, nonatomic) BOOL isGroupAppointment;
@property (strong, nonatomic) NSMutableArray *postCommentListing;
@property (strong, nonatomic) NSDictionary *dictMeetingDetails;
@property (weak, nonatomic) IBOutlet UIView *view_CompanyNavBar;
@property (weak, nonatomic) IBOutlet UIView *view_ManageMeeting;
@property (weak, nonatomic) IBOutlet UIView *view_Comments;
@property (weak, nonatomic) IBOutlet UIView *view_status;

@property (nonatomic, strong) NavigineCore *navigineCore;

@property (nonatomic, strong) Common *objcommon;

@property (weak, nonatomic) IBOutlet UIButton *btn_post;
@property (weak, nonatomic) IBOutlet UITextView *txtView_comments;
@property (weak, nonatomic) IBOutlet UITableView *tbleView_Comments;
@property (weak, nonatomic) IBOutlet UITableViewCell *tblViewCell_Comments;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Comments;
@property (weak, nonatomic) IBOutlet UITextView *txtView_Comments;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw_ManageMeeting;

@property (weak, nonatomic) IBOutlet UIButton *btn_AddBelongings;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddRecepient;
@property (weak, nonatomic) IBOutlet UIView *view_CalendarBackground;

@property (weak, nonatomic) IBOutlet UIView *etaVw;
@property (weak, nonatomic) IBOutlet UILabel *lbldistance;
@property (weak, nonatomic) IBOutlet UILabel *lblduration;

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
@property (weak, nonatomic) IBOutlet UIButton *btn_Gps;
@property (weak, nonatomic) IBOutlet UIButton *btn_Chat;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MeetingType;
@property (weak, nonatomic) IBOutlet UITextView *txtView_Agenda;

@end
