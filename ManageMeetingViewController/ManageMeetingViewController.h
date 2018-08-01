//
//  ManageMeetingViewController.h
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Utils.h"
#import "BaseViewController.h"
#import "ManageMeetingTableViewCell.h"
#import "ManageMeetingDetailViewController.h"
#import "FragmentManageViewController.h"
#import "NetPopViewController.h"

@class ManageMeetingDetailViewController;
@class FragmentManageViewController;

@interface ManageMeetingViewController : BaseViewController<sharedZoneDetectionDelegate>
{
    BOOL isRequest;
    BOOL removeFromView;
    NSString *userId;
    
    BOOL isSearch;
    UIView *pickerVw;
    
    UIView *view;
    NSArray *appointmentsArray;
    
    NSString *status;
    NSString *locationName;
    NSString *date;
    NSString *meeting_id;
    
    NSArray *idArr;
    NSArray *PassArr;
    
    NSString *savedEventId;
    UILabel *lbl_noMeeting;
    UIDatePicker *datepicker;
    
    int Row;
    
    NSMutableArray *searchArray;
    NSDictionary *selectedAppointment;
    
    ManageMeetingDetailViewController *manageMeetingDetailsVC;
}
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (assign, nonatomic) BOOL isRequestMeeting;
@property (assign, nonatomic) BOOL isAll;
@property (assign, nonatomic) BOOL isConfirmed;
@property (assign, nonatomic) BOOL isPending;
@property (assign, nonatomic) BOOL isGroupAppointment;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Search;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *view_Menu;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITableView *tblView_ManageMeeting;
@property (strong, nonatomic) NSMutableArray *finalAppointmentListing;
@property (strong, nonatomic) NSMutableArray *pendingAppointmentListing;
@property (strong, nonatomic) NSMutableArray *confirmedAppointmentListing;
@property (strong, nonatomic) NSMutableArray *groupAppointmentListing;

@property (nonatomic, strong) NavigineCore *navigineCore;
@property (weak, nonatomic) FragmentManageViewController* fmViewController;
@property (weak, nonatomic) IBOutlet UIView *view_NoNet;

- (void)callTap:(id)sender;
- (void)navigateTap:(id)sender;
- (void)cancelTap:(id)sender;
- (void)confirmTap:(id)sender;
- (void)changeAppointment:(NSDictionary *)dict;

@end
