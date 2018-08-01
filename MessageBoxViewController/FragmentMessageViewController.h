//
//  FragmentMessageViewController.h
//  @TCS
//
//  Created by FNSPL on 14/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "KPSmartTabBar.h"
#import "BaseViewController.h"
#import "MessageBoxViewController.h"

@class MessageBoxViewController;

@interface FragmentMessageViewController : BaseViewController<KPSmartTabBarDelegate>

@property (nonatomic) KPSmartTabBar *tabbar;


#pragma Mark -  TRANSFER DATA

@property (weak, nonatomic) MessageBoxViewController *mbVC;

- (void)didSelectedRow:(NSMutableDictionary *)item;
- (void)sendMessage;
- (void)BackToFragment;

@end
