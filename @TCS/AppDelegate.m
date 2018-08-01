//
//  AppDelegate.m
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    splash = [[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    
    nav = [[UINavigationController alloc]initWithRootViewController:splash];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    db = [Database sharedDB];
    
    [db createdb];
    
    NSString *strPath = [db getDBPath];
    
    NSLog(@"%@",strPath);
    
    [Fabric with:@[[Crashlytics class]]];
    
    [Userdefaults setObject:@"30 min" forKey:@"isMeetingTimeSlot"];
    
    [Userdefaults setBool:NO forKey:@"isETALoopFiredOnce"];
    
    [Userdefaults setBool:NO forKey:@"isETAFiredOnce"];
    
    [Userdefaults setBool:NO forKey:@"within800To400Meter"];
    
    [Userdefaults setBool:NO forKey:@"lessThan400Meter"];
    
    [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
    
    [Userdefaults setBool:NO forKey:@"stepOut"];
    [Userdefaults setBool:NO forKey:@"late"];
    [Userdefaults setBool:NO forKey:@"ETAFired"];
    [Userdefaults setBool:false forKey:@"reschedule"];
    [Userdefaults setBool:NO forKey:@"stopETA"];


    
    [Userdefaults synchronize];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [self registerForRemoteNotifications:application];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted) {
                //Show alert asking to go to settings and allow permission
            }
        }];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOpenDrawerNotification:)
                                                 name:@"OpenDrawer"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveExitDrawerNotification:)
                                                 name:@"ExitDrawer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveClickedDrawerOptionNotification:)
                                                 name:@"ClickedDrawerOption"
                                               object:nil];
    
    //LocationManager
    
    self.shareModel = [LocationManager sharedManager];
    self.shareModel.afterResume = NO;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFire"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.
        
        NSLog(@"UIApplicationLaunchOptionsLocationKey : %@" , [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]);
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            
            // This "afterResume" flag is just to show that he receiving location updates
            // are actually from the key "UIApplicationLaunchOptionsLocationKey"
            
            // self.shareModel.afterResume = YES;
            
            // [self.shareModel startMonitoringLocation];
            
        }
    }
    
    
    /////////////////////////////////
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //Location Mnager
    NSLog(@"applicationDidEnterBackground");
    [self.shareModel restartMonitoringLocation];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //Location Mnager
    self.shareModel.afterResume = NO;
    
    [self.shareModel startMonitoringLocation];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
    
}


- (void)update_badgeWithViewControllerIndex {
    
    int badgeValue = 2;
    
    /* UITabBarController *tabBarController =(UITabBarController*)[[(AppDelegate *)
     [[UIApplication sharedApplication]delegate] window] rootViewController];*/
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    tabBarVC = [storyboard instantiateInitialViewController];
    
    UITabBarController *tabBarController = tabBarVC;
    
    // NSArray *arr = tabBarController.viewControllers;
    
    UITabBarItem *tab_bar = [[tabBarController.viewControllers objectAtIndex:3] tabBarItem];
    
    if (badgeValue > 0) {
        
        [tab_bar setBadgeValue:[NSString stringWithFormat:@"%d",badgeValue]]; // set your badge value
    }
    else {
        
        [tab_bar setBadgeValue:nil];
    }
    
    // Set the tab bar number badge.
    // UITabBarItem *tab_bar = [[tabBarController.viewControllers objectAtIndex:3] tabBarItem];
    
    // Show the badge if the count is
    // greater than 0 otherwise hide it.
    
    //    if (badgeValue > 0) {
    //
    //        [tab_bar setBadgeValue:[NSString stringWithFormat:@"%d",badgeValue]]; // set your badge value
    //    }
    //    else {
    //
    //        [tab_bar setBadgeValue:nil];
    //    }
    
}


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenDrawer"
     object:self];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ExitDrawer"
     object:self];
    
}

-(void)swiperightFromRoot:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //button.hidden = YES;
    //Do what you want here
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ExitDrawer"
     object:self];
    
}

- (void) receiveOpenDrawerNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    
    
    if ([[notification name] isEqualToString:@"OpenDrawer"]){
        
        NSLog (@"Successfully received the OpenDrawer notification!");
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self->drawer = [[RightSideDrawerViewController alloc]initWithNibName:@"RightSideDrawerViewController" bundle:nil];
            
            //  [self.navigationController pushViewController:login animated:YES];
            
            [UIView animateWithDuration:0.1 animations:^{
                
                [self.window addSubview:self->drawer.view];
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 33)];
                view.backgroundColor=[UIColor blackColor];
                [self.window addSubview:view];
                
                self.window.backgroundColor = [UIColor whiteColor];
                
                //[self.window bringSubviewToFront:self.window.rootViewController];
                
            }];
            
            self.window.rootViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
            
            self.window.rootViewController.view.frame = CGRectMake(-100,self.window.rootViewController.view.frame.origin.y ,self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height);
            
            self->btn = [[UIButton alloc]initWithFrame:self.window.rootViewController.view.bounds];
            
            [self->btn addTarget:self action:@selector(exitDrawerFromRoot:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.window.rootViewController.view addSubview:self->btn];
            
            UISwipeGestureRecognizer * swiperightFromRoot=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperightFromRoot:)];
            swiperightFromRoot.direction=UISwipeGestureRecognizerDirectionRight;
            
            [self->btn addGestureRecognizer:swiperightFromRoot];
            
        }];
        
        [self.window sendSubviewToBack:drawer.view];
    }
    
}


-(void)exitDrawerFromRoot:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ExitDrawer"
     object:self];
}


- (void) receiveExitDrawerNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"ExitDrawer"]){
        
        NSLog (@"Successfully received the ExitDrawer notification!");
        //        self.window.rootViewController.view.frame = CGRectMake(-self.window.rootViewController.view.frame.size.width/2,self.window.rootViewController.view.frame.size.height/6 ,self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height/2);
        [UIView animateWithDuration:0.3 animations:^{
            
            self.window.rootViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            
            self.window.rootViewController.view.frame = CGRectMake(0,self.window.rootViewController.view.frame.origin.y ,self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height);
            
            [self->btn removeFromSuperview];
            
        }];
        // [self.window sendSubviewToBack:drawer.view];
    }
    
    [self performSelector:@selector(removeDrawer) withObject:self afterDelay:0.3];
    
}


-(void)removeDrawer{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self->drawer.view removeFromSuperview];
        
    }];
    
}


-(void) receiveClickedDrawerOptionNotification:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.window.rootViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        self.window.rootViewController.view.frame = CGRectMake(0,self.window.rootViewController.view.frame.origin.y ,self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height);
        
        [self->btn removeFromSuperview];
        
    }];
    
    if ([notification.name isEqualToString:@"ClickedDrawerOption"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSLog(@"userInfo %@",userInfo);
        NSNumber* index = (NSNumber*)userInfo[@"indexClickedOnDrawer"];
        NSLog (@"Successfully received ClickedDrawerOption notification! %i", index.intValue);
        
        NSDictionary* clicked = @{@"indexClickedOnDrawer": @(index.intValue)};
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        if (index.intValue==0) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ChangeTab"
             object:self userInfo:clicked];
            [btn removeFromSuperview];
        }
        else if (index.intValue==1) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ChangeTab"
             object:self userInfo:clicked];
            [btn removeFromSuperview];
        }
        else if (index.intValue==3) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ChangeTab"
             object:self userInfo:clicked];
            [btn removeFromSuperview];
        }
        else if (index.intValue==4) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PushNewVC"
             object:self userInfo:clicked];
            [btn removeFromSuperview];
        }
        else if (index.intValue==5) {
            
            if ([userType isEqualToString:@"Guest"])
            {
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
                {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"OpenControlVC"
                     object:self userInfo:clicked];
                    [btn removeFromSuperview];
                    
                }
                else
                {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"PushToProfileVC"
                     object:self userInfo:clicked];
                    [btn removeFromSuperview];
                    
                }
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"OpenControlVC"
                 object:self userInfo:clicked];
                [btn removeFromSuperview];
            }
            
        }
        else if (index.intValue==6) {
            
            if ([userType isEqualToString:@"Guest"])
            {
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
                {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"PushToProfileVC"
                     object:self userInfo:clicked];
                    [btn removeFromSuperview];
                    
                }
                else
                {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"PushToAboutVC"
                     object:self userInfo:clicked];
                    [btn removeFromSuperview];
                    
                }
                
            } else {
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"PushToProfileVC"
                 object:self userInfo:clicked];
                [btn removeFromSuperview];
            }
            
        }
        else if (index.intValue==7) {
            
            if ([userType isEqualToString:@"Guest"])
            {
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"PushToAboutVC"
                     object:self userInfo:clicked];
                    [btn removeFromSuperview];
                    
                }
                else
                {
                    [self performSelector:@selector(logout) withObject:self afterDelay:1.0];
                }
                
            } else {
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"PushToSetAvailabilityVC"
                 object:self userInfo:clicked];
                [btn removeFromSuperview];
            }
            
        }
        else if (index.intValue==8) {
            
            if ([userType isEqualToString:@"Guest"])
            {
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
                    
                    [self performSelector:@selector(logout) withObject:self afterDelay:1.0];
                    
                }
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"PushToAboutVC"
                 object:self userInfo:clicked];
                [btn removeFromSuperview];
                
            }
            
        }
        else if (index.intValue==9) {
            
            [self performSelector:@selector(logout) withObject:self afterDelay:1.0];
            
        }
        
    }
    
    [self performSelector:@selector(removeDrawer) withObject:self afterDelay:0.3];
    
}


-(void)logout{
    
    // NSDictionary *userDict = [[responseDict objectForKey:@"profile"] objectAtIndex:0];
    
    [Userdefaults removeObjectForKey:@"ProfInfo"];
    [Userdefaults setObject:@"NO" forKey:@"isLoggedIn"];
    [Userdefaults removeObjectForKey:@"userType"];
    [Userdefaults removeObjectForKey:@"isMacUpdated"];
    [Userdefaults removeObjectForKey:@"isDeviceinfoUpdated"];
    
    [Userdefaults setObject:@"30 min" forKey:@"isMeetingTimeSlot"];
    
    [Userdefaults setBool:NO forKey:@"isETALoopFiredOnce"];
    
    [Userdefaults setBool:NO forKey:@"isETAFiredOnce"];
    
    [Userdefaults setBool:NO forKey:@"within800To400Meter"];
    
    [Userdefaults setBool:NO forKey:@"lessThan400Meter"];
    
    [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
    
    [Userdefaults setBool:NO forKey:@"stepOut"];
    [Userdefaults setBool:NO forKey:@"late"];
    [Userdefaults setBool:NO forKey:@"ETAFired"];
    [Userdefaults setBool:false forKey:@"reschedule"];
    [Userdefaults setBool:NO forKey:@"stopETA"];
    
    [Userdefaults synchronize];
    
    // [db deleteAllUsers];
    
    [self getRegKey];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self->login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        self->nav = [[UINavigationController alloc]initWithRootViewController:self->login];
        
        self.window.rootViewController = self->nav;
        [self.window makeKeyAndVisible];
        
        [self->btn removeFromSuperview];
        
    }];
    
}


-(void)getRegKey{
    
    NSString *deviceToken = @"xyz";
    
    userId = [NSString stringWithFormat:@"%d",(int)[[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":userId,@"reg":deviceToken,@"type":@"Ios"};
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_regkey.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    // NSLog(@"deviceToken: %@", deviceToken);
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSLog(@"token: %@", token);
    
    // [self sendEmailwithBody:token];
    
    [Userdefaults setObject:token forKey:@"deviceToken"];
    
    [Userdefaults synchronize];
}


// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"didReceiveLocalNotification");
}


-(void)localNotif
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
                              if (!granted) {
                                  
                                  NSLog(@"Something went wrong");
                                  
                              }
                              
                          }];
    
}


- (void)registerForRemoteNotifications:(UIApplication *)application
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0")){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                
                if(!error){
                    
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            });
        }];
    }
    else {
        
        // Code for old versions
    }
}


//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    if ([[notification.request.content.userInfo allKeys] count]>0) {
        
        userinfo = notification.request.content.userInfo;
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userinfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = notification.request.content.userInfo;
        
       // NSString *strMsg = notification.request.content.body;
        
        if ([Userdefaults objectForKey:@"ProfInfo"] != nil) {
            
            if ([[notification.request.content.userInfo allKeys] count]>0) {
                
                userDict = [Userdefaults objectForKey:@"ProfInfo"];
                
                userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                
                NSMutableArray *arrNotif = [db getNotifications];
                
                NSString *notifID = [NSString stringWithFormat:@"%d",(int)[arrNotif count]];
                
                NSString *appid = [NSString stringWithFormat:@"%d",(int)[[userinfo objectForKey:@"aps"] objectForKey:@"appid"]];
                
                // NSString *appointmentID = [NSString stringWithFormat:@"%d",(int)[appid integerValue]];
                
                NSString *appointmentID;
                
                if (([appid isEqual:[NSNull null]] )|| (appid==nil) || ([appid isEqualToString:@"<null>"]) || ([appid isEqualToString:@"(null)"]) || (appid.length==0 )|| ([appid isEqualToString:@""])|| (appid==NULL)||(appid == (NSString *)[NSNull null])||[appid isKindOfClass:[NSNull class]]|| (appid == (id)[NSNull null]))
                {
                    appointmentID = @"";
                }
                else
                {
                    appointmentID = [NSString stringWithFormat:@"%d",(int)[appid integerValue]];
                }
                
                
                [db insertInNotificationTableWithNotificationid:notifID anDetails:[[userinfo objectForKey:@"aps"] objectForKey:@"alert"]andUserid:[NSString stringWithFormat:@"%@",userId] andappointmentid:appointmentID];
                
                
                if ([[userInfo allKeys] containsObject:@"aps"]) {
                    
                    NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                    
                    if ([status containsString:@"Do you want to extend the current meeting?"]) {
                        
                        NSDictionary *dictUserDetails = userInfo;
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"@Hipla"
                                                     message:@"Do you want to cancel this appointment?"
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 
                                                 
                                                 
                                             }];
                        
                        
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Cancel"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        
                        [alert addAction:ok];
                        [alert addAction:cancel];
                        
                        
                        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}


//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    if ([[response.notification.request.content.userInfo allKeys] count]>0) {
        
        userinfo = response.notification.request.content.userInfo;
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userinfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        
        if ([Userdefaults objectForKey:@"ProfInfo"] != nil) {
            
            if ([[response.notification.request.content.userInfo allKeys] count]>0) {
                
                userDict = [Userdefaults objectForKey:@"ProfInfo"];
                
                userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                
                NSMutableArray *arrNotif = [db getNotifications];
                
                NSString *notifID = [NSString stringWithFormat:@"%d",(int)[arrNotif count]];
                
                NSString *appid = [NSString stringWithFormat:@"%d",(int)[[userinfo objectForKey:@"aps"] objectForKey:@"appid"]];
                
                // NSString *appointmentID = [NSString stringWithFormat:@"%d",(int)[appid integerValue]];
                
                NSString *appointmentID;
                
                if (([appid isEqual:[NSNull null]] )|| (appid==nil) || ([appid isEqualToString:@"<null>"]) || ([appid isEqualToString:@"(null)"]) || (appid.length==0 )|| ([appid isEqualToString:@""])|| (appid==NULL)||(appid == (NSString *)[NSNull null])||[appid isKindOfClass:[NSNull class]]|| (appid == (id)[NSNull null]))
                {
                    appointmentID = @"";
                }
                else
                {
                    appointmentID = [NSString stringWithFormat:@"%d",(int)[appid integerValue]];
                }
                
                
                [db insertInNotificationTableWithNotificationid:notifID anDetails:[[userinfo objectForKey:@"aps"] objectForKey:@"alert"]andUserid:[NSString stringWithFormat:@"%@",userId] andappointmentid:appointmentID];
                
                
                //                NSMutableArray *arrMeetingDetails = [db getMeetingsById:appointmentID];
                //
                //                if ([arrMeetingDetails count]>0) {
                //
                //                    NSDictionary *dict = [arrMeetingDetails objectAtIndex:0];
                //
                //                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                //
                //                    manageDetails = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingsDetailsViewController"];
                //
                //                    manageDetails.meetingDetailsDictionary = dict;
                //
                //                    [self.window.rootViewController.navigationController pushViewController:manageDetails animated:YES];
                //                }
                
            }
        }
        
    }
    
    completionHandler();
}



#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"_TCS"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
