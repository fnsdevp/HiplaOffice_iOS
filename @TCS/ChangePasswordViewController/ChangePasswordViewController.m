//
//  ChangePasswordViewController.m
//  SmartOffice
//
//  Created by FNSPL on 11/05/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
   
    _popupVw.layer.cornerRadius = 5.0;
    _backbgImg.layer.cornerRadius = 5.0;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [userDict objectForKey:@"id"];
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    
    tapPress.delaysTouchesBegan = NO;
    tapPress.cancelsTouchesInView = NO;
    
    [self.backVw addGestureRecognizer:tapPress];
    
    _backVw.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    _backVw.opaque = NO;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.view.opaque = NO;
    
}

- (void)tapPress:(UIGestureRecognizer *)gesture {
    
    [self.view endEditing:YES];
    
    [self.delegate ChangePasswordViewController:self didremove:YES];
}


- (IBAction)btnSubmitDidTap:(id)sender {
    
    if (([_NewPasswordTxt hasText]) && ([_NewPasswordTxt.text length]>0)) {
        
        [self.view endEditing:YES];
        
        [self changePassword:_NewPasswordTxt.text];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please enter new password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (IBAction)btnCancelDidTap:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.delegate ChangePasswordViewController:self didremove:YES];
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


-(void)changePassword:(NSString *)newPassword{
    
    [SVProgressHUD show];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":userId,@"newpassword":newPassword};
    
    NSLog(@"params :%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@changepassword.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password changed successfully."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [self.delegate ChangePasswordViewController:self didremove:YES];
            
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
