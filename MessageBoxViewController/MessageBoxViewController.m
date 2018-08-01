//
//  MessageBoxViewController.m
//  @TCS
//
//  Created by FNSPL on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "MessageBoxViewController.h"
#import "CreateMessageViewController.h"


@interface MessageBoxViewController (){
  
}

@end


@implementation MessageBoxViewController

- (void)viewDidLoad {
    
   // [super viewDidLoad];
    
    [_button_Category addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrayAllMessages=[[NSMutableArray alloc]init];
    
    self.str_ChangeURL = @"all_messages.php";
    
    self.tblView_MessageBox.tableFooterView = [[UIView alloc]
                                               initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.apple.com";
    
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    [self getAllMessageswithType:self.str_ChangeURL];
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tblView_MessageBox.tableFooterView = [[UIView alloc]
                                              initWithFrame:CGRectZero];
    
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
    if( netStatus == NotReachable){
        
        
        //        [self.view addSubview:forgotVC.view];
        //
        //        [self addChildViewController:forgotVC];
        //        removeFromView = true;
        
        self.viewNetView.hidden = false;
        
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
        
        self.viewNetView.hidden = true;
        self.str_ChangeURL = @"all_messages.php";
        [self getAllMessageswithType:self.str_ChangeURL];

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


- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"ALL"
                     image:nil
                    target:self
                    action:@selector(pushMenuALL:)],
      
      [KxMenuItem menuItem:@"Read"
                     image:nil
                    target:self
                    action:@selector(pushMenuRead:)],
      
      [KxMenuItem menuItem:@"Unread"
                     image:nil
                    target:self
                    action:@selector(pushMenuUnread:)],
      ];
    
    CGRect newFrame = _button_Category.frame;
    
    newFrame = CGRectMake(_button_Category.frame.origin.x, _button_Category.frame.origin.y, _button_Category.frame.size.width, _button_Category.frame.size.height);
    
    [KxMenu showMenuInView:self.view
                  fromRect:newFrame
                 menuItems:menuItems];
    
}

- (IBAction)pushMenuALL:(id)sender
{
    NSLog(@"%@", sender);
    
    self.str_ChangeURL = @"all_messages.php";
    self.arrayAllMessages =[[NSMutableArray alloc]init];
    [self getAllMessageswithType:self.str_ChangeURL];
    
}

- (IBAction)pushMenuRead:(id)sender
{
     NSLog(@"%@", sender);
    
     self.str_ChangeURL = @"read_messages.php";
     self.arrayAllMessages =[[NSMutableArray alloc]init];
     [self getAllMessageswithType:self.str_ChangeURL];
}

- (IBAction)pushMenuUnread:(id)sender
{
    NSLog(@"%@", sender);
    
    self.str_ChangeURL = @"unread_messages.php";
    self.arrayAllMessages =[[NSMutableArray alloc]init];
    [self getAllMessageswithType:self.str_ChangeURL];
    
}


#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayAllMessages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"messagecell";
    
    MessageBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[MessageBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }

    NSLog(@"AllData::%@",[[self.arrayAllMessages valueForKey:@"title"]objectAtIndex:indexPath.row]);
    
    cell.lbl_MessageTitle.text = [[self.arrayAllMessages valueForKey:@"title"]objectAtIndex:indexPath.row];
    cell.lbl_Description.text  = [[self.arrayAllMessages valueForKey:@"msg"]objectAtIndex:indexPath.row];
    if (_isInbox) {
        
         cell.lbl_phoneNumber.text  = [[self.arrayAllMessages valueForKeyPath:@"from.Phone"]objectAtIndex:indexPath.row];
        
    }else{
        
        cell.lbl_phoneNumber.text  = [[self.arrayAllMessages valueForKeyPath:@"to.Phone"]objectAtIndex:indexPath.row];
        
    }
   
    
    NSString *Date = [[self.arrayAllMessages valueForKeyPath:@"time"]objectAtIndex:indexPath.row];
    NSArray *split = [Date componentsSeparatedByString:@"-"];
    NSLog(@"split :%@",split);
   
    NSString *day = [split objectAtIndex:2];
    NSLog(@"day :%@",day);
    NSArray *dateOnly = [day componentsSeparatedByString:@" "];
    
    
    cell.lbl_Date.text =  [dateOnly objectAtIndex:0];;

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter dateFromString:[split objectAtIndex:1]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    NSString *month = stringFromDate;
    NSString *year = [split objectAtIndex:0];
    
    cell.lbl_MonthYear.text = [NSString stringWithFormat:@"%@,%@",month,year];
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_fmVC) {
        
        [_fmVC didSelectedRow:[self.arrayAllMessages objectAtIndex:indexPath.row]];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    _view_Show.hidden=YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _view_Show.hidden=NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}


-(void)getAllMessageswithType:(NSString*)categoryType {
    
    [SVProgressHUD show];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,categoryType];
    
    NSLog(@"Print registration url ::%@",url);
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                userID,@"userid",
                                nil];
    
    NSLog(@"Print paramenters ::%@",[parameters description]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"successful %@", responseObject);
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            if (self->_isInbox) {
                
                if ([[responseObject valueForKey:@"inbox"] isEqual:[NSNull null]]) {
                    
                    
                }else{
                    
                     self.arrayAllMessages = [responseObject valueForKey:@"inbox"];
                }
                
                
            }else{
                
                if ([[responseObject valueForKey:@"outbox"] isEqual:[NSNull null]]) {
                    
                    
                }else{
                
                  self.arrayAllMessages = [responseObject valueForKey:@"outbox"];
                    
                }
                
            }
           
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
        }
        
        [self.tblView_MessageBox reloadData];
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
    
        [SVProgressHUD dismiss];
       
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Please Check Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alertView show];
        
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

- (IBAction)btnAction_ShowMessage:(id)sender {
    
    if(_fmVC){
        
        [_fmVC sendMessage];
    }
    
}

@end
