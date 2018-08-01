//
//  FragmentManageViewController.h
//  @TCS
//
//  Created by FNSPL on 09/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPSmartTabBar.h"
#import "ManageMeetingTableViewCell.h"
#import "ManageMeetingViewController.h"
#import "NavigationViewController.h"

@class ManageMeetingViewController;

//@protocol FragmentManageViewControllerDelegate
//@optional
//// list of optional methods
//- (void)didSelectedRow:(NSDictionary *)item;
//@end

@interface FragmentManageViewController : BaseViewController<KPSmartTabBarDelegate>

@property (nonatomic) KPSmartTabBar *tabbar;
@property (assign, nonatomic) BOOL isRequestMeeting;
@property (assign, nonatomic) BOOL isGroupAppointment;

@property (weak, nonatomic) ManageMeetingViewController *mmVC;

- (void)didSelectedRow:(NSDictionary *)item;

- (void)didSelectedNavigation:(NSDictionary *)item;

- (void)openModal:(NSString *)strTitle withMessage:(NSString *)strMessage withOK:(BOOL)OK andCancel:(BOOL)Cancel withDict:(NSDictionary *)item;

@end
