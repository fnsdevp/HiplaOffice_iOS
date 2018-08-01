//
//  HotDeskViewController.m
//  Hotdesking
//
//  Created by FNSPL5 on 07/06/18.
//  Copyright © 2018 futureNetwings. All rights reserved.
//

#import "HotDeskViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "NavigationViewController.h"
#import "DashBoardViewController.h"

@interface HotDeskViewController ()
{
    NSString *zone_id;
    NSString *row_id;
    NSString *hotSeatID;
    BOOL isbooked;
}

@end

@implementation HotDeskViewController


- (void)viewDidLoad {
    
    _array_UserName = [NSMutableArray arrayWithObjects:@"guest1",@"guest2",@"guest3",@"guest4",@"guest5",@"guest6",@"guest7",@"guest8",@"guest9",@"guest10", nil];
    
    _array_Password = [NSMutableArray arrayWithObjects:@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123",@"tcs@123", nil];
    
    //   [super viewDidLoad];
    
    isbooked = false;
    
    [self getBookDetailID];
    
    [self getRandomNumberFromArrayUsername:_array_UserName];
    
    
    
    
}



-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
    
}


//-(void)viewWillDisappear:(BOOL)animated{
//
//   [self.navigationController popViewControllerAnimated:YES];
//
//}




-(void)getRandomNumberFromArrayUsername:(NSMutableArray *)user{
    
    int index = arc4random() % user.count;
    self->_lbl_username.text = [user objectAtIndex:index];
    
}

-(void)getRandomNumberFromArrayPassword:(NSMutableArray *)pass{
    
    int index = arc4random() % pass.count;
    self->_lbl_password.text = [pass objectAtIndex:index];
}







-(void)zoneViewUpdate{
    
    NSLog(@"the array of zone list is %@",self.array_ZoneList);
    unsigned long i, j,cnt = [_array_ZoneList count];
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString  *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    NSString *userIdAPI;
    
    for(i = 0; i < cnt; i++)
    {
        NSMutableArray *zoneDetail = [NSMutableArray array];
        
        zoneDetail = [[_array_ZoneList objectAtIndex:i]objectForKey:@"row_list"];
        for(j=0;j<zoneDetail.count;j++){
            
            NSMutableDictionary *seatDetail = [NSMutableDictionary dictionary];
            seatDetail = [zoneDetail objectAtIndex:j];
            userIdAPI = [NSString stringWithFormat:@"%@",[seatDetail objectForKey:@"user_id"] ];
            
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 1 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"A"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    self.btn_1A.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    self.btn_1A.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_1A.userInteractionEnabled = false;
                    
                }
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 1 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"B"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_1B.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    self.btn_1B.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_1B.userInteractionEnabled = false;
                }
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 1 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"C"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_1C.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_1C.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_1C.userInteractionEnabled = false;
                }
                
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 1 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"D"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                
                
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_1D.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_1D.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_1D.userInteractionEnabled = false;
                    
                }
                
                
                
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 2 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"A"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_2A.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_2A.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_2A.userInteractionEnabled = false;
                    
                }
                
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 2 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"B"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_2B.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_2B.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_2B.userInteractionEnabled = false;
                    
                }
                
                
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 2 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"C"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_2C.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_2C.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_2C.userInteractionEnabled = false;
                    
                }
                
                
            }
            if([[seatDetail objectForKey:@"zone_id"]intValue] == 2 && [[seatDetail objectForKey:@"row_name"]isEqualToString:@"D"] && [[seatDetail objectForKey:@"status"]isEqualToString:@"booked"]){
                if ([userIdAPI isEqualToString:userID]){
                    isbooked = true;
                    
                    self.btn_2D.imageView.image = [UIImage imageNamed:@"booked"];
                    
                }else{
                    
                    self.btn_2D.imageView.image = [UIImage imageNamed:@"alreadyBooked"];
                    self.btn_2D.userInteractionEnabled = false;
                    
                }
                
                
            }
            
            
            
        }
        
        
        NSLog(@"%@",zoneDetail);
        
    }
    if (isbooked == true){
        self.btn_1A.userInteractionEnabled = false;
        self.btn_1B.userInteractionEnabled = false;
        self.btn_1C.userInteractionEnabled = false;
        self.btn_1D.userInteractionEnabled = false;
        self.btn_2A.userInteractionEnabled = false;
        self.btn_2B.userInteractionEnabled = false;
        self.btn_2C.userInteractionEnabled = false;
        self.btn_2D.userInteractionEnabled = false;
        
        self.txtview_DefaultView.hidden = true;
        self.lbl_password.text = @"**********";
        
    }else{
        
        self.lbl_username.hidden = true;
        self.lbl_password.hidden = true;
        self.btn_showPassword.hidden = true;
        self.btn_releaseButton.hidden = true;
        self.lbl_wifiPassword.hidden = true;
        self.lbl_wifiUsername.hidden = true;
        self.btn_navigateButton.hidden = true;
        
        //  self.view_defaultView.hidden =false;
        //        self.view_defaultView.hidden= false;
        
    }
    
    
    
    
}




#pragma mark - Button action method

- (IBAction)btnAction_Release:(UIButton *)sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"@TCS"
                                 message:@"Do you want to release this sit"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    [self releaseButton];
                                    
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   
                                   
                               }];
    
    
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)btnAction_unhidePassword:(UIButton *)sender {
    
    [self getRandomNumberFromArrayPassword:_array_Password];
    
}
- (IBAction)btnAction_back:(UIButton *)sender {
    
    if ([self.isPresent isEqualToString:@"YES"])
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        
        //        self.isPresent = @"NO";
    }
    else
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
    
}

- (IBAction)btnAction_Navigate:(UIButton *)sender {
    
//    NavigationViewController *indoorMap = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
//
//    [self.navigationController pushViewController:indoorMap animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_objc" bundle:nil];
    ViewController *myVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    
    //    ViewController *indoorMap = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (IBAction)buttonAction:(UIButton *)sender
{
    
    if ([sender isEqual:self.btn_1A]) {
        [self getData:self.btn_1A];
        
    } else if ([sender isEqual:self.btn_1B]) {
        [self getData:self.btn_1B];
        
    } else if ([sender isEqual:self.btn_1C]) {
        
        [self getData:self.btn_1C];
        
    }else if ([sender isEqual:self.btn_1D]) {
        
        
        [self getData:self.btn_1D];
        
    }else if ([sender isEqual:self.btn_2A]) {
        
        
        [self getData:self.btn_2A];
        
        
    }else if ([sender isEqual:self.btn_2B]) {
        
        
        [self getData:self.btn_2B];
        
        
    }else if ([sender isEqual:self.btn_2C]) {
        
        
        [self getData:self.btn_2C];
        
        
    }else if ([sender isEqual:self.btn_2D]) {
        
        
        [self getData:self.btn_2D];
        
        
    }
    
    
    
    
}

#pragma  mark - MISC HELPER METHOD

-(void)getData:(UIButton *)sender{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"@TCS"
                                 message:@"Do you to book this sit?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    
                                    
                                    [self popUPWithRowId:sender];
                                    
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                   
                               }];
    
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    //    [sender setImage: [UIImage imageNamed:@"booked"] forState:UIControlStateNormal];
    
}


-(void)popUPWithRowId:(UIButton *)sender{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Please select time duration!!"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* one = [UIAlertAction
                          actionWithTitle:@"1hr"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action) {
                              //Handle your yes please button action here
                              
                              
                              
                              self->_str_TimeDuration = @"1";
                              if ([sender isEqual:self.btn_1A]){
                                  
                                  self->zone_id = @"1";
                                  self->row_id = @"1";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if ([sender isEqual:self.btn_1B]){
                                  self->zone_id = @"1";
                                  self->row_id = @"2";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if ([sender isEqual:self.btn_1C]){
                                  self->zone_id = @"1";
                                  self->row_id = @"3";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                                  
                              }else if  ([sender isEqual:self.btn_1D]){
                                  self->zone_id = @"1";
                                  self->row_id = @"4";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2A]){
                                  self->zone_id = @"2";
                                  self->row_id = @"1";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2B]){
                                  self->zone_id = @"2";
                                  self->row_id = @"2";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2C]){
                                  self->zone_id = @"2";
                                  self->row_id = @"3";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2D]){
                                  self->zone_id = @"2";
                                  self->row_id = @"4";
                                  [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                  
                                  
                              }
                              
                              
                              
                              
                              
                              
                              
                              // -(void)bookSitWithRowId:(NSString*)rowId{
                              
                              //   [self bookSitWithRowId:rowid];
                              
                              
                              
                              
                          }];
    
    UIAlertAction* two = [UIAlertAction
                          actionWithTitle:@"2hr"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action) {
                              //Handle no, thanks button
                              
                              self->_str_TimeDuration = @"2";
                              if ([sender isEqual:self.btn_1A]){
                                  
                                  self->zone_id = @"1";
                                  self->row_id = @"1";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if ([sender isEqual:self.btn_1B]){
                                  self->zone_id = @"1";
                                  self->row_id = @"2";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if ([sender isEqual:self.btn_1C]){
                                  self->zone_id = @"1";
                                  self->row_id = @"3";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                                  
                              }else if  ([sender isEqual:self.btn_1D]){
                                  self->zone_id = @"1";
                                  self->row_id = @"4";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2A]){
                                  self->zone_id = @"2";
                                  self->row_id = @"1";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2B]){
                                  self->zone_id = @"2";
                                  self->row_id = @"2";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2C]){
                                  self->zone_id = @"2";
                                  self->row_id = @"3";
                                  [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                  
                              }else if  ([sender isEqual:self.btn_2D]){
                                  self->zone_id = @"2";
                                  self->row_id = @"4";
                                  [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                  
                                  
                              }
                              
                              
                              //                              [self bookSitWithRowId:rowid];
                              
                          }];
    
    
    UIAlertAction* four = [UIAlertAction
                           actionWithTitle:@"4hr"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               //Handle no, thanks button
                               self->_str_TimeDuration = @"4";
                               if ([sender isEqual:self.btn_1A]){
                                   
                                   self->zone_id = @"1";
                                   self->row_id = @"1";
                                   
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                               }else if ([sender isEqual:self.btn_1B]){
                                   self->zone_id = @"1";
                                   self->row_id = @"2";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                               }else if ([sender isEqual:self.btn_1C]){
                                   self->zone_id = @"1";
                                   self->row_id = @"3";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                                   
                               }else if  ([sender isEqual:self.btn_1D]){
                                   self->zone_id = @"1";
                                   self->row_id = @"4";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                               }else if  ([sender isEqual:self.btn_2A]){
                                   self->zone_id = @"2";
                                   self->row_id = @"1";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                               }else if  ([sender isEqual:self.btn_2B]){
                                   self->zone_id = @"2";
                                   self->row_id = @"2";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                               }else if  ([sender isEqual:self.btn_2C]){
                                   self->zone_id = @"2";
                                   self->row_id = @"3";
                                   [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                   
                               }else if  ([sender isEqual:self.btn_2D]){
                                   self->zone_id = @"2";
                                   self->row_id = @"4";
                                   [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                   
                                   
                               }
                               
                               
                               //  [self bookSitWithRowId:rowid];
                               
                           }];
    
    UIAlertAction* eight = [UIAlertAction
                            actionWithTitle:@"8hr"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                                //Handle no, thanks button
                                
                                self->_str_TimeDuration = @"8";
                                if ([sender isEqual:self.btn_1A]){
                                    
                                    self->zone_id = @"1";
                                    self->row_id = @"1";
                                    
                                    [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                }else if ([sender isEqual:self.btn_1B]){
                                    self->zone_id = @"1";
                                    self->row_id = @"2";
                                    [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                    
                                }else if ([sender isEqual:self.btn_1C]){
                                    self->zone_id = @"1";
                                    self->row_id = @"3";
                                    [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                    
                                    
                                }else if  ([sender isEqual:self.btn_1D]){
                                    self->zone_id = @"1";
                                    self->row_id = @"4";
                                    [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                    
                                }else if  ([sender isEqual:self.btn_2A]){
                                    self->zone_id = @"2";
                                    self->row_id = @"1";
                                    [self bookSitWithRowId:self->row_id zoneId:self->zone_id button:sender];
                                    
                                }else if  ([sender isEqual:self.btn_2B]){
                                    self->zone_id = @"2";
                                    self->row_id = @"2";
                                    [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                    
                                }else if  ([sender isEqual:self.btn_2C]){
                                    self->zone_id = @"2";
                                    self->row_id = @"3";
                                    [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                    
                                }else if  ([sender isEqual:self.btn_2D]){
                                    self->zone_id = @"2";
                                    self->row_id = @"4";
                                    [self bookSitWithRowId:self->row_id zoneId:zone_id button:sender];
                                    
                                    
                                }
                                
                                
                                //   [self bookSitWithRowId:rowid];
                                
                            }];
    
    
    
    [alert addAction:one];
    [alert addAction:two];
    [alert addAction:four];
    [alert addAction:eight];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}


#pragma mark - API Implementation

//Method for releasing booked hotdesk
-(void)releaseButton{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = [NSString stringWithFormat:@"%@hot_desk_status.php",BASE_URL];
    NSLog(@"Print registration url ::%@",url);
    
    //    NSInteger hotSeat = [hotSeatID integerValue];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:hotSeatID
                                ,@"hot_seat_id",@"2",@"status",nil];
    NSLog(@"%@",parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hot_seat_id"];
            
            //            [self.navigationController popViewControllerAnimated:NO];
            
            //            [self viewDidLoad];
            //            [self viewWillAppear:YES];
            
            
            if ([self.isPresent isEqualToString:@"YES"]) {
                
                HotDeskViewController *hotdesk = [[HotDeskViewController alloc]initWithNibName:@"HotDeskViewController" bundle:nil];
                
                hotdesk.isPresent = @"YES";
                
                [self.navigationController pushViewController:hotdesk animated:YES];
            }
            else
            {
                HotDeskViewController *hotdesk = [[HotDeskViewController alloc]initWithNibName:@"HotDeskViewController" bundle:nil];
                
                [self.navigationController pushViewController:hotdesk animated:YES];
            }
            //            [self.navigationController pushViewController:hotdesk animated:YES];
            
            
            
            //            [self.navigationController pushViewController: animated:<#(BOOL)#>:hotdesk sender:self];
            //            [self.navigationController showViewController:hotdesk sender:self animated:NO];
            
            //            [self getZoneList];
            
            //            self->_view_Local.hidden=YES;
            //            self->_collectionView_BookListZone.hidden =NO;
            //
            //            self->array_BookListZone =[[NSMutableArray alloc]init];
            //
            //            [self hotDeskingBookListZoneWithZoneId:self->_getZoneId];
            
            
            
            
            
        }
        if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@TCS"
                                         message:[responseObject valueForKey:@"message"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            
                                            
                                        }];
            
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
        }
        
        
        [SVProgressHUD dismiss];
        
        
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Please Check Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }];
    
    
}

-(void)getBookDetailID{
    
    //     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [userDict objectForKey:@"id"] ,@"user_id",
                                nil];
    
    NSLog(@"Parameters are %@",parameters);
    
    NSString *url = @"http://gohipla.com/tcs_ws/kiosk_user_details.php";
    
    //    NSString *url = [NSString stringWithFormat:@"%@kiosk_zone_list.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            unsigned long i;
            self.bookedArray  = [responseObject valueForKey:@"row_list"];
            
            for(i = 0; i < self->_bookedArray.count; i++){
                
                if([self->_bookedArray[i] objectForKey:@"user_id"]  == [userDict objectForKey:@"id"]){
                    
                    self->hotSeatID = [NSString stringWithFormat:@"%@", [self->_bookedArray[i] objectForKey:@"id"]];
                    
                }
                
            }
            
            
            
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Data Error!" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //
            //            [alertView show];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        
        
        
        
        
    }];
    
    
    
    
    
}

-(void)getZoneList{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = @"http://gohipla.com/tcs_ws/kiosk_seatbyzone_list.php";
    
    //    NSString *url = [NSString stringWithFormat:@"%@kiosk_zone_list.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            self.array_ZoneList  = [responseObject valueForKey:@"zone_list"];
            
            [self zoneViewUpdate];
            
            NSLog(@"%@",self.array_ZoneList);
            
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Data Error!" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Please Check Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        
    }];
    
}

-(void)bookSitWithRowId:(NSString*)rowId zoneId:(NSString*)zondID button:(UIButton *)sender{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = @"http://gohipla.com/tcs_ws/book_hot_desking.php";
    
    NSLog(@"Print registration url ::%@",url);
    
    
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString  *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
                                zone_id,@"zone_id",
                                rowId,@"row_id",
                                self.str_TimeDuration,@"time_duration",
                                userID,@"user_id",
                                nil];
    
    NSLog(@"Parameters are %@",parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[responseObject objectForKey:@"hot_seat_id"] forKey:@"hot_seat_id"];
            [defaults synchronize];
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@TCS"
                                         message:[responseObject valueForKey:@"message"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            
                                            //
                                            //                                            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
                                            //
                                            //                                            // [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
                                            //                                            [navigationArray removeObjectAtIndex: 0];
                                            //                                            [self.navigationController popViewControllerAnimated:NO];
                                            //  [self viewDidLoad];
                                            //                                            [self viewWillAppear:YES];
                                            
                                            //
                                            
                                            if ([self.isPresent isEqualToString:@"YES"]) {
                                                
                                                HotDeskViewController *hotdesk = [[HotDeskViewController alloc]initWithNibName:@"HotDeskViewController" bundle:nil];
                                                
                                                hotdesk.isPresent = @"YES";
                                                
                                                [self.navigationController pushViewController:hotdesk animated:YES];
                                            }
                                            else
                                            {
                                                HotDeskViewController *hotdesk = [[HotDeskViewController alloc]initWithNibName:@"HotDeskViewController" bundle:nil];
                                                
                                                [self.navigationController pushViewController:hotdesk animated:YES];
                                            }
                                            
                                            //                                            [self.navigationController showViewController:hotdesk sender:self];
                                            
                                            
                                            
                                            [sender setImage: [UIImage imageNamed:@"booked"] forState:UIControlStateNormal];
                                            
                                            //                                            self->_collectionView_BookListZone.hidden = YES;
                                            //
                                            //                                            self->_view_Local.hidden = NO;
                                            
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
        }
        if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@TCS"
                                         message:[responseObject valueForKey:@"message"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                        }];
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Please Check Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }];
    
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self getZoneList];
    
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
