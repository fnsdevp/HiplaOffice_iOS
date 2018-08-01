//
//  FragmentMessageViewController.m
//  @TCS
//
//  Created by FNSPL on 14/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "FragmentMessageViewController.h"

@interface FragmentMessageViewController ()

@end


@implementation FragmentMessageViewController

- (void)viewDidLoad {
    
    //[super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setFragmentMenu];
    
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}



-(void)setFragmentMenu
{
    NSMutableArray *arrControllers = [NSMutableArray new];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    MessageBoxViewController *VC1 = [storyboard instantiateViewControllerWithIdentifier:@"MessageBoxViewController"];

    VC1.title= @"Inbox";

    VC1.isInbox = YES;
    VC1.fmVC = self;

    [arrControllers addObject:VC1];


    MessageBoxViewController *VC2 = [storyboard instantiateViewControllerWithIdentifier:@"MessageBoxViewController"];

    VC2.title=@"Outbox";

    VC2.isInbox = NO;
    VC2.fmVC = self;

    [arrControllers addObject:VC2];
    
    
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
                                 KPSmartTabBarOptionBottomMenuHairlineColor : [UIColor lightGrayColor]
                                 };
    
    _tabbar = [[KPSmartTabBar alloc] initWithViewControllers:arrControllers frame:CGRectMake(0.0, 88.0, self.view.frame.size.width, (self.view.frame.size.height-88)) options:parameters];
    
    [self.view addSubview:_tabbar.view];
    
}
#pragma mark - FragmentManageViewControllerDelegate
- (void)didSelectedRow:(NSMutableDictionary *)item {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MessageDetailViewController* mmdVC = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailViewController"];
    
     mmdVC.getDictFromMessage = item;
    
    [self.navigationController pushViewController:mmdVC animated:YES];
    
}
- (void)sendMessage{
    
    CreateMessageViewController *messageVC = [[CreateMessageViewController alloc]initWithNibName:@"CreateMessageViewController" bundle:nil];
    
    messageVC.fmVC = self;
    
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)BackToFragment
{
    if (_mbVC) {
        
        _mbVC.arrayAllMessages=[[NSMutableArray alloc]init];
        
        _mbVC.str_ChangeURL = @"all_messages.php";
        
        [_mbVC getAllMessageswithType:_mbVC.str_ChangeURL];
    }
}


-(IBAction)btnBack:(id)sender
{
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
