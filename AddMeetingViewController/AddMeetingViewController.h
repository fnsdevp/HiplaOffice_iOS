//
//  AddMeetingViewController.h
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "WWCalendarTimeSelector-Swift.h"
#import "MeetingDateCollectionViewCell.h"
#import "MeetingTimeCollectionViewCell.h"
#import "KPSmartTabBar.h"
#import "AFNetworking.h"
#import "ContactsTableController.h"
#import "VenueSelectionView.h"
#import "VeeContactPickerViewController.h"
#import "FragmentViewController.h"

@class FragmentViewController;

@interface AddMeetingViewController : BaseViewController<UITextFieldDelegate,MeetingDateCollectionViewCellDelegate,MeetingTimeCollectionViewCellDelegate,WWCalendarTimeSelectorProtocol,ContactsTableControllerDelegate,VeeContactPickerDelegate,sharedZoneDetectionDelegate>
{
    NSArray *hours;
    NSString *userId;
    NSString *profimage;
    
    NSString *locationName;
    NSDate *nextday;
    NSString *month;
    NSString *date;
    NSString *day;
    
    NSString *roomId;
    
    int btnTag;
    
    BOOL isSelectedDate;
    BOOL isSelectedTime;
    
    NSString *selectedDate;
    
    NSDate *initialDate;
    
    int seletedTag;
    
    BOOL isCurrentWeek;
    
    BOOL indexZeroDisable;
    
    NSArray *arrTiming;
    
    int seletedTag1;
    int seletedTag2;
    
    NSMutableArray *arrBooked;
    
    ContactsTableController *contactVC;
    
    VenueSelectionView *venueSelect;
    
}
@property (assign, nonatomic) BOOL isFexible;
@property (assign, nonatomic) BOOL isWebex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_Dates;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_Times;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Back;
@property (strong, nonatomic) IBOutlet UIView *view_Confirmation;
@property (strong, nonatomic) IBOutlet UIView *addMeetingBackView;
@property (strong, nonatomic) IBOutlet UIView *view_Name;
@property (strong, nonatomic) IBOutlet UIView *view_Date;
@property (strong, nonatomic) IBOutlet UIView *view_Time;
@property (strong, nonatomic) IBOutlet UIView *view_DateTime;
@property (strong, nonatomic) IBOutlet UIView *view_DateTime1;
@property (strong, nonatomic) IBOutlet UIView *view_DateTime2;
@property (strong, nonatomic) IBOutlet UIView *confirmMeetingView;
@property (strong, nonatomic) IBOutlet UIView *VwPicker;
@property (weak, nonatomic) IBOutlet UIButton *btn_Confirm;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddContact;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;

@property (weak, nonatomic) IBOutlet UITextField *txtfld_Agenda;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DepartmentName;

@property (weak, nonatomic) IBOutlet UILabel *lblDay1;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth1;
@property (weak, nonatomic) IBOutlet UILabel *lblYear1;

@property (weak, nonatomic) IBOutlet UILabel *lblDay2;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth2;
@property (weak, nonatomic) IBOutlet UILabel *lblYear2;

@property (weak, nonatomic) IBOutlet UILabel *lblDay3;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth3;
@property (weak, nonatomic) IBOutlet UILabel *lblYear3;

@property (weak, nonatomic) IBOutlet UILabel *lblMeetingWith;
@property (weak, nonatomic) IBOutlet UILabel *lblMeetingDateTime;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NavigineCore *navigineCore;
@property (weak, nonatomic) FragmentViewController *fmVC;

-(void)AddMeetingViewController:(AddMeetingViewController *)adm getName:(NSString *)name andphNo:(CNContact *)contact;

-(void)AddMeetingViewController:(AddMeetingViewController *)adm getName:(NSString *)name withphNo:(NSString *)contact;

@end
