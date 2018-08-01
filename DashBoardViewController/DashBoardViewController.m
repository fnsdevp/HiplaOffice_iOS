//
//  DashBoardViewController.m
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "DashBoardViewController.h"
#import "DashBoardCollectionViewCell.h"
#import "ManageMeetingTableViewCell.h"

@interface DashBoardViewController (){
    
    NSMutableArray *array_CollectionName;
    NSMutableArray *array_CollectionImages;
    
}

@end


@implementation DashBoardViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
//    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view_NetView.hidden = true;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
//    
//    NSString *remoteHostName = @"www.apple.com";
//    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
//    
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    
//    [self updateInterfaceWithReachability:self.hostReachability];

    userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
//    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
//    
//    if (within400Meter)
//    {
//        [[ZoneDetection sharedZoneDetection] setDelegate:self];
//    }
    
    userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    usertype= [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
    
//    if ([usertype isEqualToString:@"Employee"]){
//
//        array_CollectionName = [[NSMutableArray alloc]initWithObjects:@"Schedule your meeting",@"Hot Desk",@"Order your food",@"Manage Meetings",nil];
//
//        array_CollectionImages = [[NSMutableArray alloc]initWithObjects:@"icn_shcedule_large",@"hot_desk_large",@"pantry_icn_large",@"manage_meeting_large", nil];
//    }
//    else
//    {
    
        array_CollectionName = [[NSMutableArray alloc]initWithObjects:@"Schedule Meeting",@"Your Messages",@"Order Food",@"Manage Meetings",nil];
        
        array_CollectionImages = [[NSMutableArray alloc]initWithObjects:@"icn_shcedule_large",@"message_icn_large",@"pantry_icn_large",@"manage_meeting_large", nil];
    
//    }
    
    [self.refreshControl removeFromSuperview];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tblView_ManageMeeting addSubview:self.refreshControl];
    
    
    
    _PopupView.hidden = YES;

    _PopupView.layer.cornerRadius = 5.0;

    _btnOpenMap.layer.cornerRadius = 5.0;
    _btnOpenMap.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnOpenMap.layer.borderWidth = 2.0;

    _lblTimer.text = @"05.00";

    running = FALSE;

}

- (void)reloadData
{
    [self  getUpcomingMeetings];
    [self.refreshControl endRefreshing];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
//    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
//
//    if (within400Meter)
//    {
//        [[ZoneDetection sharedZoneDetection] setDelegate:self];
//    }
    
    [self.lbl_NoUpcoming setHidden:YES];
    
    self.upcomingMeetingsArr = [[NSMutableArray alloc] init];
    
    [self getUpcomingMeetings];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _navigineCore = nil;
    
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self getZone];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel update_badgeWithViewControllerIndex];
}


-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}


-(void)checkNet{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
        NetPopViewController *forgotVC = [[NetPopViewController alloc]initWithNibName:@"NetPopViewController" bundle:nil];
        forgotVC.view.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT);
        
        [self.navigationController pushViewController:forgotVC animated:YES];
        
    }
    else
    {
        
        
    }
    
}

#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.upcomingMeetingsArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"DashBoardTableViewCell";
    
    DashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[DashBoardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.Row = indexPath.row;
    
    if ([self.upcomingMeetingsArr count]>0)
    {
        NSDictionary *dict = [self.upcomingMeetingsArr objectAtIndex:indexPath.row];
        
        cell.lbl_Name.text = [[dict objectForKey:@"guest"] objectForKey:@"contact"];
        cell.lbl_MobileNumber.text = [[dict objectForKey:@"guest"] objectForKey:@"phone"];
        cell.lbl_EmailId.text = [[dict objectForKey:@"guest"] objectForKey:@"email"];
        
        cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
        
        cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
        
        [cell.btn_Call setHidden:NO];
        [cell.btn_Navigation setHidden:NO];
        
        
//        [cell.btn_Cancel setHidden:NO];
        
       
            cell.btn_Reshedule.hidden = true;
            cell.btn_Cancel.hidden = false;
            
       
        
        [cell.viewBtns setHidden:NO];
        [cell.btn_Confirm setHidden:YES];
        
        [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#37ad57"]];
        
        NSString *Date = [dict objectForKey:@"fdate"];
        NSArray *split = [Date componentsSeparatedByString:@"-"];
        NSLog(@"split :%@",split);
        
        NSString *day = [split objectAtIndex:2];
        NSLog(@"day :%@",day);
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:[split objectAtIndex:1]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        NSLog(@"%@", stringFromDate);
        NSString *month = stringFromDate;
        NSLog(@"month :%@",month);
        
        NSString *year = [split objectAtIndex:0];
        NSLog(@"year :%@",year);
        
        cell.lblDay.text = day;
        cell.lblMonthYear.text = [NSString stringWithFormat:@"%@ %@",month,year];
        
        cell.dictMeetingDetails = dict;
        cell.upcomingMeetingsArr = self.upcomingMeetingsArr;
        
        cell.dbVC = self;
        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.upcomingMeetingsArr count]>0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ManageMeetingDetailViewController* mmdVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingDetailViewController"];
        
        NSDictionary *dict = [self.upcomingMeetingsArr objectAtIndex:indexPath.row];
        
        mmdVC.isRequestMeeting = NO;
        mmdVC.isGroupAppointment = NO;
        mmdVC.dictMeetingDetails = dict;
        mmdVC.fromDashboard = YES;
        
        [self.navigationController pushViewController:mmdVC animated:YES];
        
    }
    
}


#pragma mark- UIcollection view implt

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [array_CollectionName count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) collectionView.collectionViewLayout;
    
    float cellWidth = (CGRectGetWidth(collectionView.frame) - (flowLayout.sectionInset.left + flowLayout.sectionInset.right) - flowLayout.minimumInteritemSpacing) / 2;
    
    float cellHeight = (CGRectGetHeight(collectionView.frame) - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom) - flowLayout.minimumInteritemSpacing) / 2;
    
    return CGSizeMake(cellWidth, cellHeight);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DashBoardCollectionViewCell" forIndexPath:indexPath];
    
    cell.lbl_Name.text = [array_CollectionName objectAtIndex:indexPath.row];
    cell.imageView_Icon.image = [UIImage imageNamed:[array_CollectionImages objectAtIndex:indexPath.row]];
    
    cell.vwBack.layer.cornerRadius = 5.0;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PantryManagement" bundle:[NSBundle mainBundle]];
     UIStoryboard *storyBoardMain = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (collectionView == _collectionView_List) {
        
        switch (indexPath.row) {
            case 0:
                self.tabBarController.selectedIndex = 2;
                
                break;
                
            case 1:
                
//                userDict = [Userdefaults objectForKey:@"ProfInfo"];
//
//                usertype= [NSString stringWithFormat:@"%@",[userDict objectForKey:@"usertype"]];
//
//                if ([usertype isEqualToString:@"Employee"]){
//
//                    HotDeskViewController *hotdesk = [[HotDeskViewController alloc]initWithNibName:@"HotDeskViewController" bundle:nil];
//
//                    hotdesk.isPresent = @"YES";
//
//                    [self.navigationController pushViewController:hotdesk animated:YES];
//
//                }else{
                
                    FragmentMessageViewControllerVC = [storyBoardMain instantiateViewControllerWithIdentifier:@"FragmentMessageViewController"];
                    
                    [self.navigationController pushViewController:FragmentMessageViewControllerVC animated:YES];
                    
//                }
                
                break;
                
            case 2:
                
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
                    
                    NSDictionary* currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
                    
                    PantryViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"PantryViewController"];
                    PantryViewControllerVC.currentMeeting = currentMeeting;
                    [self.navigationController pushViewController:PantryViewControllerVC animated:YES];
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"@Hipla!" message:@"You can't place any order, if you don't have any confirmed meeting. Create a meeting first & wait for confirmation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                }
                
                break;
                
            case 3:
                
                self.tabBarController.selectedIndex = 1;
                
                
                break;
                
            default:
                
                break;
        }
        
    }
    else{
        
        self.tabBarController.selectedIndex = 1;
        
    }
    
}


#pragma mark - Button actions

- (IBAction)callTap:(id)sender
{
    DashBoardTableViewCell* cell = (DashBoardTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    dict = [self.upcomingMeetingsArr objectAtIndex:cell.Row];
    
    NSDictionary *dictUserDetails = dict;
    
    NSString *phoneStr = [NSString  stringWithFormat:@"tel:%@",[[dictUserDetails objectForKey:@"guest"] objectForKey:@"phone"]];
    
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"@Hipla"
                                     message:@"Call facility is not available!!!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


- (IBAction)navigateTap:(id)sender
{
//    NavigationViewController *indoorMap = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
//
//    indoorMap.currentRoom = @"conference area";
//
//    [self.navigationController showViewController:indoorMap sender:nil];
    
    ViewController *indoorMap = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    //    indoorMap.currentRoom = @"conference area";
    
    [self.navigationController showViewController:indoorMap sender:nil];
    
}


- (IBAction)cancelTap:(id)sender
{
    DashBoardTableViewCell* cell = (DashBoardTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    dict = [self.upcomingMeetingsArr objectAtIndex:cell.Row];
    
    NSDictionary *dictUserDetails = dict;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"@Hipla"
                                 message:@"Do you want to cancel this appointment?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             
                             [self changeAppointmentType:[dictUserDetails objectForKey:@"id"] withStatus:@"cancel"];
                             
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
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)rescheduleTap:(id)sender
{
    DashBoardTableViewCell* cell = (DashBoardTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Reshedule;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    dict = [self.upcomingMeetingsArr objectAtIndex:cell.Row];
    
    NSDictionary *dictMeetingDetails = dict;
    
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dt setLocale:locale];
    
    [dt setDateFormat:@"yyyy-MM-dd"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FragmentRescheduleViewController *rescheVC = [storyboard instantiateViewControllerWithIdentifier:@"FragmentRescheduleViewController"];
    
    rescheVC.dictDetails = dictMeetingDetails;
    rescheVC.type = [dictMeetingDetails objectForKey:@"appointmentType"];
    
    [self.navigationController pushViewController:rescheVC animated:YES];
    
}

-(IBAction)btnCloseAction:(id)sender
{
    UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to close this view?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self->_PopupView.hidden = YES;
        
        [self dismissViewControllerAnimated:YES completion: nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion: nil];
        
    }];
    
    [AlertController addAction:OKAction];
    [AlertController addAction:cancelAction];
    
    [self presentViewController: AlertController animated:YES completion:nil];
    
}

-(IBAction)btnOpenDoorAction:(id)sender
{
    [self operateDoor];
}

-(IBAction)btnOpenMap:(id)sender
{
    [self OpenMap];
}


#pragma mark - Api details

-(void)getZone{
    
    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              self->_zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                          }
                                      }];
    
    [dataTask resume];
    
}


-(void)getUpcomingMeetings
{
    if ([userId length]>0) {
        
        [SVProgressHUD show];
        
        NSDictionary *params = @{@"userid":userId};
        
        NSString *host_url = [NSString stringWithFormat:@"%@upcoming_appointments1.php",BASE_URL];
        
        NSLog(@"params : %@",params);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary *responseDict = responseObject;
            
            NSString *success = [responseDict objectForKey:@"status"];
            
            if ([success isEqualToString:@"success"]) {
                
                [SVProgressHUD dismiss];
                
                //self->upcomingMeetingsArr = [[NSMutableArray alloc] init];
                
                self->pastMeetingsArr = [[NSMutableArray alloc] init];
                
                self->meetingsArr = [responseDict objectForKey:@"apointments"];
                
                
                [Common sharedCommonManager].meetingsArr = [NSMutableArray arrayWithArray:self->meetingsArr];
                
                
                self.upcomingMeetingsArr = [[[Common sharedCommonManager] getTodaysMeetings] mutableCopy];
                
                
                if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
                    
                    
                    [[LocationManager sharedManager] startMonitoringLocation];
                    
                }
                else
                {
                    [[LocationManager sharedManager] stopMonitoringLocation];
                    
                }
                
                if ([self->pastMeetingsArr count]>0) {
                    
                    [self endAllConfirmMeetings];
                }
                
                if ([self->meetingsArr count]>0) {
                    
                    [self CheckandSetNotification:self->meetingsArr];
                    
                    [self checkDayofMeeting:self->meetingsArr];
                    
                    [self checkHourofMeeting:self->meetingsArr];
                    
                }
                
                
                if ([self.upcomingMeetingsArr count]>0) {
                    
                    [self->_tblView_ManageMeeting setHidden:NO];
                    
                    [self->_tblView_ManageMeeting reloadData];
                    
                    self.lbl_NoUpcoming.text = nil;
                    
                    self.shareModel = [LocationManager sharedManager];
                    self.shareModel.afterResume = YES;
                    
                    [self.shareModel restartMonitoringLocation];
                    
                }
                else
                {
                    [self->_tblView_ManageMeeting setHidden:YES];
                    
                    [self.lbl_NoUpcoming setHidden:NO];
                    
                    self.lbl_NoUpcoming.text = @"No Upcoming meetings";
                    
                    self.shareModel = [LocationManager sharedManager];
                    self.shareModel.afterResume = NO;
                    
                    [self.shareModel stopMonitoringLocation];
                    
                }
                
            }else{
                
                [self->_tblView_ManageMeeting setHidden:YES];
                
                [self.lbl_NoUpcoming setHidden:NO];
                
                self.lbl_NoUpcoming.text = @"No Upcoming meetings";
                
                [[LocationManager sharedManager] stopMonitoringLocation];
                
//                BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
//
//                if (within400Meter)
//                {
//                    [[ZoneDetection sharedZoneDetection] setDelegate:self];
//                }
//                else
//                {
//                    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
//                }
                
                [SVProgressHUD dismiss];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
//            BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
//
//            if (within400Meter)
//            {
//                [[ZoneDetection sharedZoneDetection] setDelegate:self];
//            }
//            else
//            {
//                [[ZoneDetection sharedZoneDetection] setDelegate:nil];
//            }
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Error: %@", error);
            
            NSString *remoteHostName = @"www.google.com";
            
            NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
            
            //self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
            
           // [self.hostReachability startNotifier];
            
           // [self updateInterfaceWithReachability:self.hostReachability];
            
        }];
        
    }
    
}


-(void)endAppointment:(NSString *)appointmentId{
    
    NSDictionary *params = @{@"appid":appointmentId,@"status":@"end",@"userid":userId};
    
    NSString *host_url = [NSString stringWithFormat:@"%@set_status.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
}


-(void)DayOfMeeting{
    
    
    NSDictionary *params = @{@"userid":userId};
    
    NSLog(@"params :%@",params);
    
    
    NSString *host_url = [NSString stringWithFormat:@"%@checkTime.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            NSLog(@"success");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [self DayOfMeeting];
        
    }];
    
}


-(void)getAllMessages
{
    [SVProgressHUD show];
    
    NSDictionary *params = @{@"userid":userId};
    
    NSString *host_url = [NSString stringWithFormat:@"%@all_messages.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSString *success = [dict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            NSArray *inboxArr = [dict objectForKey:@"inbox"];
            NSArray *outboxArr = [dict objectForKey:@"outbox"];
            
            if (([inboxArr count]==0) && ([outboxArr count]==0)) {
                
                self->unreadMsgCount = 0;
                
            } else {
                
                if ([inboxArr count]>0) {
                    
                    for (NSDictionary *dict in inboxArr) {
                        
                        NSString *status = [dict objectForKey:@"status"];
                        
                        if([status isEqualToString:@"unread"])
                        {
                            self->unreadMsgCount++;
                        }
                    }
                    
                    
                }
                
                if ([outboxArr count]>0) {
                    
                    for (NSDictionary *dict in outboxArr) {
                        
                        NSString *status = [dict objectForKey:@"status"];
                        
                        if([status isEqualToString:@"unread"])
                        {
                            self->unreadMsgCount++;
                        }
                    }
                    
                    
                }
            }
            
            // [self.collectionViewOptions reloadData];
            
        }else{
            
            [SVProgressHUD dismiss];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Problem to get messages, please check your internet connection & restart the app."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }];
    
}


-(void)changeAppointmentType:(NSString *)appointmentId withStatus:(NSString *)status{
    
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"appid":appointmentId,@"status":status,@"userid":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@set_status.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            [self getUpcomingMeetings];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No appointments found."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [SVProgressHUD dismiss];
        
    }];
    
}


-(void)operateDoor{
    
    [SVProgressHUD show];//showWithStatus:@"Please Wait..."];
    
    NSDictionary *params = @{@"userid":userId,@"doorstatus":@"0",@"firefrom":@"app"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"http://eegrab.com/smartoffice/door_status.php"];
    
    [manager POST:host_url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *msg = [responseDict objectForKey:@"status"];
        
        if ([msg isEqualToString:@"success"]) {
            
            if ([Userdefaults boolForKey:@"isPreEntry"]==NO) {
                
                [self->stopTimer invalidate];
                
                self->_lblTimer.hidden = YES;
                self->_btnOpenDoor.hidden = NO;
                self->_btnOpenMap.hidden = NO;
                
            }
            
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [self performSelector:@selector(operateDoor) withObject:nil afterDelay:2.0];
        
        [SVProgressHUD dismiss];
        
    }];
    
}

-(void)sendPushEmployee:(NSString *)appid withBody:(NSString *)body{
    
    // [SVProgressHUD show];
    
    NSDictionary *params;
    
    params = @{@"userid":userId,@"appid":appid,@"body":body};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@customepush_employee.php",BASE_URL];
    
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            //  [SVProgressHUD dismiss];
            
            
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
}


-(void)sendPushGuest:(NSString *)appid withBody:(NSString *)body{
    
    // [SVProgressHUD show];
    
    NSDictionary *params;
    
    params = @{@"userid":userId,@"appid":appid,@"body":body};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@customepush_guest.php",BASE_URL];
    
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            //  [SVProgressHUD dismiss];
            
            
            
        }else{
            
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
}


#pragma mark - Reachability
//
//- (void)updateInterfaceWithReachability:(Reachability *)reachability
//{
//    NetworkStatus netStatus = [reachability currentReachabilityStatus];
//
//    if( netStatus == NotReachable){
//
//      //  self.view_NetView.hidden = false;
//        self.tblView_ManageMeeting.hidden = true;
//        self.lbl_NoUpcoming.hidden = false;
//        self.lbl_NoUpcoming.text = @"No internet connection !!";
//
//    }else{
//
//        self.Vw_TableList.hidden = false;
//        self.view_NetView.hidden = true;
//
//        [self  getUpcomingMeetings];
//
//    }
//
//}
//
//
//- (void) reachabilityChanged:(NSNotification *)note
//{
//    Reachability* curReach = [note object];
//
//    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
//
//    [self updateInterfaceWithReachability:curReach];
//}


#pragma mark - Notifications and methods

- (void)navigationTicker {
    
    // NCDeviceInfo *res = _navigineCore.deviceInfo;
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
        // NSLog(@"RESULT: %lf %lf", res.x, res.y);
        
        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
        
        if ([[dic allKeys] containsObject:@"name"]) {
            
            //            NSLog(@"zone detected:%@",dic);
            
            NSString* zoneName = [dic objectForKey:@"name"];

            if (!_currentZoneName) {

                _currentZoneName = zoneName;

                [self enterZoneWithZoneName:_currentZoneName];

            } else {

                if (![zoneName isEqualToString:_currentZoneName]) {

                    [self exitZoneWithZoneName:_currentZoneName];

                    _currentZoneName = zoneName;

                    [self enterZoneWithZoneName:_currentZoneName];

                } else {

                }
            }
            
        } else {
            
            if (_currentZoneName) {
                
                [self exitZoneWithZoneName:_currentZoneName];
                
                _currentZoneName = nil;
                
            } else {
                
            }
            
        }
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }
    
}


-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            // [self operateLight:@"yes"];
            
            // [self lightOnAndOff:YES];
            
            // [self LightControlMiddle:@"YES"];
            
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults setBool:YES forKey:@"isConferenceArea"];
            
            [Userdefaults synchronize];
            
            //            if ([Userdefaults boolForKey:@"speechConference"]==0) {
            //
            //                AVSpeechUtterance *conference = [AVSpeechUtterance
            //                                                 speechUtteranceWithString:@"You have entered into the conference room. While you be sitted, please order refreshment from our pantryman."];
            //
            //                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
            //
            //                [synth speakUtterance:conference];
            //
            //                [Userdefaults setBool:true forKey:@"speechConference"];
            //
            //                [Userdefaults synchronize];
            //            }
            
        }
        else if ([zoneName isEqualToString:@"PreEntry"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults setBool:YES forKey:@"isPreEntry"];
            
            //[Userdefaults setBool:false forKey:@"restrictedZone"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"entry area"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
           /* BOOL welComeFired = [Userdefaults boolForKey:@"welComeFired"];
            
            if (welComeFired==0) {
                
                [self getDeviceInZone];
                
                if (isLocalFire==0) {
                    
                    isLocalFire = YES;
                    
                    [self startLocalNotification];
                }
            }*/
            
           // [self showTimer];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSelector:@selector(operateDoor) withObject:nil afterDelay:2.0];
                
            });
            
//            if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
//
//                NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
//
//                NSString *userType = [userDict objectForKey:@"usertype"];
//
//                if ([userType isEqualToString:@"Guest"]) {
//
//                    if ([meetingsArr count]>0) {
//
//                        [self checkGuestHaveMeeting:meetingsArr];
//
//                    }
//                    else
//                    {
//                        [self performSelector:@selector(checkGuestHaveMeeting:) withObject:meetingsArr afterDelay:0.2];
//                    }
//
//                }
//
//            }
            
        }
        else if ([zoneName isEqualToString:@"developer bay"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
            // [self operateLight:@"no"];
            
        }
        
    }
    
}


-(void)exitZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            // [self operateLight];
            
            //[self lightOnAndOff:NO];
            
            [Userdefaults setBool:false forKey:@"speechConference"];
            
            [Userdefaults setBool:YES forKey:@"isConferenceArea"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"entry area"])
        {
            [Userdefaults setBool:NO forKey:@"isPreEntry"];
            
            [Userdefaults setBool:NO forKey:@"inRange"];
            
            [Userdefaults synchronize];
    
        }
    }
}



- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}


-(void)endAllConfirmMeetings
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(aQueue,^{
        
        NSLog(@"%s",dispatch_queue_get_label(aQueue));
        
        for (NSDictionary *dict in self->pastMeetingsArr)
        {
            NSString *apointmentId = [dict objectForKey:@"id"];
            
            [self endAppointment:apointmentId];
        }
        
    });
    
}


-(void)CheckandSetNotification:(NSArray *)arrMeetings
{
    for (id object in arrMeetings) {
        
        NSDictionary *dict = object;
        
        NSString *status = [dict objectForKey:@"status"];
        
        if([status isEqualToString:@"confirm"])
        {
            NSString *date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
            
            NSString *time = [NSString stringWithFormat:@"%@",[dict objectForKey:@"time"]];
            
            NSString *dateString = [NSString stringWithFormat:@"%@ %@",date,time];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSDate *currentDate = [NSDate date];
            
            NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:dateFromString];
            
            int minutes = secondsBetween / 60;
            
            if(minutes <= 30)
            {
                [Userdefaults setBool:YES forKey:@"isConfirmFound"];
                
                [Userdefaults synchronize];
            }
            
        }
    }
}

-(void)checkDayofMeeting:(NSArray *)arrMeetings
{
    for (id object in arrMeetings) {
        
        NSDictionary *dict = object;
        
        NSString *status = [dict objectForKey:@"status"];
        
        if([status isEqualToString:@"confirm"])
        {
            NSString *date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
            
            NSString *dateString = [NSString stringWithFormat:@"%@",date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSString *currentdate = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                   dateStyle:NSDateFormatterShortStyle
                                                                   timeStyle:NSDateFormatterFullStyle];
            
            NSString *givendate = [NSDateFormatter localizedStringFromDate:dateFromString
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterFullStyle];
            
            
            if ([currentdate isEqualToString:givendate]) {
                
                [self DayOfMeeting];
                
            }
            
        }
        
    }
    
}


-(void)checkHourofMeeting:(NSArray *)arrMeetings
{
    for (id object in arrMeetings) {
        
        NSDictionary *dict = object;
        
        NSString *status = [dict objectForKey:@"status"];
        
        if([status isEqualToString:@"confirm"])
        {
            NSString *date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
            
            NSString *dateString = [NSString stringWithFormat:@"%@",date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSString *currentdate = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                   dateStyle:NSDateFormatterShortStyle
                                                                   timeStyle:NSDateFormatterFullStyle];
            
            NSDate *cDate = [dateFormatter dateFromString:currentdate];
            
            NSString *givendate = [NSDateFormatter localizedStringFromDate:dateFromString
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterFullStyle];
            
            NSDate *gDate = [dateFormatter dateFromString:givendate];
            
            NSCalendar *c = [NSCalendar currentCalendar];
            
            NSDateComponents *components = [c components:kCFCalendarUnitSecond fromDate:cDate toDate:gDate options:0];
            
            NSInteger diff = components.minute;
            
            if (diff<=(30*60)) {
                
                [self DayOfMeeting];
                
            }
            
        }
        
    }
    
}


-(BOOL)isEmptyString:(NSString *)string;
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
    
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}


-(void)showTimer
{
    _PopupView.hidden = NO;
    _lblTimer.hidden = NO;
    _btnOpenDoor.hidden = YES;
    _btnOpenMap.hidden = YES;
    
    stopTimer = nil;
    
    secondsLeft = 05;
    
    [self performSelector:@selector(startPressed:) withObject:nil afterDelay:0.0];
    
    [self operateDoor];
    
}


-(IBAction)startPressed:(id)sender{
    
    running = TRUE;
    
    millisecond = 10;
    
    second = secondsLeft;
    
    if (stopTimer == nil) {
        
        stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
}


-(void)updateTimer{
    
    if ((millisecond == 0) && (second == 0))
    {
        [stopTimer invalidate];
        
        stopTimer = nil;
        
        _lblTimer.hidden = YES;
        _btnOpenDoor.hidden = NO;
        _btnOpenMap.hidden = NO;
        
    }
    else if ((second>0)||(millisecond>0)) {
        
        if (millisecond == 0)
        {
            millisecond = 10;
            
            second --;
        }
        else if (millisecond == 10)
        {
            second --;
        }
        
        millisecond--;
        
    }
    
    _lblTimer.text = [NSString stringWithFormat:@"%02.0f:%02.0f", second,millisecond];
    
}


-(void)OpenMap
{
    UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to open the map?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
//        NavigationViewController *indoorMap = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
//
//        [self.navigationController pushViewController:indoorMap animated:YES];
        
        ViewController *indoorMap = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        
        //    indoorMap.currentRoom = @"conference area";
        
        [self.navigationController showViewController:indoorMap sender:nil];
        
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion: nil];
        
    }];
    
    [AlertController addAction:OKAction];
    [AlertController addAction:cancelAction];
    
    [self presentViewController: AlertController animated:YES completion:nil];
    
}

-(void)checkGuestHaveMeeting:(NSArray *)arrMeetings
{
    for (id object in arrMeetings) {
        
        NSDictionary *dict = object;
        
        NSString *status = [dict objectForKey:@"status"];
        
        if([status isEqualToString:@"confirm"])
        {
            NSString *date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fdate"]];
            
            NSString *dateString = [NSString stringWithFormat:@"%@",date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSString *currentdate = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                   dateStyle:NSDateFormatterShortStyle
                                                                   timeStyle:NSDateFormatterFullStyle];
            
            NSDate *cDate = [dateFormatter dateFromString:currentdate];
            
            NSString *givendate = [NSDateFormatter localizedStringFromDate:dateFromString
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterFullStyle];
            
            NSDate *gDate = [dateFormatter dateFromString:givendate];
            
            NSCalendar *c = [NSCalendar currentCalendar];
            
            NSDateComponents *components = [c components:NSCalendarUnitSecond fromDate:cDate toDate:gDate options:0];
            
            NSInteger diff = components.minute;
            
            if (diff<=(30*60)) {
                
                NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
                
                NSString *userName = [NSString stringWithFormat:@"%@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
                
                [self sendPushEmployee:[dict objectForKey:@"id"] withBody:[NSString stringWithFormat:@"%@ has arrived",userName]];
                
            }
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
