//
//  HotDeskingDetailViewController.m
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "HotDeskingDetailViewController.h"
#import "HotDeskingDetailCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Constants.h"


@interface HotDeskingDetailViewController (){
    
    NSMutableArray *array_BookListZone;
    NSString *str_TimeDuration;
    
}

@end

@implementation HotDeskingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    array_BookListZone =[[NSMutableArray alloc]init];
    
    NSLog(@"NsuserDefault : %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"hot_seat_id"]);
    
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"hot_seat_id"]) {
        
          self->_view_Local.hidden =YES;
        
          [self hotDeskingBookListZoneWithZoneId:_getZoneId];
        
    }else{
        
        self->_view_Local.hidden = NO;
        _collectionView_BookListZone.hidden =YES;
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hotDeskingBookListZoneWithZoneId:(NSString*)zoneId{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = [NSString stringWithFormat:@"%@kiosk_book_list_zone.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
                                zoneId,@"zone_id",
                                nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            self->array_BookListZone = [responseObject valueForKey:@"row_list"];
            
        }
        if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            
            
        }
        
        [self->_collectionView_BookListZone reloadData];
        
        [SVProgressHUD dismiss];
        
        
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!" message:@"Please Check Network Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }];
    
    
}


#pragma mark- UIcollection view implt

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [array_BookListZone count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotDeskingDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotDeskingDetailCollectionViewCell" forIndexPath:indexPath];
    
    cell.lbl_RowName.text = [[array_BookListZone valueForKey:@"row_name"]objectAtIndex:indexPath.row];
    
    if ([[[array_BookListZone valueForKey:@"status"]objectAtIndex:indexPath.row] isEqualToString:@"booked"]) {
        
        cell.imgView_HotDesk.image = [UIImage imageNamed:@"armchairbooked"];
        
    }else{
        
        cell.imgView_HotDesk.image = [UIImage imageNamed:@"armchair1x"];
    }
    

    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     HotDeskingDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotDeskingDetailCollectionViewCell" forIndexPath:indexPath];
    
    if ([[[array_BookListZone valueForKey:@"status"]objectAtIndex:indexPath.row] isEqualToString:@"booked"]) {
        
    }else{
        
        NSString *rowId = [[array_BookListZone valueForKey:@"id"]objectAtIndex:indexPath.row];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"@TCS"
                                     message:@"Do you want to book this sit?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        
                                        
                                        
                                    cell.imgView_HotDesk.image = [UIImage imageNamed:@"armchairown"];

                                        
                                        
                                        
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
        
    }
    
}


-(void)popUPWithRowId:(NSString*)rowid{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Please select time duration!!"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* one = [UIAlertAction
                                actionWithTitle:@"1hr"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                    
                                    
                                    self->str_TimeDuration = @"1";
                                    
                                   // -(void)bookSitWithRowId:(NSString*)rowId{
                                    
                                    [self bookSitWithRowId:rowid];
                                    
                                    
                                    
                                    
                                }];
    
    UIAlertAction* two = [UIAlertAction
                               actionWithTitle:@"2hr"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                    self->str_TimeDuration = @"2";
                                   
                                     [self bookSitWithRowId:rowid];
                                   
                               }];
    
    
    UIAlertAction* four = [UIAlertAction
                               actionWithTitle:@"4hr"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                     self->str_TimeDuration = @"4";
                                   
                                     [self bookSitWithRowId:rowid];
                                   
                               }];
    
    UIAlertAction* eight = [UIAlertAction
                               actionWithTitle:@"8hr"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                    self->str_TimeDuration = @"8";
                                   
                                     [self bookSitWithRowId:rowid];
                                   
                               }];
    
    
    
    [alert addAction:one];
    [alert addAction:two];
    [alert addAction:four];
    [alert addAction:eight];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}


-(void)bookSitWithRowId:(NSString*)rowId{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = [NSString stringWithFormat:@"%@book_hot_desking.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    

    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
  NSString  *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
                                _getZoneId,@"zone_id",
                                rowId,@"row_id",
                                str_TimeDuration,@"time_duration",
                                userID,@"user_id",
                                nil];
    
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
                                            
                                            
                                            self->_collectionView_BookListZone.hidden = YES;
                                            
                                            self->_view_Local.hidden = NO;
                                            
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)releaseButton{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *url = [NSString stringWithFormat:@"%@hot_desk_status.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
  
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString  *userID = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                
                                [[NSUserDefaults standardUserDefaults]valueForKey:@"hot_seat_id"],@"hot_seat_id",
                                @"2",@"status",
                                nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful %@", responseObject);
        
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hot_seat_id"];
            
            self->_view_Local.hidden=YES;
            self->_collectionView_BookListZone.hidden =NO;
            
             self->array_BookListZone =[[NSMutableArray alloc]init];
            
               [self hotDeskingBookListZoneWithZoneId:self->_getZoneId];
            
            
            
            
            
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
- (IBAction)btnAction_Release:(id)sender{
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

- (IBAction)btnAction_Back:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
    
}
@end
