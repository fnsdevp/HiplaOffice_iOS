//
//  RescheduleViewController.h
//  @TCS
//
//  Created by FNSPL on 17/05/18.
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
#import "FragmentRescheduleViewController.h"
#import "AddMeetingViewController.h"
#import "DashBoardViewController.h"

@class FragmentRescheduleViewController;

@interface RescheduleViewController : BaseViewController<UITextFieldDelegate,MeetingDateCollectionViewCellDelegate,MeetingTimeCollectionViewCellDelegate,WWCalendarTimeSelectorProtocol,ContactsTableControllerDelegate,VeeContactPickerDelegate>
{
    NSArray *hours;
    NSString *userId;
    
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
    
    DashBoardViewController *dashboard;
    
}
@property (assign, nonatomic) BOOL isFexible;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_Dates;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_Times;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Back;
@property (strong, nonatomic) IBOutlet UIView *view_Name;
@property (strong, nonatomic) IBOutlet UIView *view_Date;
@property (strong, nonatomic) IBOutlet UIView *view_Time;
@property (strong, nonatomic) IBOutlet UIView *confirmMeetingView;
@property (weak, nonatomic) IBOutlet UIButton *btn_Confirm;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddContact;

@property (strong, nonatomic) IBOutlet UITextField *txtfld_Agenda;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DepartmentName;


@property (strong, nonatomic) NSDictionary *dictDetails;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) FragmentRescheduleViewController *fmreschVC;

-(void)RescheduleViewController:(RescheduleViewController *)adm getName:(NSString *)name andphNo:(CNContact *)contact;

-(void)RescheduleViewController:(RescheduleViewController *)adm getName:(NSString *)name withphNo:(NSString *)contact;

@end
