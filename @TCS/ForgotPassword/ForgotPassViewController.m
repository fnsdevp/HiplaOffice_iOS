//
//  ForgotPassViewController.m
//  SmartOffice
//
//  Created by FNSPL on 04/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "ForgotPassViewController.h"

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _popupVw.layer.cornerRadius = 5.0;
    _backbgImg.layer.cornerRadius = 5.0;
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    
    tapPress.delaysTouchesBegan = NO;
    tapPress.cancelsTouchesInView = NO;
    
    [self.backVw addGestureRecognizer:tapPress];
    
}


- (void)tapPress:(UIGestureRecognizer *)gesture {
    
    [self.view endEditing:YES];
    
    [self.delegate ForgotPassViewController:self didremove:YES];
}


- (IBAction)btnSubmitDidTap:(id)sender {
    
    if (([_EmailIdTxt hasText]) && ([_EmailIdTxt.text length]>0)) {
        
        [self.view endEditing:YES];
        
        [self retrivePassword:_EmailIdTxt.text];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter email id."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (IBAction)btnCancelDidTap:(id)sender {
    
    [self.view endEditing:YES];
    
//    [self.delegate ForgotPassViewController:self didremove:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)retrivePassword:(NSString *)email{
    
    [SVProgressHUD show];
    
    NSDictionary *params = @{@"email":email};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@retrivepassword.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[responseDict objectForKey:@"message"]
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [self.delegate ForgotPassViewController:self didremove:YES];
            
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
