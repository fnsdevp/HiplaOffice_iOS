//
//  FragmentRescheduleViewController.m
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "FragmentRescheduleViewController.h"

@interface FragmentRescheduleViewController ()

@end

@implementation FragmentRescheduleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setFragmentMenu];
}


-(void)setFragmentMenu
{
    NSMutableArray *arrControllers = [NSMutableArray new];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if ([self.type isEqualToString:@"fixed"]) {
        
        RescheduleViewController *controller1 = [storyboard instantiateViewControllerWithIdentifier:@"RescheduleViewController"];
        
        controller1.title= @"Fixed";
        
        controller1.isFexible = NO;
        controller1.fmreschVC = self;
        controller1.dictDetails = self.dictDetails;
        [arrControllers addObject:controller1];
        
    } else {
        
        RescheduleViewController *controller2 = [storyboard instantiateViewControllerWithIdentifier:@"RescheduleViewController"];
        
        controller2.title=@"Flexible";
        
        controller2.isFexible = YES;
        controller2.fmreschVC = self;
        controller2.dictDetails = self.dictDetails;
        [arrControllers addObject:controller2];
    }
    
    NSDictionary *parameters = @{
                                 KPSmartTabBarOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                 KPSmartTabBarOptionMenuItemSelectedFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                 KPSmartTabBarOptionMenuItemSeparatorWidth : @(4.3),
                                 KPSmartTabBarOptionMenuItemSeparatorColor : [UIColor lightGrayColor],
                                 KPSmartTabBarOptionScrollMenuBackgroundColor : [UIColor blackColor],
                                 KPSmartTabBarOptionViewBackgroundColor : [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionSelectionIndicatorColor : [UIColor colorWithRed:8.0/255.0 green:150.0/255.0 blue:225.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionMenuMargin:@(20.0),
                                 KPSmartTabBarOptionMenuHeight: @(40.0),
                                 KPSmartTabBarOptionSelectedMenuItemLabelColor:[UIColor colorWithRed:8.0/255.0 green:150.0/255.0 blue:225.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionUnselectedMenuItemLabelColor :[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:45.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionCenterMenuItems: @(YES),
                                 KPSmartTabBarOptionUseMenuLikeSegmentedControl : @(YES),
                                 KPSmartTabBarOptionMenuItemSeparatorRoundEdges:@(YES),
                                 KPSmartTabBarOptionEnableHorizontalBounce:@(NO),
                                 KPSmartTabBarOptionMenuItemSeparatorPercentageHeight:@(0.1),
                                 KPSmartTabBarOptionSelectionIndicatorHeight:@(2.0),
                                 KPSmartTabBarOptionAddBottomMenuHairline : @(YES),
                                 KPSmartTabBarOptionBottomMenuHairlineHeight : @(1.0),
                                 KPSmartTabBarOptionBottomMenuHairlineColor : [UIColor lightGrayColor]
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
    if (_reschVC) {
        
        [_reschVC RescheduleViewController:_reschVC getName:name andphNo:contact];
    }
    
}

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph
{
    if (_reschVC) {
        
        [_reschVC RescheduleViewController:_reschVC getName:name withphNo:ph];
    }
}

#pragma mark - methods

- (void)beckToPrevious {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
