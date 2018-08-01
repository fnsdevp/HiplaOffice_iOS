//
//  ManageMeetingViewController.m
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "ManageMeetingViewController.h"
#import "ManageMeetingTableViewCell.h"
#import "ScrollTab.h"

@interface ManageMeetingViewController ()

@end


@implementation ManageMeetingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    removeFromView = false;
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
//    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
//
//    if (within400Meter)
//    {
//         [[ZoneDetection sharedZoneDetection] setDelegate:self];
//    }
    
    [self.btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.refreshControl removeFromSuperview];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tblView_ManageMeeting addSubview:self.refreshControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.apple.com";
    
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    // [self fragmentIntializer];
    
}


- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NetPopViewController *forgotVC = [[NetPopViewController alloc]initWithNibName:@"NetPopViewController" bundle:nil];
    forgotVC.view.frame = CGRectMake(0, 35, SCREENWIDTH, SCREENHEIGHT);
    
    if( netStatus == NotReachable){
        
        
        //        [self.view addSubview:forgotVC.view];
        //
        //        [self addChildViewController:forgotVC];
        //        removeFromView = true;
        
        self.view_NoNet.hidden = false;
        
    }else{
        
        //        if (removeFromView == false){
        //
        //        }
        //        else{
        
        //            for (UIView *view in [self.view subviews])
        //            {
        //                [view removeFromSuperview];
        //            }
        //                    UIViewController *vc = [self.childViewControllers lastObject];
        //                    [vc.view removeFromSuperview];
        //                    [vc removeFromParentViewController];
        
        self.view_NoNet.hidden = true;
        
        [self reloadData];
        //        }
        
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
        
        
        //        self.Vw_TableList.hidden = false;
        //        self.view_NetView.hidden = true;
        //        [self  getUpcomingMeetings];
        
        
        
    }
    //    if (reachability == self.hostReachability)
    //    {
    //
    ////        NSLog(@"If internet is not there");
    //
    //    }
    //
    //    if (reachability == self.internetReachability)
    //    {
    //        NSLog(@"If internet is there");
    //
    //    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.isAll = YES;
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    self->appointmentsArray = [[NSMutableArray alloc]init];
    
    self.finalAppointmentListing = [[NSMutableArray alloc] init];
    self.groupAppointmentListing = [[NSMutableArray alloc] init];
    
    if (self.isGroupAppointment) {
        
        [self allGroupAppointments];
        
    } else {
        
        [self getAppointments];
    }
    
    [self.txtfld_Search resignFirstResponder];
    
    
    [self.btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.refreshControl removeFromSuperview];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tblView_ManageMeeting addSubview:self.refreshControl];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //  _navigineCore = nil;
    
    //  [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}

- (void)reloadData
{
    self.finalAppointmentListing = [[NSMutableArray alloc] init];
    
    [self getAppointments];
}


#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isGroupAppointment) {
        
        if(self.isAll){
            
            return [self.groupAppointmentListing count];
            
        }else if(self.isPending){
            
            return [self.pendingAppointmentListing count];
            
        }else if (self.isConfirmed){
            
            return [self.confirmedAppointmentListing count];
        }
        else{
            
            return 0;
        }
        
    } else {
        
        if(self.isAll){
            
            return [self.finalAppointmentListing count];
            
        }else if(self.isPending){
            
            return [self.pendingAppointmentListing count];
            
        }else if (self.isConfirmed){
            
            return [self.confirmedAppointmentListing count];
        }
        else{
            
            return 0;
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"ManageMeetingTableViewCell";
    
    ManageMeetingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[ManageMeetingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.Row = indexPath.row;
    
    if (self.isGroupAppointment) {
        
        if (self.isAll && [self.groupAppointmentListing count] > indexPath.row){
            
            NSDictionary *dict = [self.groupAppointmentListing objectAtIndex:indexPath.row];
            
            NSDictionary *dictGroup = [dict objectForKey:@"group"];
            
            NSDictionary *dictCreator1 = [dictGroup objectForKey:@"creator1"];
            
            cell.lbl_Name.text = [dictCreator1 objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [dictCreator1 objectForKey:@"phone"];
            cell.lbl_EmailId.text = [dictCreator1 objectForKey:@"email"];
            
            
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            NSString *status = [dict objectForKey:@"user_response"];
            
            if ([status isEqualToString:@"pending"]) {
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_pending"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:NO];
                [cell.btn_Confirm setHidden:NO];
                [cell.viewBtns setHidden:YES];
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#f2813f"]];
                
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
                
            }
            else if ([status isEqualToString:@"confirm"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
                
                [cell.btn_Call setHidden:NO];
                [cell.btn_Navigation setHidden:NO];
                [cell.btn_Cancel setHidden:NO];
                [cell.btn_Confirm setHidden:YES];
                [cell.viewBtns setHidden:NO];
                
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
                
            }
            else if ([status isEqualToString:@"cancel"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:YES];
                [cell.btn_Confirm setHidden:YES];
                [cell.viewBtns setHidden:YES];
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
                
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
                
            }
            else if ([status isEqualToString:@"end"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:YES];
                [cell.btn_Confirm setHidden:YES];
                [cell.viewBtns setHidden:YES];
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
                
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
                
            }
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }
        else if(self.isPending && ([self.pendingAppointmentListing count] > indexPath.row)){
            
            NSDictionary *dict = [self.pendingAppointmentListing objectAtIndex:indexPath.row];
            
            NSDictionary *dictGroup = [dict objectForKey:@"group"];
            
            NSDictionary *dictCreator1 = [dictGroup objectForKey:@"creator1"];
            
            cell.lbl_Name.text = [dictCreator1 objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [dictCreator1 objectForKey:@"phone"];
            cell.lbl_EmailId.text = [dictCreator1 objectForKey:@"email"];
            
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_pending"];
            
            [cell.btn_Call setHidden:YES];
            [cell.btn_Navigation setHidden:YES];
            [cell.btn_Cancel setHidden:NO];
            [cell.btn_Confirm setHidden:NO];
            [cell.viewBtns setHidden:YES];
            
            [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#f2813f"]];
            
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
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }else if (self.isConfirmed && ([self.confirmedAppointmentListing count] > indexPath.row)){
            
            NSDictionary *dict = [self.confirmedAppointmentListing objectAtIndex:indexPath.row];
            
            NSDictionary *dictGroup = [dict objectForKey:@"group"];
            
            NSDictionary *dictCreator1 = [dictGroup objectForKey:@"creator1"];
            
            cell.lbl_Name.text = [dictCreator1 objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [dictCreator1 objectForKey:@"phone"];
            cell.lbl_EmailId.text = [dictCreator1 objectForKey:@"email"];
            
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
            
            [cell.btn_Call setHidden:NO];
            [cell.btn_Navigation setHidden:NO];
            [cell.btn_Cancel setHidden:NO];
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
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }
        
    }
    else
    {
        if(self.isAll && ([self.finalAppointmentListing count] > indexPath.row)){
            
            NSDictionary *dict = [self.finalAppointmentListing objectAtIndex:indexPath.row];
            
            cell.lbl_Name.text = [[dict objectForKey:@"userdetails"] objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [[dict objectForKey:@"userdetails"] objectForKey:@"phone"];
            cell.lbl_EmailId.text = [[dict objectForKey:@"userdetails"] objectForKey:@"email"];
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            NSString *status = [dict objectForKey:@"status"];
            
            if ([status isEqualToString:@"pending"]) {
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_pending"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:NO];
                [cell.viewBtns setHidden:YES];
                
                if (self.isRequestMeeting) {
                    
                    //need checking if the meeting time is in past, then need to hide confirm
                    
                    [cell.btn_Confirm setHidden:NO];
                    
                    
                } else {
                    
                    [cell.btn_Confirm setHidden:YES];
                }
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#f2813f"]];
                
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
                
            }
            else if ([status isEqualToString:@"confirm"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
                
                [cell.btn_Call setHidden:NO];
                [cell.btn_Navigation setHidden:NO];
                [cell.btn_Cancel setHidden:NO];
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
                
            }
            else if ([status isEqualToString:@"cancel"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:YES];
                [cell.viewBtns setHidden:YES];
                [cell.btn_Confirm setHidden:YES];
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
                
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
                
            }
            else if ([status isEqualToString:@"end"]){
                
                cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
                
                [cell.btn_Call setHidden:YES];
                [cell.btn_Navigation setHidden:YES];
                [cell.btn_Cancel setHidden:YES];
                [cell.viewBtns setHidden:YES];
                [cell.btn_Confirm setHidden:YES];
                
                [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
                
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
                
            }
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }else if(self.isPending && ([self.pendingAppointmentListing count] > indexPath.row)){
            
            NSDictionary *dict = [self.pendingAppointmentListing objectAtIndex:indexPath.row];
            
            cell.lbl_Name.text = [[dict objectForKey:@"userdetails"] objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [[dict objectForKey:@"userdetails"] objectForKey:@"phone"];
            cell.lbl_EmailId.text = [[dict objectForKey:@"userdetails"] objectForKey:@"email"];
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_pending"];
            
            [cell.btn_Call setHidden:YES];
            [cell.btn_Navigation setHidden:YES];
            [cell.btn_Cancel setHidden:YES];
            [cell.viewBtns setHidden:YES];
            
            if (self.isRequestMeeting) {
                
                [cell.btn_Confirm setHidden:NO];
                
            } else {
                
                [cell.btn_Confirm setHidden:YES];
            };
            
            [cell.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#f2813f"]];
            
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
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }else if (self.isConfirmed && ([self.confirmedAppointmentListing count] > indexPath.row)){
            
            NSDictionary *dict = [self.confirmedAppointmentListing objectAtIndex:indexPath.row];
            
            cell.lbl_Name.text = [[dict objectForKey:@"userdetails"] objectForKey:@"contact"];
            cell.lbl_MobileNumber.text = [[dict objectForKey:@"userdetails"] objectForKey:@"phone"];
            cell.lbl_EmailId.text = [[dict objectForKey:@"userdetails"] objectForKey:@"email"];
            cell.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"fromtime"],[dict objectForKey:@"totime"]];
            
            cell.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
            
            [cell.btn_Call setHidden:YES];
            [cell.btn_Navigation setHidden:YES];
            [cell.btn_Cancel setHidden:NO];
            [cell.viewBtns setHidden:YES];
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
            
            [cell setFmViewController:self.fmViewController];
            
            cell.isAll = self.isAll;
            cell.isPending = self.isPending;
            cell.isConfirmed = self.isConfirmed;
            cell.isGroupAppointment = self.isGroupAppointment;
            
            cell.groupAppointmentListing = self.groupAppointmentListing;
            cell.finalAppointmentListing = self.finalAppointmentListing;
            cell.pendingAppointmentListing = self.pendingAppointmentListing;
            cell.confirmedAppointmentListing = self.confirmedAppointmentListing;
            
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fmViewController) {
        
        NSDictionary *dict = nil;
        
        if (self.isGroupAppointment) {
            
            if(self.isAll){
                
                dict = [self.groupAppointmentListing objectAtIndex:indexPath.row];
            }
            else if(self.isPending){
                
                dict = [self.pendingAppointmentListing objectAtIndex:indexPath.row];
                
            }else if (self.isConfirmed){
                
                dict = [self.confirmedAppointmentListing objectAtIndex:indexPath.row];
            }
            
        } else {
            
            if(self.isAll){
                
                dict = [self.finalAppointmentListing objectAtIndex:indexPath.row];
            }
            else if(self.isPending){
                
                dict = [self.pendingAppointmentListing objectAtIndex:indexPath.row];
                
            }else if (self.isConfirmed){
                
                dict = [self.confirmedAppointmentListing objectAtIndex:indexPath.row];
            }
        }
        
        _fmViewController.isRequestMeeting = self.isRequestMeeting;
        _fmViewController.isGroupAppointment = self.isGroupAppointment;
        
        [_fmViewController didSelectedRow:dict];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - Button actions

- (void)callTap:(id)sender
{
    ManageMeetingTableViewCell* cell = (ManageMeetingTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    if (self.isGroupAppointment) {
        
        if(self.isAll){
            
            dict = [self.groupAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    } else {
        
        if(self.isAll){
            
            dict = [self.finalAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    }
    
    
    NSDictionary *dictUserDetails = nil;
    
    if (self.isGroupAppointment) {
        
        NSDictionary *dictGroup = [dict objectForKey:@"group"];
        
        dictUserDetails = [dictGroup objectForKey:@"creator1"];
        
    }
    else
    {
        dictUserDetails = dict;
    }
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",[[dictUserDetails objectForKey:@"userdetails"]objectForKey:@"phone"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
        
    }
    else
    {
        
        if (_fmViewController) {
            
            [_fmViewController openModal:@"@Hipla" withMessage:@"Call facility is not available!!!" withOK:YES andCancel:NO withDict:nil];
            
        }
        
    }
    
}


- (void)navigateTap:(id)sender
{
    ManageMeetingTableViewCell* cell = (ManageMeetingTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    if (self.isGroupAppointment) {
        
        if(self.isAll){
            
            dict = [self.groupAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    } else {
        
        if(self.isAll){
            
            dict = [self.finalAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    }
    
    NSDictionary *dictUserDetails = nil;
    
    if (self.isGroupAppointment) {
        
        NSDictionary *dictGroup = [dict objectForKey:@"group"];
        
        dictUserDetails = [dictGroup objectForKey:@"creator1"];
        
    }
    else
    {
        dictUserDetails = dict;
    }
    
    if (_fmViewController) {
        
        [_fmViewController didSelectedNavigation:dictUserDetails];
    }
    
}


- (void)cancelTap:(id)sender
{
    ManageMeetingTableViewCell* cell = (ManageMeetingTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    if (self.isGroupAppointment) {
        
        if(self.isAll){
            
            dict = [self.groupAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    } else {
        
        if(self.isAll){
            
            dict = [self.finalAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    }
    
    NSDictionary *dictUserDetails = nil;
    
    if (self.isGroupAppointment) {
        
        NSDictionary *dictGroup = [dict objectForKey:@"group"];
        
        dictUserDetails = [dictGroup objectForKey:@"creator1"];
        
    }
    else
    {
        dictUserDetails = dict;
    }
    
    
    if (_fmViewController) {
        
        [_fmViewController openModal:@"@Hipla" withMessage:@"Do you want to cancel this appointment?" withOK:YES andCancel:YES withDict:dictUserDetails];
        
    }
    
}

- (void)changeAppointment:(NSDictionary *)dict
{
    [self changeAppointmentType:[dict objectForKey:@"id"] withStatus:@"cancel" withDict:dict];
}

- (void)confirmTap:(id)sender
{
    ManageMeetingTableViewCell* cell = (ManageMeetingTableViewCell *)sender;
    
    UIButton* btn = cell.btn_Call;
    
    NSLog(@"sender.tag :%ld",(long)btn.tag);
    
    NSDictionary *dict = nil;
    
    if (self.isGroupAppointment) {
        
        if(self.isAll){
            
            dict = [self.groupAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    } else {
        
        if(self.isAll){
            
            dict = [self.finalAppointmentListing objectAtIndex:cell.Row];
        }
        else if(self.isPending){
            
            dict = [self.pendingAppointmentListing objectAtIndex:cell.Row];
            
        }else if (self.isConfirmed){
            
            dict = [self.confirmedAppointmentListing objectAtIndex:cell.Row];
        }
        
    }
    
    NSDictionary *dictUserDetails = nil;
    
    if (self.isGroupAppointment) {
        
        NSDictionary *dictGroup = [dict objectForKey:@"group"];
        
        dictUserDetails = [dictGroup objectForKey:@"creator1"];
        
    }
    else
    {
        dictUserDetails = dict;
    }
    
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    if (![userType isEqualToString:@"Guest"])
    {
        [self selectRoom:userType withDetails:dictUserDetails];
    }
    else
    {
        [self changeAppointmentType:[dictUserDetails objectForKey:@"id"] withStatus:@"confirm" withDict:dict];
    }
    
}


- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"ALL"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem1:)],
      
      [KxMenuItem menuItem:@"Pending"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem2:)],
      
      [KxMenuItem menuItem:@"Confirm"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem3:)],
      ];
    
    CGRect newFrame = _btnMenu.frame;
    
    newFrame = CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.origin.y, _btnMenu.frame.size.width, _btnMenu.frame.size.height);
    
    [KxMenu showMenuInView:self.view
                  fromRect:newFrame
                 menuItems:menuItems];
    
}


- (IBAction)pushMenuItem1:(id)sender
{
    NSLog(@"%@", sender);
    
    self.isAll = YES;
    self.isPending = NO;
    self.isConfirmed = NO;
    
    if (self.isGroupAppointment) {
        
        [self allGroupAppointments];
        
    } else {
        
        [self getAppointments];
    }
    
}


- (IBAction)pushMenuItem2:(id)sender
{
    NSLog(@"%@", sender);
    
    self.isAll = NO;
    self.isPending = YES;
    self.isConfirmed = NO;
    
    if (self.isGroupAppointment) {
        
        [self allGroupAppointments];
        
    } else {
        
        [self getAppointments];
    }
    
}

- (IBAction)pushMenuItem3:(id)sender
{
    NSLog(@"%@", sender);
    
    self.isAll = NO;
    self.isPending = NO;
    self.isConfirmed = YES;
    
    if (self.isGroupAppointment) {
        
        [self allGroupAppointments];
        
    } else {
        
        [self getAppointments];
    }
    
}


#pragma mark - Api details

-(void)selectRoom:(NSString *)type withDetails:(NSDictionary *)Dict
{
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@all_place.php",BASE_URL];
    
    [manager POST:host_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            NSMutableArray *arrDevice_List = [responseDict objectForKey:@"device_list"];
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"@Hipla" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }]];
            
            for (NSDictionary *dict in arrDevice_List) {
                
                NSString *strName = [dict objectForKey:@"name"];
                
                [actionSheet addAction:[UIAlertAction actionWithTitle:strName style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    if (![type isEqualToString:@"Guest"])
                    {
                        self->locationName = [dict objectForKey:@"place_unique_id"];
                    }
                    
                    [self changeAppointmentType:[Dict objectForKey:@"id"] withStatus:@"confirm" withDict:Dict];
                    
                    // Distructive button tapped.
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                }]];
            }
            
            // Present action sheet.
            [self.fmViewController presentViewController:actionSheet animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        
        // [self checkNet];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
        
    }];
}


-(void)getAppointments{
    
    [SVProgressHUD show];
    
    NSString *host_url= nil;
    
    if (self.isRequestMeeting) {
        
        host_url = [NSString stringWithFormat:@"%@all_request_appointments.php",BASE_URL];
        
    } else {
        
        host_url = [NSString stringWithFormat:@"%@all_appointments.php",BASE_URL];
    }
    
    NSDictionary *params = @{@"userid":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            // self->appointmentsArray = [[NSMutableArray alloc]init];
            
            self->appointmentsArray = [responseDict objectForKey:@"apointments"];
            
            NSMutableArray *reversed = [[[self->appointmentsArray reverseObjectEnumerator] allObjects] mutableCopy];
            
            self->appointmentsArray = [[NSMutableArray alloc]init];
            
            self->appointmentsArray = reversed;
            
            NSLog(@"appointmentsArray :%@",self->appointmentsArray);
            
            if ([self->appointmentsArray count]>0) {
                
                if(self.isAll){
                    
                    NSMutableArray *arrAll  = [NSMutableArray arrayWithArray:self->appointmentsArray];
                    
                    self.finalAppointmentListing = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *dict in arrAll) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            [self.finalAppointmentListing addObject:dict];
                        }
                        
                    }
                    
                }else if(self.isPending){
                    
                    self.pendingAppointmentListing = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dict in self->appointmentsArray) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            NSString *status = [dict objectForKey:@"status"];
                            
                            if([status isEqualToString:@"pending"]){
                                
                                [self.pendingAppointmentListing addObject:dict];
                            }
                        }
                        
                    }
                    
                    self.finalAppointmentListing = self.pendingAppointmentListing;
                    
                }else if (self.isConfirmed){
                    
                    self.confirmedAppointmentListing = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dict in self->appointmentsArray) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            NSString *readStatus = [dict objectForKey:@"status"];
                            
                            if([readStatus isEqualToString:@"confirm"]){
                                
                                [self.confirmedAppointmentListing addObject:dict];
                                
                            }
                            
                        }
                        
                    }
                    
                    self.finalAppointmentListing = self.confirmedAppointmentListing;
                    
                }
                
                [self.tblView_ManageMeeting reloadData];
                
                [self.refreshControl endRefreshing];
                
            } else {
                
                [self.tblView_ManageMeeting reloadData];
                
                [self.refreshControl endRefreshing];
                
                [self->lbl_noMeeting removeFromSuperview];
                
                self->lbl_noMeeting = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tblView_ManageMeeting.frame.origin.y - 30), SCREENWIDTH, self.tblView_ManageMeeting.frame.size.height/2)];
                
                self->lbl_noMeeting.text = @"No meetings found";
                self->lbl_noMeeting.font = [UIFont systemFontOfSize:26];
                self->lbl_noMeeting.numberOfLines = 4;
                self->lbl_noMeeting.baselineAdjustment = YES;
                self->lbl_noMeeting.clipsToBounds = YES;
                self->lbl_noMeeting.backgroundColor = [UIColor clearColor];
                self->lbl_noMeeting.textColor = [UIColor whiteColor];
                self->lbl_noMeeting.textAlignment = NSTextAlignmentCenter;
                
                [self.tblView_ManageMeeting addSubview:self->lbl_noMeeting];
                
            }
            
        }else{
            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No appointments found."
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//            [alertView show];
            
            self.finalAppointmentListing = [[NSMutableArray alloc] init];
            
            [self.tblView_ManageMeeting reloadData];
            
            [SVProgressHUD dismiss];
            
            [self.refreshControl endRefreshing];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD dismiss];
        
        // [self checkNet];
        
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        
        
    }];
    
}


-(void)checkNet{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        
        NetPopViewController *forgotVC = [[NetPopViewController alloc]initWithNibName:@"NetPopViewController" bundle:nil];
        
        forgotVC.view.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT);
        
        [self.view addSubview:forgotVC.view];
        
        [self addChildViewController:forgotVC];
        
        // [self.navigationController pushViewController:forgotVC animated:YES];
        
    }
    else
    {
        
        
    }
    
}


-(void)changeAppointmentType:(NSString *)appointmentId withStatus:(NSString *)status withDict:(NSDictionary *)Dict{
    
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSString *meetingType = [Dict objectForKey:@"appointmentType"];
    
    date = [Dict objectForKey:@"fdate"];
    
    if ([locationName length]==0) {
        
        locationName = [Dict objectForKey:@"location"];
    }
    
    NSDictionary *params;
    
    if ([userType isEqualToString:@"Guest"])
    {
        if ([meetingType isEqualToString:@"flexible"]) {
            
            params = @{@"appid":appointmentId,@"status":status,@"userid":userId,@"date":date};
        }
        else
        {
            params = @{@"appid":appointmentId,@"status":status,@"userid":userId};
        }
    }
    else
    {
        if ([meetingType isEqualToString:@"flexible"]) {
            
            params = @{@"appid":appointmentId,@"status":status,@"location":locationName,@"userid":userId,@"date":date};
        }
        else
        {
            params = @{@"appid":appointmentId,@"status":status,@"location":locationName,@"userid":userId};
        }
    }
    
    
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
             NSString *strMessage = [responseDict objectForKey:@"message"];
            if ([strMessage isEqualToString:@"This time slot already booked, please reshedule your meeting."]){
                
               
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strMessage
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            else{
                
                [self getAppointments];
                
            }
            
            
            if ([status isEqualToString:@"confirm"]) {
                
                //   [self setNotificationwithDetails:[[Dict objectForKey:@"guest"] objectForKey:@"contact"] withDate:[Dict objectForKey:@"fdate"] andTime:[Dict objectForKey:@"fromtime"]];
                
                 //[self setNotificationForMeetingExtention:Dict];
                
            }
            
        }else{
            
            NSString *strMessage = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strMessage
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD dismiss];
        // [self checkNet];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
        
    }];
    
}


-(void)allGroupAppointments{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@all_group_appointments.php",BASE_URL];
    
    NSDictionary *params = @{@"userid":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self->appointmentsArray = [responseDict objectForKey:@"apointments"];
            
            NSMutableArray *reversed = [[[self->appointmentsArray reverseObjectEnumerator] allObjects] mutableCopy];
            
            self->appointmentsArray = [[NSMutableArray alloc]init];
            
            self->appointmentsArray = reversed;
            
            NSLog(@"appointmentsArray :%@",self->appointmentsArray);
            
            if ([self->appointmentsArray count]>0) {
                
                if (self.isAll) {
                    
                    NSMutableArray *arrAll  = [NSMutableArray arrayWithArray:self->appointmentsArray];
                    
                    self.groupAppointmentListing = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *dict in arrAll) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            [self.groupAppointmentListing addObject:dict];
                        }
                        
                    }
                }
                else if(self.isPending){
                    
                    self.pendingAppointmentListing = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dict in self->appointmentsArray) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            NSString *status = [dict objectForKey:@"user_response"];
                            
                            if([status isEqualToString:@"pending"]){
                                
                                [self.pendingAppointmentListing addObject:dict];
                            }
                        }
                        
                    }
                    
                    self.finalAppointmentListing = self.pendingAppointmentListing;
                    
                }else if (self.isConfirmed){
                    
                    self.confirmedAppointmentListing = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dict in self->appointmentsArray) {
                        
                        if (![[Utils sharedInstance] isNullString:[dict objectForKey:@"fdate"]])
                        {
                            NSString *readStatus = [dict objectForKey:@"user_response"];
                            
                            if([readStatus isEqualToString:@"confirm"]){
                                
                                [self.confirmedAppointmentListing addObject:dict];
                                
                            }
                            
                        }
                        
                    }
                    
                    self.finalAppointmentListing = self.confirmedAppointmentListing;
                    
                }
                
                [self.tblView_ManageMeeting reloadData];
                
                [self.refreshControl endRefreshing];
                
            }
            else {
                
                [self.tblView_ManageMeeting reloadData];
                
                [self.refreshControl endRefreshing];
                
                [self->lbl_noMeeting removeFromSuperview];
                
                self->lbl_noMeeting = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tblView_ManageMeeting.frame.origin.y - 30), SCREENWIDTH, self.tblView_ManageMeeting.frame.size.height/2)];
                
                self->lbl_noMeeting.text = @"No meetings found";
                self->lbl_noMeeting.font = [UIFont systemFontOfSize:26];
                self->lbl_noMeeting.numberOfLines = 4;
                self->lbl_noMeeting.baselineAdjustment = YES;
                self->lbl_noMeeting.clipsToBounds = YES;
                self->lbl_noMeeting.backgroundColor = [UIColor clearColor];
                self->lbl_noMeeting.textColor = [UIColor whiteColor];
                self->lbl_noMeeting.textAlignment = NSTextAlignmentCenter;
                
                [self.tblView_ManageMeeting addSubview:self->lbl_noMeeting];
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [SVProgressHUD dismiss];
        
        //[self checkNet];
        //
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        
    }];
    
}


-(void)setStatus{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@set_response.php",BASE_URL];
    
    NSDictionary *params = @{@"userid":userId,@"meeting_id":meeting_id,@"status":status};
    
    //['confirm,may be,cancel']
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        // [self checkNet];
        
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
        //                                                            message:nil
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        
    }];
    
}


#pragma mark Helper

-(void)fragmentIntializer{
    
    ScrollTab *tab = [[ScrollTab alloc] init];
    
    ScrollTabConfig *config = [[ScrollTabConfig alloc] init];
    
    UIColor *twitterBlue = [UIColor colorWithRed:0 green:163/255.f blue:238.f alpha:1];
    
    config.underlineIndicatorColor = twitterBlue;
    config.showUnderlineIndicator = YES;
    config.itemWidth = 83.f;
    config.selectedBackgroundColor = [UIColor whiteColor];
    config.unselectedBackgroundColor = config.selectedBackgroundColor;
    
    // Configuring attribuetd items is simplified here for the example :)
    NSArray *attributedItems = ({
        NSMutableArray *attributedSelection = ({
            NSMutableArray *attributedSelection = [NSMutableArray new];
            
            UIFont *font = [UIFont boldSystemFontOfSize:13];
            NSDictionary *bottomAttributes = @{
                                               NSFontAttributeName:font,
                                               NSForegroundColorAttributeName:[UIColor blackColor]
                                               };
            
            {
                NSAttributedString *attributed = [self _itemAttributedTextWithTop:@"" bottom:@"My Meetings" bottomAttributes:bottomAttributes];
                [attributedSelection addObject:attributed];
            }
            
            {
                NSAttributedString *attributed = [self _itemAttributedTextWithTop:@"" bottom:@"Request Meeting" bottomAttributes:bottomAttributes];
                [attributedSelection addObject:attributed];
            }
            
            
            attributedSelection;
        });
        
        NSArray *attributedUnselection = ({
            NSMutableArray *list = [NSMutableArray new];
            
            UIFont *font = [UIFont boldSystemFontOfSize:20];
            NSDictionary *bottomAttributes = @{
                                               NSFontAttributeName:font,
                                               NSForegroundColorAttributeName:twitterBlue
                                               };
            
            {
                NSAttributedString *attributed = [self _itemAttributedTextWithTop:@"" bottom:@"My Meetings" bottomAttributes:bottomAttributes];
                [list addObject:attributed];
            }
            
            {
                NSAttributedString *attributed = [self _itemAttributedTextWithTop:@"" bottom:@"Request Meeting" bottomAttributes:bottomAttributes];
                [list addObject:attributed];
            }
            
            
            list;
        });
        
        NSMutableArray *list = [NSMutableArray new];
        
        for (NSInteger a=0; a<attributedUnselection.count; a++)
        {
            NSAttributedString  *selected = attributedSelection[a];
            NSAttributedString *unSelected = attributedUnselection[a];
            
            ScrollTabAttributedItem *i = [[ScrollTabAttributedItem alloc] initWithSelectedAttributedText:selected unselectedAttributedText:unSelected];
            
            [list addObject:i];
        }
        
        list;
    });
    config.attributedItems = attributedItems;
    
    tab.config = config;
    tab.backgroundColor = config.selectedBackgroundColor;
    tab.selected = ^(NSString *noop, NSInteger index) {
        NSLog(@"selected tab with index %@", @(index));
    };
    
    // layout
    [self.view addSubview:tab];
    tab.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"tab": tab};
    
    NSDictionary *metrics = @{
                              @"height": @60,
                              @"top": @20
                              };
    NSArray *formats = @[
                         @"|[tab]|",
                         @"V:|-top-[tab(height)]"
                         ];
    [formats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:obj options:kNilOptions metrics:metrics views:views];
        [self.view addConstraints:constraints];
    }];
    
}


- (NSAttributedString *)_itemAttributedTextWithTop:(NSString *)top bottom:(NSString *)bottom bottomAttributes:(NSDictionary *)bottomAttributes;
{
    NSString *string = [NSString stringWithFormat:@"%@\n%@", top, bottom];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:style,
                                 NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    {
        NSRange range = [string rangeOfString:bottom];
        [attributed addAttributes:bottomAttributes range:range];
    }
    
    return attributed;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notifications and methods

-(void)setNotificationwithDetails:(NSString *)name withDate:(NSString *)Date andTime:(NSString *)Time
{
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    
    localNotification.title = @"@Hipla";
    
    localNotification.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"You have a meeting with %@ today on %@. Please open the application or keep it in background to receive notifications.",name,Time] arguments:nil];
    
    localNotification.sound = [UNNotificationSound defaultSound];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDate *twoMinTimerDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",Date,Time]];
    
    NSDate *Date2 = [twoMinTimerDate dateByAddingTimeInterval:-7200];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:Date2];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"add NotificationRequest succeeded!");
            
        }
        
    }];
    
}


-(void)setNotificationForMeetingExtention:(NSDictionary *)dictDetails
{
    UNMutableNotificationContent *localNotification2 = [UNMutableNotificationContent new];
    
    localNotification2.title = @"@Hipla";
    
    localNotification2.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"Do you want to extend the current meeting?"] arguments:nil];
    
    localNotification2.sound = [UNNotificationSound defaultSound];
    
    localNotification2.userInfo = dictDetails;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDate *twoMinTimerDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",[dictDetails objectForKey:@"fdate"],[dictDetails objectForKey:@"totime"]]];
    
    NSDate *Date2 = [twoMinTimerDate dateByAddingTimeInterval:-600];
    
    NSDate *Date1 = [NSDate date];
    
    NSTimeInterval timeInterval = [Date2 timeIntervalSinceDate:Date1];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    localNotification2.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification2 trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"add NotificationRequest succeeded!");
            
        }
        
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        
        manageMeetingDetailsVC = segue.destinationViewController;
        
    }
}



@end
