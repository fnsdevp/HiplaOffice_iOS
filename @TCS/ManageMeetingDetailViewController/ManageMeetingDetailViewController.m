//
//  ManageMeetingDetailViewController.m
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "ManageMeetingDetailViewController.h"

typedef enum{
    
    kPendingType = 1,
    kConfirmType,
    kCancelType,
    kEndType
    
} meetingType;

@interface ManageMeetingDetailViewController ()
{
    meetingType mType;
}

@end


@implementation ManageMeetingDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    [self getNearestUpcomingMeeting];
    
    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
    
    if (within400Meter)
    {
       // [[ZoneDetection sharedZoneDetection] setDelegate:self];
    }
    
    [self showMeetingDetails];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];

    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.txtView_Comments.delegate  = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNearestUpcomingMeeting];
    
    self.tbleView_Comments.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
    
    [self registerForKeyboardNotifications];
    
    [self.btn_AddRecepient setTitle:@"+ Add Receipent" forState:UIControlStateNormal];
    
    [self.btn_AddBelongings setTitle:@"+ Add Belongings" forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.scrollVw_ManageMeeting setContentSize:CGSizeMake(SCREENWIDTH, self.view_Comments.frame.origin.y+self.view_Comments.frame.size.height+30)];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self deregisterFromKeyboardNotifications];
    
  //  _navigineCore = nil;
    
   // [[ZoneDetection sharedZoneDetection] setDelegate:nil];
    
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    
    [self.view endEditing:YES];
    
    if ([self.txtView_Comments.text isEqualToString:@""]) {
        
        self.txtView_Comments.text = @"enter your comments";
    }
}


- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}


-(void)showMeetingDetails
{
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    NSString *status = [_dictMeetingDetails objectForKey:@"status"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    self.etaVw.layer.cornerRadius = 5.0;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    fDateSel = [_dictMeetingDetails objectForKey:@"fdate"];
    
    if (self.fromDashboard) {
        
        self.lbl_Name.text = [[_dictMeetingDetails objectForKey:@"guest"] objectForKey:@"contact"];
        self.lbl_MobileNumber.text = [[_dictMeetingDetails objectForKey:@"guest"] objectForKey:@"phone"];
        self.lbl_EmailId.text = [[_dictMeetingDetails objectForKey:@"guest"] objectForKey:@"email"];
        self.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[_dictMeetingDetails objectForKey:@"fromtime"],[_dictMeetingDetails objectForKey:@"totime"]];
        
    } else {
        
        self.lbl_Name.text = [[_dictMeetingDetails objectForKey:@"userdetails"] objectForKey:@"contact"];
        self.lbl_MobileNumber.text = [[_dictMeetingDetails objectForKey:@"userdetails"] objectForKey:@"phone"];
        self.lbl_EmailId.text = [[_dictMeetingDetails objectForKey:@"userdetails"] objectForKey:@"email"];
        self.lbl_TimingDescription.text = [NSString stringWithFormat:@"%@-%@",[_dictMeetingDetails objectForKey:@"fromtime"],[_dictMeetingDetails objectForKey:@"totime"]];
    }
    
    if ([status isEqualToString:@"pending"]) {
        
        self.imageView_Confirm.image = [UIImage imageNamed:@"icn_pending"];
        
        [self.btn_Call setHidden:YES];
        [self.btn_Navigation setHidden:YES];
        [self.btn_Cancel setHidden:NO];
        
        if (self.isRequestMeeting) {
            
            [self.btn_Confirm setHidden:NO];
            
        } else {
            
            [self.btn_Confirm setHidden:YES];
        }
        
        [self.btn_Chat setHidden:YES];
        [self.btn_Gps setHidden:YES];
        
        [self.etaVw setHidden:YES];
        
        [self.btn_AddRecepient setHidden:YES];
        [self.btn_AddBelongings setHidden:YES];
        
        [self.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#f2813f"]];
        
        isConfirmBtn = YES;
        
        mType = kPendingType;
        
    }
    else if ([status isEqualToString:@"confirm"]){
        
        self.imageView_Confirm.image = [UIImage imageNamed:@"icn_confirm"];
        
        [self.btn_Call setHidden:NO];
        [self.btn_Navigation setHidden:NO];
        [self.btn_Cancel setHidden:NO];
        [self.btn_Confirm setHidden:YES];
        [self.btn_Chat setHidden:YES];
        [self.btn_Gps setHidden:NO];
        
        [self.etaVw setHidden:YES];
        
        if ([userType isEqualToString:@"Guest"]) {
            
            [self.btn_AddRecepient setHidden:NO];
            [self.btn_AddBelongings setHidden:NO];
            
        } else {
            
            [self.btn_AddRecepient setHidden:NO];
            [self.btn_AddBelongings setHidden:YES];
            
        }
        
        [self.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#37ad57"]];
        
        isNavigationBtn = YES;
        isMapBtn = YES;
        isCallBtn = YES;
        
        mType = kConfirmType;
        
        
        if (fromTime!=nil){
            
            NSString *startDateStr = [NSString stringWithFormat:@"%@ %@",[_dictMeetingDetails objectForKey:@"fdate"],fromTime];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
            
            NSDate *startDate = [dateFormatter dateFromString:startDateStr];
            
            NSComparisonResult result = [startDate compare:[NSDate date]];
            
            if (result==NSOrderedSame||result==NSOrderedDescending) {
                
                NSString *toTimeStr = [NSString stringWithFormat:@"%@",[_dictMeetingDetails objectForKey:@"totime"]];
                
                NSDate *hourAgo = [NSDate date];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"hh:mm a"];
                
                NSString* str = [df stringFromDate:hourAgo];
                NSDate* date1 = [df dateFromString:str];
                
                NSDate* date2=[df dateFromString:toTimeStr];
                
                
                NSComparisonResult result = [date1 compare:date2];
                
                if (result==NSOrderedAscending) {
                    
                    [self.etaVw setHidden:NO];
                    
                    LocationManager *shareModel = [LocationManager sharedManager];
                    
                    [shareModel startMonitoringLocation];
                    
                    CLLocationManager * locationManager = shareModel.anotherLocationManager;
                    
                    self.lbldistance.text = @"--";
                    self.lblduration.text = @"--";
                    
                    [self GetDistance:locationManager.location];
                    
                }
                
            }
            
        }
        
        
    }
    else if ([status isEqualToString:@"cancel"]){
        
        self.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
        
        [self.btn_Call setHidden:YES];
        [self.btn_Navigation setHidden:YES];
        [self.btn_Cancel setHidden:YES];
        [self.btn_Confirm setHidden:YES];
        [self.btn_Chat setHidden:YES];
        [self.btn_Gps setHidden:YES];
        
        [self.txtView_Comments setHidden:YES];
        [self.btn_post setHidden:YES];
        [self.tbleView_Comments setHidden:YES];
        
        [self.etaVw setHidden:YES];
        
        [self.btn_AddRecepient setHidden:YES];
        [self.btn_AddBelongings setHidden:YES];
        
        [self.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
        
        mType = kCancelType;
        
    }
    else if ([status isEqualToString:@"end"]){
        
        self.imageView_Confirm.image = [UIImage imageNamed:@"icn_cancel"];
        
        [self.btn_Call setHidden:YES];
        [self.btn_Navigation setHidden:YES];
        [self.btn_Cancel setHidden:YES];
        [self.btn_Confirm setHidden:YES];
        [self.btn_Chat setHidden:YES];
        [self.btn_Gps setHidden:YES];
        
        [self.txtView_Comments setHidden:YES];
        [self.btn_post setHidden:YES];
        [self.tbleView_Comments setHidden:YES];
        
        [self.etaVw setHidden:YES];
        
        [self.btn_AddRecepient setHidden:YES];
        [self.btn_AddBelongings setHidden:YES];
        
        [self.view_CalendarBackground setBackgroundColor:[UIColor colorWithHexString:@"#dc122a"]];
        
        mType = kEndType;
        
    }
    
    NSString *Date = [_dictMeetingDetails objectForKey:@"fdate"];
    
    NSArray *split = [Date componentsSeparatedByString:@"-"];
    NSLog(@"split :%@",split);
    
    NSString *day = [split objectAtIndex:2];
    NSLog(@"day :%@",day);
    
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
    
    self.lblDay.text = day;
    self.lblMonthYear.text = [NSString stringWithFormat:@"%@ %@",month,year];

    
    [self adjustButtons];
    
 //   [self setNotificationwithDetails:[[self.dictMeetingDetails objectForKey:@"guest"] objectForKey:@"contact"] withDate:[self.dictMeetingDetails objectForKey:@"fdate"] andTime:[self.dictMeetingDetails objectForKey:@"fromtime"]];
    
    
    self.lbl_MeetingType.text = [_dictMeetingDetails objectForKey:@"appointmentType"];
    self.txtView_Agenda.text = [_dictMeetingDetails objectForKey:@"agenda"];
    
    appointmentId = [NSString stringWithFormat:@"%d",(int)[[_dictMeetingDetails objectForKey:@"id"] integerValue]];
    
    [self getReviewByAppointmentId:appointmentId];
    
}


#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.postCommentListing count]>0)
    {
        return [self.postCommentListing count];
    }
    else
    {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"CommentTableCell";
    
    CommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[CommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.postCommentListing count]>0) {
        
        NSDictionary *dict = [self.postCommentListing objectAtIndex:indexPath.row];
        
        cell.userImage.image = nil;
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2;
        cell.userImage.backgroundColor = [UIColor lightGrayColor];
        
        NSString *strName = [dict objectForKey:@"username"];
        
        NSArray *subArr = [strName componentsSeparatedByString:@" "];
        
        if ([subArr count]>1) {
            
            NSString *letter1 = [subArr objectAtIndex:0];
            NSString *letter2 = [subArr objectAtIndex:1];
            
            NSString * firstLetter;
            NSString * secondLetter;
            
            if ([letter1 length] > 0) {
                
                firstLetter = [[letter1 substringWithRange:[letter1 rangeOfComposedCharacterSequenceAtIndex:0]] uppercaseString];
            }
            
            if ([letter2 length] > 0) {
                
                secondLetter = [[letter2 substringWithRange:[letter2 rangeOfComposedCharacterSequenceAtIndex:0]] uppercaseString];
            }
            
            cell.lblUserName.text = [NSString stringWithFormat:@"%@%@",firstLetter,secondLetter];
        }
        else
        {
            NSString *letter1 = [subArr objectAtIndex:0];
            
            NSString * firstLetter;
            
            if ([letter1 length] > 0) {
                
                firstLetter = [[letter1 substringWithRange:[letter1 rangeOfComposedCharacterSequenceAtIndex:0]] uppercaseString];
            }
            
            cell.lblUserName.text = [NSString stringWithFormat:@"%@",firstLetter];
        }
        
        cell.lblComment.text = [dict objectForKey:@"review"];
        
        
        return cell;
        
    }
    else
    {
        return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCalender:(id)sender
{
    NSDictionary *dict = self.dictMeetingDetails;
    
    NSDictionary *dictDetails = [dict objectForKey:@"userdetails"];
    
    NSString *status = [dict objectForKey:@"status"];
    
    NSString *getdate = [dict objectForKey:@"fdate"];
    NSArray *split = [getdate componentsSeparatedByString:@"-"];
    NSLog(@"split :%@",split);
    
    NSString *day = [split objectAtIndex:2];
    NSLog(@"day :%@",day);
    
    NSUInteger characterCount = [day length];
    
    if (characterCount == 1) {
        
        day = [NSString stringWithFormat:@"0%@",day];
    }
    
    NSString *month = [split objectAtIndex:1];
    NSLog(@"month :%@",month);
    
    NSString *year = [split objectAtIndex:0];
    NSLog(@"year :%@",year);
    
    NSString *dateTimestr = [NSString stringWithFormat:@"%@-%@-%@ %@",day, month, year,[dict objectForKey:@"fromtime"]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm a"];
    
    NSDate *calenderDate = [dateFormatter dateFromString:dateTimestr];
    
    NSDate *minusthirtyMin = [calenderDate dateByAddingTimeInterval:-30*60];
    
    if ([status isEqualToString:@"confirm"]) {
        
        [SVProgressHUD show];
        
        EKEventStore *store = [EKEventStore new];
        
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            if (granted)
            {
                NSString *appointmentID = [NSString stringWithFormat:@"%@",[self.dictMeetingDetails objectForKey:@"id"]];
                
                if ([appointmentID length]>0) {
                    
                    self->savedEventId = [NSString stringWithFormat:@"%@",[self.dictMeetingDetails objectForKey:@"id"]];
                    
                    if ([self->savedEventId length]>0) {
                        
                        EKEvent *event = [store eventWithIdentifier:self->savedEventId];
                        
                        if (event) {
                            
                            event.title = [NSString stringWithFormat:@"You have seduled an appointement with %@ today.",[dictDetails objectForKey:@"contact"]];
                            
                            event.startDate = minusthirtyMin;
                            
                            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
                            
                            event.calendar = [store defaultCalendarForNewEvents];
                            
                            NSError *err = nil;
                            
                            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                    
                        }
                        else {
                            
                            EKEvent *event = [EKEvent eventWithEventStore:store];
                            
                            event.title = [NSString stringWithFormat:@"You have seduled an appointement with %@ today.",[dictDetails objectForKey:@"contact"]];
                            
                            event.startDate = minusthirtyMin;
                            
                            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
                            
                            event.calendar = [store defaultCalendarForNewEvents];
                            
                            NSError *err = nil;
                            
                            self->savedEventId = event.eventIdentifier;
                            
                            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                            
                        }
                        
                    } else {
                        
                        EKEvent *event = [EKEvent eventWithEventStore:store];
                        
                        event.title = [NSString stringWithFormat:@"You have seduled an appointement with %@ today.",[dictDetails objectForKey:@"contact"]];
                        
                        event.startDate = minusthirtyMin;
                        
                        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
                        
                        event.calendar = [store defaultCalendarForNewEvents];
                        
                        NSError *err = nil;
                        
                        self->savedEventId = event.eventIdentifier;
                        
                        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                       
                    }
                    
                } else {
                    
                    EKEvent *event = [EKEvent eventWithEventStore:store];
                    
                    event.title = [NSString stringWithFormat:@"You have seduled an appointement with %@ today.",[dictDetails objectForKey:@"contact"]];
                    
                    event.startDate = minusthirtyMin;
                    
                    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
                    
                    event.calendar = [store defaultCalendarForNewEvents];
                    
                    NSError *err = nil;
                    
                    self->savedEventId = event.eventIdentifier;
                    
                    [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Meeting saved to calendar successfully."
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                        
                    });
                    
                });
                
            }
            else
            {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User has not granted permission for saving in calender."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
            }
            
        }];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You can only save confirmed appointments."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (IBAction)btnCall:(id)sender {
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",[[self.dictMeetingDetails objectForKey:@"userdetails"] objectForKey:@"phone"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
        
    }
    
}

- (IBAction)btnConfirm:(id)sender {
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    if (![userType isEqualToString:@"Guest"])
    {
        [self selectRoom:userType];
    }
    else
    {
        [self changeAppointmentType:[self.dictMeetingDetails objectForKey:@"id"] withStatus:@"confirm"];
    }

}

- (IBAction)btnCancel:(id)sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"@Hipla"
                                 message:@"Do you want to cancel this appointment?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             
                             [self changeAppointmentType:[self.dictMeetingDetails objectForKey:@"id"] withStatus:@"cancel"];
                             
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


-(IBAction)btnNavigation:(id)sender
{
//    NavigationViewController *indoorMap = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
//
//    [self.navigationController pushViewController:indoorMap animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_objc" bundle:nil];
    ViewController *myVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    
    //    ViewController *indoorMap = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    [self.navigationController pushViewController:myVC animated:YES];
}

-(IBAction)btnGps:(id)sender
{
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        
        NSMutableString *directionsRequest = [NSMutableString   stringWithString:@"comgooglemaps-x-callback://"];
        
        [directionsRequest appendFormat:@"maps.google.com/maps?f=d&daddr=future+netwings&sll=22.573228+88.4505746&sspn=0.2,0.1&nav=1"];
        
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        
        [[UIApplication sharedApplication] openURL:directionsURL options:@{} completionHandler:nil];
        
    } else {
        
        NSLog(@"Can't use comgooglemaps-x-callback://");
    }
}


-(IBAction)btnPost:(id)sender
{
    if([self.txtView_Comments.text isEqualToString:@"enter your comments"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter your comments."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    } else {
        
        [self createReviewByAppointmentId:appointmentId andReview:self.txtView_Comments.text];
        
    }
    
}


-(IBAction)btnRescheduleDidTap:(UIButton *)sender {
    
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    
    NSString *strDateTime = [NSString stringWithFormat:@"%@",fDateSel];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dt setLocale:locale];
    
    [dt setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *FirstDate = [dt dateFromString:strDateTime];
    
    NSDate *currentDate = [NSDate date];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:FirstDate  toDate:currentDate  options:0];
    
    int days = (int)[comps day];
    
    NSLog(@"%d",days);
    
    if (days > 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You cannot reschedule a past meeting."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    } else {
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [dt setLocale:locale];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        FragmentRescheduleViewController *rescheVC = [storyboard instantiateViewControllerWithIdentifier:@"FragmentRescheduleViewController"];
        
        rescheVC.dictDetails = self.dictMeetingDetails;
        
        [self.navigationController pushViewController:rescheVC animated:YES];
        
    }
    
}


- (IBAction)btnAction_AddRecepients:(UIButton *)sender {
    
    [addBelongingsVC.view removeFromSuperview];
    [addRecepientsVC.view removeFromSuperview];
    
    [self.btn_AddRecepient setTitle:@"+ Add Receipent" forState:UIControlStateNormal];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    addRecepientsVC = [storyboard instantiateViewControllerWithIdentifier:@"AddRecepientViewController"];
    
    addRecepientsVC.view.frame = CGRectMake(0,self.view_Comments.frame.origin.y,SCREENWIDTH,self.view_Comments.bounds.size.height);
    
    addRecepientsVC.dictMeetingDetails = self.dictMeetingDetails;
    
    [self.scrollVw_ManageMeeting addSubview:addRecepientsVC.view];
    [self addChildViewController:addRecepientsVC];
    
}


- (IBAction)btnAction_AddBelongings:(UIButton *)sender {
    
    [addBelongingsVC.view removeFromSuperview];
    [addRecepientsVC.view removeFromSuperview];
    
    [self.btn_AddBelongings setTitle:@"+ Add Belongings" forState:UIControlStateNormal];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    addBelongingsVC = [storyboard instantiateViewControllerWithIdentifier:@"AddBelongingsViewController"];
    
    addBelongingsVC.view.frame = CGRectMake(0,self.view_Comments.frame.origin.y,SCREENWIDTH,self.view_Comments.bounds.size.height);
    
    addBelongingsVC.dictMeetingDetails = self.dictMeetingDetails;
    
    [self.scrollVw_ManageMeeting addSubview:addBelongingsVC.view];
    [self addChildViewController:addBelongingsVC];
    
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.txtView_Comments.text = @"";
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if([self.txtView_Comments.text isEqualToString:@""])
    {
        self.txtView_Comments.text = @"enter your comments";
    }
    
    [self.view endEditing:YES];
    
}


- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat viewCommentsY = self.view_Comments.frame.origin.y;
    
    CGFloat extraY = viewCommentsY - keyboardSize.height;
    
    CGPoint scrollPoint = CGPointMake(0.0, -extraY);
    
    [self.scrollVw_ManageMeeting setOrigin:scrollPoint];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    if(![self.txtView_Comments.text isEqualToString:@"enter your comments"])
    {
        
    } else {
        
        self.txtView_Comments.text = @"enter your comments";
        
    }
    
    CGPoint scrollPoint = CGPointMake(0.0, self.view_CompanyNavBar.frame.origin.y+self.view_CompanyNavBar.frame.size.height);
    
    [self.scrollVw_ManageMeeting setOrigin:scrollPoint];
    
}


#pragma mark - Api details

-(void)selectRoom:(NSString *)type
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
                    
                    [self changeAppointmentType:[dict objectForKey:@"id"] withStatus:@"confirm"];
                    
                    // Distructive button tapped.
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                }]];
            }
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
            
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


-(void)getReviewByAppointmentId:(NSString *)appointmentId{
    
    [SVProgressHUD show];
    
    NSDictionary *params;
    
    params = @{@"appid":appointmentId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@all_reviewByapp.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        NSDictionary *dict = responseDict;
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            self.postCommentListing = [dict objectForKey:@"review"];
            
            self.txtView_Comments.text = @"enter your comments";
            
            [self.tbleView_Comments reloadData];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"No Review found."
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


-(void)createReviewByAppointmentId:(NSString *)appointmentId andReview:(NSString *)review{
    
    [SVProgressHUD show];
    
    NSDictionary *params;
    
    params = @{@"appid":appointmentId,@"review":review,@"userid":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@createReview.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            [self.view endEditing:YES];
            
            [self getReviewByAppointmentId:appointmentId];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Review post not done successfully, try again."
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


-(void)changeAppointmentType:(NSString *)appointmentId withStatus:(NSString *)status{
    
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSString *meetingType = [self.dictMeetingDetails objectForKey:@"appointmentType"];
    
    NSString *date = [self.dictMeetingDetails objectForKey:@"fdate"];
    
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
            
            [self getMeetingWithMeetingId:appointmentId];
            
            if ([status isEqualToString:@"confirm"]) {
                
                if (self.fromDashboard) {
                
                   // [self setNotificationwithDetails:[[self.dictMeetingDetails objectForKey:@"guest"] objectForKey:@"contact"] withDate:[self.dictMeetingDetails objectForKey:@"fdate"] andTime:[self.dictMeetingDetails objectForKey:@"fromtime"]];
                    
                   // [self setNotificationForMeetingExtention:self.dictMeetingDetails];
                    
                } else {
                    
                   // [self setNotificationwithDetails:[[self.dictMeetingDetails objectForKey:@"userdetails"] objectForKey:@"contact"] withDate:[self.dictMeetingDetails objectForKey:@"fdate"] andTime:[self.dictMeetingDetails objectForKey:@"fromtime"]];
                    
                   // [self setNotificationForMeetingExtention:self.dictMeetingDetails];
                    
                }
                
            }
            
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


-(void)getMeetingWithMeetingId:(NSString *)appointmentId{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@appointments_details_by_id.php",BASE_URL];
    
    NSDictionary *params = @{@"meeting_id":appointmentId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self->_dictMeetingDetails = [[responseDict objectForKey:@"apointments"] objectAtIndex:0];
            
            [self showMeetingDetails];
            
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

-(void)GetDistance:(CLLocation *)location
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f+%f&destinations=%@&key=%@",location.coordinate.latitude,location.coordinate.longitude,latLong,API_KEY];
    
    // 22.593484, 88.434506
    //22.573075+88.452580 - future netwings
    //  NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=park+street,kolkata&destinations=future+netwings&key=%@",API_KEY];
    
    [manager GET:hostUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSArray *rows = [dict objectForKey:@"rows"];
        
        if ([rows count]>0) {
            
            NSDictionary *elements = [rows objectAtIndex:0];
            
            NSArray *details = [elements objectForKey:@"elements"];
            
            NSDictionary *ETAinfo = [details objectAtIndex:0];
            
            NSDictionary *distanceDic = [ETAinfo objectForKey:@"distance"];
            
            NSDictionary *durationDic = [ETAinfo objectForKey:@"duration"];
            
            self->distance = [distanceDic objectForKey:@"text"];
            
            self->duration = [durationDic objectForKey:@"text"];
            
            double dist = 0.0;
            double dur = 0.0;
            
            NSArray *arrUnit = [self->distance componentsSeparatedByString:@" "];
            NSArray *durUnit = [self->duration componentsSeparatedByString:@" "];
            NSString *addressStr;
            NSString *durationStr;
            
            if ([arrUnit count]>0) {
                
               addressStr = [arrUnit firstObject];
                durationStr = [durUnit firstObject];
                
                dist = [addressStr doubleValue];
                
                if ([arrUnit containsObject:@"km"]) {
                    
                    dist = dist *1000;
                    
                }
                if([durUnit count] >2){
                    
                    double hour = [[durUnit objectAtIndex:0] doubleValue];
                    double min = [[durUnit objectAtIndex:2] doubleValue];
                    
                    dur = hour*60+min;
                    
                    
                }else{
                    
                    if([durUnit containsObject:@"min"]){
                        
                        dur = [durationStr doubleValue];
                    }
                }
            }
            
            self.lbldistance.text = [NSString stringWithFormat:@"%@ %@",addressStr,arrUnit[1]];
            
            self.lblduration.text = [NSString stringWithFormat:@"%@ %@",durationStr,durUnit[1]];
            
        }
        
        [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
        
        [Userdefaults synchronize];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [Userdefaults setBool:NO forKey:@"GetDistanceFired"];
        
        [Userdefaults synchronize];
        
    }];
    
}


#pragma mark - Notifications and methods

-(void)adjustButtons
{
    switch (mType) {
            
        case kPendingType:
            [self setButtons:kPendingType];
            break;
            
        case kConfirmType:
            [self setButtons:kConfirmType];
            break;
            
        case kCancelType:
            [self setButtons:kCancelType];
            break;
            
        case kEndType:
            [self setButtons:kEndType];
            break;
            
        default:
            break;
    }
}

-(void)setButtons:(meetingType)type
{
    if (type==kPendingType) {
        
        [self createButton];
        
    }
    else if (type==kConfirmType) {
        
        [self createButton];
        
    }
    else if (type==kCancelType) {
        
        
    }
    else if (type==kEndType) {
        
        
        
    }
    else {
        
        
    }
}


-(void)createButton
{
    x = 7.0;
    
    float btnPart_width = self.view_status.frame.size.width/5.0;
    
    float width = self.btn_Confirm.frame.size.width;
    
    float height = self.btn_Confirm.frame.size.height;
    
    if (isConfirmBtn) {
        
        self.btn_Confirm.frame = CGRectMake(x, 0.0, width, height);
        
        [self.view_status addSubview:self.btn_Confirm];
        
        x = x+btnPart_width;
    }
    
    if (isNavigationBtn) {
        
        self.btn_Navigation.frame = CGRectMake(x, 0.0, width, height);
        
        [self.view_status addSubview:self.btn_Navigation];
        
        x = x+btnPart_width;
    }
    
    if (isCallBtn) {
        
        self.btn_Call.frame = CGRectMake(x, 0.0, width, height);
        
        [self.view_status addSubview:self.btn_Call];
        
        x = x+btnPart_width;
    }
    
    if (isMapBtn) {
        
        self.btn_Gps.frame = CGRectMake(x, 0.0, width, height);
        
        [self.view_status addSubview:self.btn_Gps];
        
        x = x+btnPart_width;
    }
    
    if (isResceduleBtn) {
        
        self.btn_Chat.frame = CGRectMake(x, 0.0, width, height);
        
        [self.view_status addSubview:self.btn_Chat];
        
        x = x+btnPart_width;
    }
    
}


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

- (void)getNearestUpcomingMeeting{
    
    if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours])
    {
        currentMeeting = [[Common sharedCommonManager] meetingDetailsForCurrentMeetings];
        NSLog(@"%@",currentMeeting);
        fromTime = [currentMeeting objectForKey:@"fromtime"];
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
