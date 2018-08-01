//
//  FragmentViewController.h
//  @TCS
//
//  Created by FNSPL on 07/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPSmartTabBar.h"
#import "BaseViewController.h"
#import "AddMeetingViewController.h"
#import "ContactsTableController.h"

@protocol AddMeetingViewControllerDelegate
@optional
// list of optional methods
- (void)modifyItem:(id)item;
@end

@class AddMeetingViewController;

@interface FragmentViewController : BaseViewController<KPSmartTabBarDelegate,ContactsTableControllerDelegate>
{
    NSString *department;
    NSString *phone;
    
    ContactsTableController *contactVC;
}
@property (nonatomic) KPSmartTabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIView *view_CompanyNavBar;
@property (weak, nonatomic) AddMeetingViewController *amVC;

- (void)didSelectedContact;

@end
