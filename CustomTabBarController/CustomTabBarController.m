//
//  CustomTabBarController.m
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "CustomTabBarController.h"


@interface CustomTabBarController ()

@end


@implementation CustomTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"add_meeting"];
    
    btn_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
        
        self->btn_Button.frame = CGRectMake(0.0, -10.0, buttonImage.size.width/1.35, buttonImage.size.height/1.35);
        
    }completion:^(BOOL finished) {
                         
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        DynamicUIAnimation *bouncyBehavior = [[DynamicUIAnimation alloc] initWithItems:@[self->btn_Button]];
        
        [self.animator addBehavior:bouncyBehavior];
                         
     }];
    
    btn_Button.frame = CGRectMake(0.0, -10.0, buttonImage.size.width/1.35, buttonImage.size.height/1.35);
    
 
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    
    if (heightDifference < 0)
    {
        btn_Button.center = self.tabBar.center;
    }
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        btn_Button.center = center;
    }
    
    [self.view addSubview:btn_Button];
    
    CGFloat Width = self.tabBar.frame.size.width/5.2;
    
    btn_Button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn_Button2.frame = CGRectMake((self.tabBar.frame.size.width - Width), 0.0, Width, self.tabBar.frame.size.height);
    
    [btn_Button2 setBackgroundColor:[UIColor clearColor]];
    [btn_Button2 addTarget:self action:@selector(MoreTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:btn_Button2];
    
    
    if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChangeTabNotification:)
                                                 name:@"ChangeTab"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNewVCNotification:)
                                                 name:@"PushNewVC"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNewVCNotification:)
                                                 name:@"OpenControlVC"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNewVCNotification:)
                                                 name:@"PushToProfileVC"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNewVCNotification:)
                                                 name:@"HotDeskVC"
                                               object:nil];
    
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    
    if (![userType isEqualToString:@"Guest"]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePushNewVCNotification:)
                                                     name:@"PushToSetAvailabilityVC"
                                                   object:nil];
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePushNewVCNotification:)
                                                 name:@"PushToAboutVC"
                                               object:nil];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    db = [Database sharedDB];
    
   // arrayNotif = [db getNotifications];
    
   // NSLog(@"%@",arrayNotif);
    
   // NSString *strNotifCount = [NSString stringWithFormat:@"%d",(int)[arrayNotif count]];
    
   // [[self.tabBar.items objectAtIndex:3] setBadgeValue:strNotifCount];
    
    
    [[self.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    
}


-(void)MoreTapped:(id)sender{
    
    [sender setSelected:true];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenDrawer"
     object:self];
}


-(void)removeSplash{
    
    [splash.view removeFromSuperview];
}


-(void)scheduleMeetingsTapped:(id)sender{
    
    [sender setSelected:true];
    
    [self setSelectedIndex:2];
    [self.tabBarController setSelectedIndex:2];
    
}


- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    NSLog(@"Tab index = %lu", (unsigned long)indexOfTab);
    
    if (indexOfTab == 0) {
        [btn_Button setSelected:false];
    }
    else if (indexOfTab == 1) {
        [btn_Button setSelected:false];
    }
    else if (indexOfTab == 3) {
        [btn_Button setSelected:false];
        
        [[self.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    }
   
}


- (void) receiveChangeTabNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"ChangeTab"]){
        
        NSLog (@"Successfully received the ChangeTab notification!");
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        NSNumber* index = (NSNumber*)userInfo[@"indexClickedOnDrawer"];
        self.selectedIndex = index.intValue;
    
    }
    
}

- (void) receivePushNewVCNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PushNewVC"]){
        
        //self.tabBar
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        FragmentMessageViewController *fragmentVC = [storyboard instantiateViewControllerWithIdentifier:@"FragmentMessageViewController"];
        
        [self.navigationController pushViewController:fragmentVC animated:YES];
        
    }
    else if(([[notification name] isEqualToString:@"OpenControlVC"]))
    {
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        ctrlVC = [[ControlPanelViewController alloc] initWithNibName:@"ControlPanelViewController" bundle:nil];
        
        [self.navigationController pushViewController:ctrlVC animated:YES];
        
    }
    else if(([[notification name] isEqualToString:@"PushToProfileVC"]))
    {
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        ProfileDetailViewController *profileVC = [[ProfileDetailViewController alloc]initWithNibName:@"ProfileDetailViewController" bundle:nil];
        
        [self.navigationController pushViewController:profileVC animated:YES];
        
    }
    else if(([[notification name] isEqualToString:@"PushToSetAvailabilityVC"]))
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        setAvailabilty = [storyboard instantiateViewControllerWithIdentifier:@"setAvailabilty"];
        [self.navigationController pushViewController:setAvailabilty animated:YES];
        
    }
    else if(([[notification name] isEqualToString:@"HotDeskVC"]))
    {
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        HotDeskViewController *HotDeskVC = [[HotDeskViewController alloc] initWithNibName:@"HotDeskViewController" bundle:nil];
        
        [self.navigationController pushViewController:HotDeskVC animated:YES];
        
    }
    else if(([[notification name] isEqualToString:@"PushToAboutVC"]))
    {
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        
        AboutUsViewController *AboutUsVC = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        
        [self.navigationController pushViewController:AboutUsVC animated:YES];
        
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
