//
//  SetAvailabilityViewController.m
//  @TCS
//
//  Created by FNSPL on 14/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "SetAvailabilityViewController.h"
#import "SetAvailabilityTableViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface SetAvailabilityViewController ()

@end

@implementation SetAvailabilityViewController

- (void)viewDidLoad {
    
   // [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    db = [Database sharedDB];
  
    [self getUseravailTimeAll];
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    
//    [navView removeFromSuperview];
//}

- (IBAction)btnDrawerMenuDidTap:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenDrawer"
     object:self];
}

-(NSArray *)setTheDate:(NSDate *)Date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [calendar startOfDayForDate:Date];
    
    NSLog(@"%@", startDate);
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss YYYY"];
    NSString *startDateStr = [format stringFromDate:startDate];
    
    NSArray *dateArr = [startDateStr componentsSeparatedByString:@" "];
    
    return dateArr;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SetAvailabilityTableViewCell";
    
    SetAvailabilityTableViewCell *cell = (SetAvailabilityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetAvailabilityTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.fromDateBtn addTarget:self action:@selector(btnFormDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.fromDateBtn.tag = indexPath.row;
    cell.fromDatelbl.tag = indexPath.row;
    
    cell.toDateBtn.tag = indexPath.row;
    cell.toDatelbl.tag = indexPath.row;
    
    cell.availon.tag = indexPath.row;
    
    cell.tag = indexPath.row;
    
    
    [cell.toDateBtn addTarget:self action:@selector(btnToDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.availon addTarget: self action: @selector(btnAvailonDidTap:) forControlEvents: UIControlEventValueChanged];
    
    
    if (indexPath.row==0) {
        
        nextday = [NSDate date];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"EEE"];
        
        day = [df stringFromDate:nextday];
        
        cell.weeklbl.text = [NSString stringWithFormat:@"%@",day];
        
        [df setDateFormat:@"d MMM, yyyy"];
        
        date = [df stringFromDate:nextday];
        
        cell.datelbl.text = [NSString stringWithFormat:@"%@",date];
        
        
    }
    else
    {
        nextday = [NSDate date];
        nextday = [NSDate dateWithTimeInterval:((indexPath.row)*(24*60*60)) sinceDate:nextday];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"EEE"];
        
        day = [df stringFromDate:nextday];
        
        cell.weeklbl.text = [NSString stringWithFormat:@"%@",day];
        
        [df setDateFormat:@"d MMM, yyyy"];
        
        date = [df stringFromDate:nextday];
        
        cell.datelbl.text = [NSString stringWithFormat:@"%@",date];
        
    }
    
    
    if ([userAvailArr count]>0) {
        
        NSString *Status;
        
        if (indexPath.row <=[userAvailArr count]-1) {
            
            Status = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:indexPath.row] objectForKey:@"isON"]];
            
            if ([Status isEqualToString:@"Y"]) {
                
                NSString *FromDate = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:indexPath.row] objectForKey:@"fromTime"]];
                
                [cell.fromDateBtn setTitle:FromDate forState:UIControlStateNormal];
                
                NSString *ToDate = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:indexPath.row] objectForKey:@"toTime"]];
                
                [cell.toDateBtn setTitle:ToDate forState:UIControlStateNormal];
                
                [cell.availon setOn:YES];
                
            } else {
                
                NSString *FromDate = [NSString stringWithFormat:@" "];
                
                [cell.fromDateBtn setTitle:FromDate forState:UIControlStateNormal];
                
                NSString *ToDate = [NSString stringWithFormat:@" "];
                
                [cell.toDateBtn setTitle:ToDate forState:UIControlStateNormal];
                
                [cell.availon setOn:NO];
            }
        }
        else
        {
            NSString *FromDate = [NSString stringWithFormat:@" "];
            
            [cell.fromDateBtn setTitle:FromDate forState:UIControlStateNormal];
            
            NSString *ToDate = [NSString stringWithFormat:@" "];
            
            [cell.toDateBtn setTitle:ToDate forState:UIControlStateNormal];
            
            
            [cell.availon setOn:NO];
            
        }
        
    } else {
        
        [cell.availon setOn:NO];
        
        date =  [NSString stringWithFormat:@"%@",cell.datelbl.text];
        
        day = [NSString stringWithFormat:@"%@",cell.weeklbl.text];
        
        from = [NSString stringWithFormat:@" "];
        
        to = [NSString stringWithFormat:@" "];
        
        status = @"N";
        
        [db insertInUseravailTableWithTag:[NSString stringWithFormat:@"%d",(int)indexPath.row] andDate:date andday:day andFromTime:from andToTime:to andisON:status];
        
    }
    
   
    
    return cell;
}


- (IBAction)btnFormDidTap:(UIButton *)sender {
    
    [timePicker removeFromSuperview];
    
    timePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - (260+44)), SCREENWIDTH, 260)];
    
    timePicker.datePickerMode = UIDatePickerModeDate;
    timePicker.hidden = NO;
    timePicker.date = [NSDate date];
    timePicker.datePickerMode = UIDatePickerModeTime;
    
    timePicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:timePicker];
    
    isFormDate = YES;
    
    //NSLog(@"%d",(int)sender.tag);
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, (SCREENHEIGHT - (260+44+44)), SCREENWIDTH, 44);
    
    UIBarButtonItem *button1=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction:)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)];
    
    button2.tag = sender.tag;
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,flexibleItem,button2, nil]];
    
    [self.view addSubview:toolbar];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"]; // from here u can change format..
    
    fromdate=[df stringFromDate:timePicker.date];
}


- (IBAction)btnToDidTap:(UIButton *)sender {
    
    [timePicker removeFromSuperview];
    
    timePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - (260+44)), SCREENWIDTH, 260)];
    
    timePicker.hidden = NO;
    timePicker.date = [NSDate date];
    timePicker.datePickerMode = UIDatePickerModeTime;
    
    timePicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:timePicker];
    
    isFormDate = NO;
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, (SCREENHEIGHT - (260+44+44)), SCREENWIDTH, 44);
    
    UIBarButtonItem *button1=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction:)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)];
    
    button2.tag = sender.tag;
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,flexibleItem,button2, nil]];
    
    [self.view addSubview:toolbar];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"hh:mm a"];
    
    todate=[df stringFromDate:timePicker.date];
    
   
}


- (IBAction)sendAction:(UIButton *)sender {
    
    [timePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    
    NSLog(@"%d",(int)sender.tag);
    
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:(int)sender.tag inSection:0] ;
    
    SetAvailabilityTableViewCell *cell = (SetAvailabilityTableViewCell *)[_tblAvailability cellForRowAtIndexPath:myIndex];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"]; // from here u can change format..
    
    
    NSLog(@"%d",(int)cell.tag);
    
    
    if (isFormDate) {
        
        fromdate=[df stringFromDate:timePicker.date];
        
        [cell.fromDateBtn setTitle:fromdate forState:UIControlStateNormal];
        
    } else {
        
        todate=[df stringFromDate:timePicker.date];
        
        [cell.toDateBtn setTitle:todate forState:UIControlStateNormal];
    }
    
    
    if ([userAvailArr count]>0) {
        
        if (sender.tag<=([userAvailArr count]-1)) {
            
            NSString *Status = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:cell.tag] objectForKey:@"isON"]];
            
            if ([Status isEqualToString:@"Y"])
            {
                [self setAvailabilityCallonCell:cell withSender:sender];
            }
            
        }
        else
        {
            NSString *Status = @"Y";
            
            if ([Status isEqualToString:@"Y"])
            {
                [self setAvailabilityCallonCell:cell withSender:sender];
            }
        }
        
    }
    
}


- (IBAction)cancelAction:(id)sender {
    
    [timePicker removeFromSuperview];
    [toolbar removeFromSuperview];
}


- (IBAction)btnAvailonDidTap:(UIButton *)sender {
    
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:(int)sender.tag inSection:0] ;
    
    SetAvailabilityTableViewCell *cell = (SetAvailabilityTableViewCell *)[_tblAvailability cellForRowAtIndexPath:myIndex];
    
    if ([userAvailArr count]>0) {
        
        if (sender.tag<=([userAvailArr count]-1)) {
            
            NSString *Status = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:cell.tag] objectForKey:@"isON"]];
            
            if ([Status isEqualToString:@"Y"]) {
                
                status = @"N";
                
                [self setAvailabilityCallonCell:cell withSender:sender];
            }
            else
            {
                status = @"Y";
                
                [self setAvailabilityCallonCell:cell withSender:sender];
            }
        }
        else
        {
            status = @"Y";
            
            [self setAvailabilityCallonCell:cell withSender:sender];
        }
        
    } else {
        
        status = @"Y";
        
        [self setAvailabilityCallonCell:cell withSender:sender];
    }
    
}


-(void)setAvailabilityCallonCell:(SetAvailabilityTableViewCell *)cell withSender:(UIButton *)sender
{
    [SVProgressHUD show];
    
    userAvailArr = [db getUseravail];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    date =  [NSString stringWithFormat:@"%@",cell.datelbl.text];
    
    day = [NSString stringWithFormat:@"%@",cell.weeklbl.text];
    
    from = [NSString stringWithFormat:@"%@",cell.fromDateBtn.titleLabel.text];
    
    to = [NSString stringWithFormat:@"%@",cell.toDateBtn.titleLabel.text];
    
    
    if ([from isEqualToString:@" "]) {
        
        from = @"10:00 AM";
    }
    else if (([from isEqual:[NSNull null]] )|| (from==nil) || ([from isEqualToString:@"<null>"]) || ([from isEqualToString:@"(null)"]) || (from.length==0 )|| ([from isEqualToString:@""])|| (from==NULL)||(from == (NSString *)[NSNull null])||[from isKindOfClass:[NSNull class]]|| (from == (id)[NSNull null]))
    {
        from = @"10:00 AM";
    }
    
    
    if ([to isEqualToString:@" "]) {
        
        to = @"06:00 PM";
    }
    else if (([to isEqual:[NSNull null]] )|| (to==nil) || ([to isEqualToString:@"<null>"]) || ([to isEqualToString:@"(null)"]) || (to.length==0 )|| ([to isEqualToString:@""])|| (to==NULL)||(to == (NSString *)[NSNull null])||[to isKindOfClass:[NSNull class]]|| (to == (id)[NSNull null]))
    {
        to = @"06:00 PM";
    }
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"d MMM, yyyy"];
    
    NSDate *Date2 = [df dateFromString:date];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateNew = [df stringFromDate:Date2];
    
    NSString *Status;
    
    if ([userAvailArr count]>0) {
        
        if (sender.tag<=([userAvailArr count]-1)) {
            
            Status = [NSString stringWithFormat:@"%@",[[userAvailArr objectAtIndex:cell.tag] objectForKey:@"isON"]];
        }
        else
        {
            Status = @"Y";
        }
        
    } else {
        
        Status = @"Y";
    }
    
    if ([Status isEqualToString:@"Y"]) {
        
        status = @"N";
    }
    else
    {
        status = @"Y";
    }
    
    
    NSDictionary *params = @{@"userid":userID,@"date":dateNew,@"day":day,@"from":from,@"to":to,@"status":status};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"%@set_avail.php",BASE_URL];
    
    [manager POST:hostUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [self->db deleteAllUserAvailTimes];
            
            [self getUseravailTimeAll];
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server appears to be unavailable this time,please try again."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [cell.availon setOn:!self->isON animated:YES];
        
        [SVProgressHUD dismiss];
    }];
}


-(void)getUseravailTimeAll
{
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_time.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        [self->db deleteAllUserAvailTimes];
        
        if ([success isEqualToString:@"success"])
        {
            NSArray *arrTiming = [responseDict objectForKey:@"timing"];
            
            for (int i=0; i<[arrTiming count]; i++) {
                
                NSString *Date = [[arrTiming objectAtIndex:i] objectForKey:@"date"];
                NSString *Day = [[arrTiming objectAtIndex:i] objectForKey:@"day"];
                NSString *From = [[arrTiming objectAtIndex:i] objectForKey:@"from"];
                NSString *To = [[arrTiming objectAtIndex:i] objectForKey:@"to"];
                NSString *Status = [[arrTiming objectAtIndex:i] objectForKey:@"status"];
                
                
                if (([Status isEqual:[NSNull null]] )|| (Status==nil) || ([Status isEqualToString:@"<null>"]) || ([Status isEqualToString:@"(null)"]) || (Status.length==0 )|| ([Status isEqualToString:@""])|| (Status==NULL)||(Status == (NSString *)[NSNull null])||[Status isKindOfClass:[NSNull class]]|| (Status == (id)[NSNull null]))
                {
                    Status = @"";
                }
                
                if (([From isEqual:[NSNull null]] )|| (From==nil) || ([From isEqualToString:@"<null>"]) || ([From isEqualToString:@"(null)"]) || (From.length==0 )|| ([From isEqualToString:@""])|| (From==NULL)||(From == (NSString *)[NSNull null])||[From isKindOfClass:[NSNull class]]|| (From == (id)[NSNull null]))
                {
                    From = @"";
                }
                
                if (([To isEqual:[NSNull null]] )|| (To==nil) || ([To isEqualToString:@"<null>"]) || ([To isEqualToString:@"(null)"]) || (To.length==0 )|| ([To isEqualToString:@""])|| (To==NULL)||(To == (NSString *)[NSNull null])||[To isKindOfClass:[NSNull class]]|| (To == (id)[NSNull null]))
                {
                    To = @"";
                }
                
                if (([Day isEqual:[NSNull null]] )|| (Day==nil) || ([Day isEqualToString:@"<null>"]) || ([Day isEqualToString:@"(null)"]) || (Day.length==0 )|| ([Day isEqualToString:@""])|| (Day==NULL)||(Day == (NSString *)[NSNull null])||[Day isKindOfClass:[NSNull class]]|| (Status == (id)[NSNull null]))
                {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *dt = [df dateFromString:Date];
                    
                    [df setDateFormat:@"EEE"];
                    
                    Day = [df stringFromDate:dt];
                }
                
                [self->db insertInUseravailTableWithTag:[NSString stringWithFormat:@"%d",i] andDate:Date andday:Day andFromTime:From andToTime:To andisON:Status];
                
            }
            
            [SVProgressHUD dismiss];
            
            self->userAvailArr = [self->db getUseravail];
            
            [self.tblAvailability reloadData];
            
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


-(void)getUseravailTimeforDate:(NSString *)Date
{
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":userId,@"date":Date};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_time_by_dateNuserid.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        [self->db deleteAllUserAvailTimes];
        
        if ([success isEqualToString:@"success"])
        {
            NSArray *arrTiming = [responseDict objectForKey:@"timing"];
            
            for (int i=0; i<[arrTiming count]; i++) {
                
                NSString *Date = [[arrTiming objectAtIndex:i] objectForKey:@"date"];
                NSString *Day = [[arrTiming objectAtIndex:i] objectForKey:@"day"];
                NSString *From = [[arrTiming objectAtIndex:i] objectForKey:@"from"];
                NSString *To = [[arrTiming objectAtIndex:i] objectForKey:@"to"];
                NSString *Status = [[arrTiming objectAtIndex:i] objectForKey:@"status"];
                
                
                if (([Status isEqual:[NSNull null]] )|| (Status==nil) || ([Status isEqualToString:@"<null>"]) || ([Status isEqualToString:@"(null)"]) || (Status.length==0 )|| ([Status isEqualToString:@""])|| (Status==NULL)||(Status == (NSString *)[NSNull null])||[Status isKindOfClass:[NSNull class]]|| (Status == (id)[NSNull null]))
                {
                    Status = @"";
                }
                
                if (([From isEqual:[NSNull null]] )|| (From==nil) || ([From isEqualToString:@"<null>"]) || ([From isEqualToString:@"(null)"]) || (From.length==0 )|| ([From isEqualToString:@""])|| (From==NULL)||(From == (NSString *)[NSNull null])||[From isKindOfClass:[NSNull class]]|| (From == (id)[NSNull null]))
                {
                    From = @"";
                }
                
                if (([To isEqual:[NSNull null]] )|| (To==nil) || ([To isEqualToString:@"<null>"]) || ([To isEqualToString:@"(null)"]) || (To.length==0 )|| ([To isEqualToString:@""])|| (To==NULL)||(To == (NSString *)[NSNull null])||[To isKindOfClass:[NSNull class]]|| (To == (id)[NSNull null]))
                {
                    To = @"";
                }
                
                if (([Day isEqual:[NSNull null]] )|| (Day==nil) || ([Day isEqualToString:@"<null>"]) || ([Day isEqualToString:@"(null)"]) || (Day.length==0 )|| ([Day isEqualToString:@""])|| (Day==NULL)||(Day == (NSString *)[NSNull null])||[Day isKindOfClass:[NSNull class]]|| (Status == (id)[NSNull null]))
                {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *dt = [df dateFromString:Date];
                    
                    [df setDateFormat:@"EEE"];
                    
                    Day = [df stringFromDate:dt];
                }
                
                [self->db insertInUseravailTableWithTag:[NSString stringWithFormat:@"%d",i] andDate:Date andday:Day andFromTime:From andToTime:To andisON:Status];
                
            }
            
            [SVProgressHUD dismiss];
            
            self->userAvailArr = [self->db getUseravail];
            
            [self.tblAvailability reloadData];
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

- (IBAction)btnAction_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
