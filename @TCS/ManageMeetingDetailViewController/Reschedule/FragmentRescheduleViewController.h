//
//  FragmentRescheduleViewController.h
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPSmartTabBar.h"
#import "BaseViewController.h"
#import "RescheduleViewController.h"
#import "ContactsTableController.h"

@protocol RescheduleViewControllerDelegate
@optional
// list of optional methods
- (void)modifyItem:(id)item;
@end

@class RescheduleViewController;

@interface FragmentRescheduleViewController : BaseViewController<KPSmartTabBarDelegate,ContactsTableControllerDelegate>
{
    NSString *department;
    NSString *phone;
    
    ContactsTableController *contactVC;
}
@property (nonatomic) KPSmartTabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIView *view_CompanyNavBar;
@property (weak, nonatomic) RescheduleViewController *reschVC;
@property (strong, nonatomic) NSDictionary *dictDetails;
@property (strong, nonatomic) NSString *type;

- (void)didSelectedContact;

- (void)beckToPrevious;

@end
