//
//  PantryOrderReceivedViewController.m
//  @TCS
//
//  Created by fnspl3 on 04/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "PantryOrderReceivedViewController.h"

@interface PantryOrderReceivedViewController ()

@end


@implementation PantryOrderReceivedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _orderView.layer.borderColor = [UIColor grayColor].CGColor;
    _orderView.layer.borderWidth = 1.0;
    _orderView.clipsToBounds = true;
    
    //0="Order Placed",1="Confirmed",2="Delivered",3="Cancel"
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.order_id = [Userdefaults objectForKey:@"orderId"];
    
    status = [Userdefaults objectForKey:@"orderStatus"];
    
    [self checkOrderStatus];
}


#pragma mark - Button actions

- (IBAction)btnBack:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DashBoardViewController *dbVC = [storyboard instantiateViewControllerWithIdentifier:@""];
    
    [self.navigationController popToViewController:dbVC animated:YES];
    
}


#pragma mark - Api details

-(void)checkOrderStatus
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@order_status.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    NSDictionary *parameters = @{@"order_id":self.order_id,@"status":status};
    
    NSLog(@"Print paramenters ::%@",[parameters description]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"successful %@", responseObject);
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSDictionary *dict = responseObject;
            
            self.lblOrderReceived.text = [dict objectForKey:@""];
            
        }
        else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:[responseObject objectForKey:@"message"]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            
                                            
                                        }];
            
            
            [alert addAction:yesButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        [SVProgressHUD dismiss];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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

@end
