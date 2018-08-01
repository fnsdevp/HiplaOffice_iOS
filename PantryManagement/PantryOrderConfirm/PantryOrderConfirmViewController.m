//
//  PantryOrderConfirmViewController.m
//  @TCS
//
//  Created by fnspl3 on 03/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "PantryOrderConfirmViewController.h"
#import "Constants.h"
#import "PantryOrderReceivedViewController.h"

@interface PantryOrderConfirmViewController ()

@end

@implementation PantryOrderConfirmViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    objcommon = [Common sharedCommonManager];
    objcommon.delegate = self;
    
  //  [objcommon getUpcomingMeetings];
    
    //[SVProgressHUD show];
    
    // self.meeting_Detail = objcommon.meetingsArr;
    
    // [self currentMeetingByTime];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
    self.txtView_Notes.text = @"enter your notes";
    
    self.lbl_TotalCount.text = [NSString stringWithFormat:@"%ld",(long)self.orderFoodArr.count];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
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


#pragma mark - TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.orderFoodArr count]>0) {
        
        return [self.orderFoodArr count];
        
    } else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"ProductCell";
    
    OderConfirmTableViewCell *cell = (OderConfirmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OderConfirmTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    Menudetails *detailsDict = [self.orderFoodArr objectAtIndex:indexPath.row];
    
    cell.itemlbl.text = [NSString stringWithFormat:@"%@",detailsDict.subCatName];
    cell.itemCount.text = [NSString stringWithFormat:@"%d",(int)detailsDict.quantity];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnOrderConfirm:(id)sender {
    
    [self createOrder];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.txtView_Notes.text = @"";
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if([self.txtView_Notes.text isEqualToString:@""])
    {
        self.txtView_Notes.text = @"enter your notes";
    }
    
    [self.scrollVw_ConfirmOrder endEditing:YES];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat viewCommentsY = self.view_Comments.frame.origin.y;
    
    CGFloat extraY = viewCommentsY - keyboardSize.height;
    
    CGPoint scrollPoint = CGPointMake(0.0, -extraY);
    
    
    [self.scrollVw_ConfirmOrder setOrigin:scrollPoint];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    if(![self.txtView_Notes.text isEqualToString:@"enter your notes"])
    {
        
    } else {
        
        self.txtView_Notes.text = @"enter your notes";
        
    }
    
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);

    [self.scrollVw_ConfirmOrder setOrigin:scrollPoint];
    
}


#pragma mark - Api details

-(void)createOrder
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@order_creat.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    [self order_cart];
    
    NSString *responseData = [self. jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *orderDate=[dateFormatter stringFromDate:currentTime];
    
    NSString *meeting_ID = [NSString stringWithFormat:@"%@",[self.currentMeeting  objectForKey:@"id"]];
    
    
    //        NSString *meeting_ID = [NSString stringWithFormat:@"%@",[[arrMeetings objectAtIndex:0] objectForKey:@"id"]];
    
    location = [NSString stringWithFormat:@"%@",[self.currentMeeting  objectForKey:@"location"]];
    
    // location = @"3a8af4d5-5087-4493-b0c1-4c18f8b488d8";
    
    NSDictionary *parameters = @{@"user_id":self->userID,@"room_id":location,@"total_quantity":[NSString stringWithFormat:@"%ld",(long)self.orderFoodArr.count],@"order_date":orderDate,@"note":self.txtView_Notes.text,@"product":responseData,@"meeting_id":meeting_ID};
    
    
    NSLog(@"Print paramenters ::%@",[parameters description]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"successful %@", responseObject);
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSLog(@"%@",responseObject);
            
            NSDictionary *dict = responseObject;
            
            [Userdefaults setObject:[dict objectForKey:@"createOrder_uniqueid"] forKey:@"orderId"];
            
            [Userdefaults setObject:[dict objectForKey:@"message"] forKey:@"orderStatus"];
            
            [Userdefaults synchronize];
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:@"Your order has been placed."
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                                            
                                        }];
            
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//
//            self.dashboard = [storyboard instantiateInitialViewController];
//
//            [self.navigationController pushViewController:self.dashboard animated:YES];
            
            
            //
            //                [Userdefaults setObject:[dict objectForKey:@""] forKey:@"orderId"];
            //
            //                [Userdefaults setObject:[dict objectForKey:@""] forKey:@"orderStatus"];
            //
            //                [Userdefaults synchronize];
            
//            self->PantryOrderReceivedVC = [[PantryOrderReceivedViewController alloc]initWithNibName:@"PantryOrderReceivedViewController" bundle:nil];
//
//            self->PantryOrderReceivedVC.order_Dict = dict;
//
//            [self.navigationController pushViewController:self->PantryOrderReceivedVC animated:YES];
            
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't place your order, please try again."
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't place your order, please try again."
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        [SVProgressHUD dismiss];
        
    }];
    
    
    
}


-(void)currentMeetingByTime
{
    [SVProgressHUD show];
    
    NSDate *currentTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSLog(@"the current time is %@",resultString);
    
    NSString *url = [NSString stringWithFormat:@"%@all_appointments_date_time.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self->userID,@"user_id",resultString,@"time",nil];
    
    NSLog(@"Print paramenters ::%@",[parameters description]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"successful %@", responseObject);
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            self.meeting_Detail = responseObject;
            
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
}


-(void)order_cart{
    
    NSMutableArray *Product = [NSMutableArray new];
    
    NSInteger index = 0;
    Menudetails *obj;
    
    for (; index < [self.orderFoodArr count]; index++) {
        
        NSMutableDictionary *product = [NSMutableDictionary new];
        
        obj = self.orderFoodArr[index];
        
        [product setValue:obj.subCcatId forKey:@"product_id"];
        [product setValue:[NSString stringWithFormat:@"%ld",(long)obj.quantity] forKey:@"quantity"];
        
        [Product addObject:product];
    }
    
    NSLog(@"MEETING DETAIL %@",self.currentMeeting);
    
    if([[self.currentMeeting objectForKey:@"message"] isEqualToString:@"Sorry no appointment right now!"]){
        
        location = @"<null>";
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You dont have an appointment!"
        //                                                        message:@""
        //                                                       delegate:self
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        
    }else{
        
        location = [[[self.currentMeeting objectForKey:@"appointments"] objectAtIndex:0] objectForKey:@"location"];
    }
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:Product options:NSJSONWritingPrettyPrinted error:nil];
    
    self.jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    NSLog(@"The product json is  %@",_jsonString);
    
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
