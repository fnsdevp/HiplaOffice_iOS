//
//  DashBoardViewController.h
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "PantryViewController.h"
#import "MessageBoxViewController.h"
#import "FragmentMessageViewController.h"
#import "DashBoardTableViewCell.h"
#import "NavigationViewController.h"
#import "HotDeskViewController.h"
#import "Reachability.h"

@class PantryViewController;

@interface DashBoardViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *userId;
    NSArray *meetingsArr;
    NSMutableArray *pastMeetingsArr;
    int unreadMsgCount;
    
    NSDictionary *userDict;
    NSString *usertype;
    
    NSTimer *stopTimer;
    int secondsLeft;
    float millisecond,second;
    BOOL running;
    
    PantryViewController *PantryViewControllerVC;
    FragmentMessageViewController *FragmentMessageViewControllerVC;
    MessageBoxViewController *MessageBoxViewControllerVC;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_List;
@property (weak, nonatomic) IBOutlet UITableView *tblView_ManageMeeting;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoUpcoming;
@property (weak, nonatomic) IBOutlet UIView *Vw_NavigationBar;
@property (weak, nonatomic) IBOutlet UIView *Vw_Collection;
@property (weak, nonatomic) IBOutlet UIView *Vw_TableList;
@property (weak, nonatomic) IBOutlet UIView *view_NetView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property(strong,nonatomic) LocationManager *shareModel;
//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
@property (nonatomic, strong) NSArray *zoneArray;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSMutableArray *upcomingMeetingsArr;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(nonatomic, readwrite) CGAffineTransform transform;

@property (weak, nonatomic) IBOutlet UIView *PopupView;
@property (strong,nonatomic) IBOutlet UILabel *lblSpeeach;

@property (strong,nonatomic) IBOutlet UILabel *lblTimer;

@property (strong,nonatomic) IBOutlet UIButton *btnOpenDoor;
@property (strong,nonatomic) IBOutlet UIButton *btnClose;
@property (strong,nonatomic) IBOutlet UIButton *btnOpenMap;

- (void)callTap:(id)sender;
- (void)navigateTap:(id)sender;
- (void)cancelTap:(id)sender;
- (IBAction)rescheduleTap:(id)sender;

@end
