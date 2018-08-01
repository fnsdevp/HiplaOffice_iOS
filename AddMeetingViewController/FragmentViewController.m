//
//  FragmentViewController.m
//  @TCS
//
//  Created by FNSPL on 07/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "FragmentViewController.h"

@interface FragmentViewController ()

@end

@implementation FragmentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setFragmentMenu];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    [self setFragmentMenu];
//    
//}

-(void)setFragmentMenu
{
    NSMutableArray *arrControllers = [NSMutableArray new];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    AddMeetingViewController *controller1 = [storyboard instantiateViewControllerWithIdentifier:@"AddMeetingViewController"];
    
    controller1.title= @"Fixed";
    
    controller1.isFexible = NO;
    controller1.isWebex =  NO;
    controller1.fmVC = self;
    [arrControllers addObject:controller1];
    
    
    AddMeetingViewController *controller2 = [storyboard instantiateViewControllerWithIdentifier:@"AddMeetingViewController"];
    
    controller2.title=@"Flexible";
    
    controller2.isFexible = YES;
    controller1.isWebex =  NO;

    controller2.fmVC = self;
    [arrControllers addObject:controller2];
    
    
//    AddMeetingViewController *controller3 = [storyboard instantiateViewControllerWithIdentifier:@"AddMeetingViewController"];
//
//    controller3.title=@"Webex";
//    controller3.isFexible = NO;
//    controller3.isWebex = YES;
//    controller3.fmVC = self;
//
//    [arrControllers addObject:controller3];
    
    
//    WebexViewController *controller3 = [storyboard instantiateViewControllerWithIdentifier:@"WebexViewController"];
//
//    controller3.title=@"WebEX";
//    controller3.fmVC = self;
//
//    [arrControllers addObject:controller3];
    
    
    NSDictionary *parameters = @{
                                 KPSmartTabBarOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                 KPSmartTabBarOptionMenuItemSelectedFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                 KPSmartTabBarOptionMenuItemSeparatorWidth : @(4.3),
                                 KPSmartTabBarOptionMenuItemSeparatorColor : [UIColor lightGrayColor],
                                 KPSmartTabBarOptionScrollMenuBackgroundColor : [UIColor blackColor],
                                 KPSmartTabBarOptionViewBackgroundColor : [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionSelectionIndicatorColor : [UIColor colorWithHexString:@"1f8fcf"],
                                 KPSmartTabBarOptionMenuMargin:@(20.0),
                                 KPSmartTabBarOptionMenuHeight: @(40.0),
                                 KPSmartTabBarOptionSelectedMenuItemLabelColor:[UIColor colorWithHexString:@"1f8fcf"],
                                 KPSmartTabBarOptionUnselectedMenuItemLabelColor :[UIColor lightGrayColor],
                                 KPSmartTabBarOptionCenterMenuItems: @(YES),
                                 KPSmartTabBarOptionUseMenuLikeSegmentedControl : @(YES),
                                 KPSmartTabBarOptionMenuItemSeparatorRoundEdges:@(YES),
                                 KPSmartTabBarOptionEnableHorizontalBounce:@(NO),
                                KPSmartTabBarOptionMenuItemSeparatorPercentageHeight:@(0.1),
                                 KPSmartTabBarOptionSelectionIndicatorHeight:@(2.0),
                                 KPSmartTabBarOptionAddBottomMenuHairline : @(YES),
                                 KPSmartTabBarOptionBottomMenuHairlineHeight : @(1.0),
                                 KPSmartTabBarOptionBottomMenuHairlineColor : [UIColor darkGrayColor]
                                 };
    
    _tabbar = [[KPSmartTabBar alloc] initWithViewControllers:arrControllers frame:CGRectMake(0.0, 88.0, self.view.frame.size.width, (self.view.frame.size.height-88)) options:parameters];
    
    [self.view addSubview:_tabbar.view];
    
}



#pragma mark - Contact List

- (void)didSelectedContact
{
    //contactVC = [[ContactsTableController alloc] initWithNibName:@"ContactsTableController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        self->contactVC = [[ContactsTableController alloc] init];
        
        self->contactVC.delegate = self;
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        
        //[self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [top presentViewController:self->contactVC animated:NO completion:nil];
        
    });
    
   // [self.navigationController pushViewController:contactVC animated:YES];
}



#pragma mark - ContactsTableControllerDelegate

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name andphNo:(CNContact *)contact
{
    if (_amVC) {
        
        [_amVC AddMeetingViewController:_amVC getName:name andphNo:contact];
    }
    
}

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph
{
    if (_amVC) {
        
        [_amVC AddMeetingViewController:_amVC getName:name withphNo:ph];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
