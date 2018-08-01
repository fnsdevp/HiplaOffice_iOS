//
//  LoginViewController.m
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    userType = @"User";
    
//    _txtfld_userName.textColor=[UIColor colorWithHexString:@"#9E9EA2"];
//    _txtfld_userName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    _txtfld_userName.enableMaterialPlaceHolder = YES;
    _txtfld_userName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_userName.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_userName.tintColor=[UIColor blackColor];
    _txtfld_userName.placeholder=@"Username";
    
    
//    _txtfld_passWord.textColor=[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_passWord.enableMaterialPlaceHolder = YES;
    _txtfld_passWord.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_passWord.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_passWord.tintColor=[UIColor blackColor];
    _txtfld_passWord.placeholder=@"Password";
    
    self.checkBox.animateDuration = 0.5;
    self.checkBox.lineWidth = 6;
    
    isEmployee = NO;
    
    if(isEmployee){
        
        userType = @"employee";
        
    }else{
        
        userType = @"Guest";
        
    }
    
}

-(IBAction)btnLoginOutlet:(id)sender
{
    if (_txtfld_userName.text.length<1) {
      
        UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"Please insert a Valid Username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alrt show];
        
        _txtfld_userName.text=@"";
    
    }else if (_txtfld_passWord.text.length<1) {
        
        UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"Please insert a Valid Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alrt show];
        
        _txtfld_passWord.text=@"";
    
    }else{
        
        [self LoginwithDetails];
    }
}


- (IBAction)btnCheckBoxDidTap:(id)sender {
    
    isEmployee = !isEmployee;
    
    if(isEmployee){
        userType = @"employee";
        
    }else{
        userType = @"Guest";
    }
}


-(IBAction)SignUpOutlet:(id)sender
{
    RegistrationViewController *signup = [[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:nil];
    
    [self.navigationController pushViewController:signup animated:YES];
}

-(IBAction)forgotPasswordOutlet:(id)sender
{
    ForgotPassViewController *forgotVC = [[ForgotPassViewController alloc]initWithNibName:@"ForgotPassViewController" bundle:nil];
    
    [self.navigationController pushViewController:forgotVC animated:YES];
}


#pragma mark - Api details

-(void)LoginwithDetails
{
    [SVProgressHUD showWithStatus:@"Logging in..."];
    
    NSString *url = [NSString stringWithFormat:@"%@login.php",BASE_URL];
    
    NSLog(@"Print registration url ::%@",url);
    
    NSString *str_deviceToken;
    
    if (![Userdefaults objectForKey:@"deviceToken"]) {
        
        str_deviceToken = @"";
        
    }else{
        
        str_deviceToken = [Userdefaults objectForKey:@"deviceToken"];
        
    }
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                _txtfld_userName.text,@"username",
                                _txtfld_passWord.text,@"password",
                                [Userdefaults objectForKey:@"device_id"],@"deviceId",
                                @"Ios",@"type",
                                userType,@"usertype"
                                , nil];
    
    NSLog(@"Print paramenters ::%@",[parameters description]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"successful %@", responseObject);
        
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSString *str_LastName = [[responseObject valueForKeyPath:@"profile.lname"]objectAtIndex:0];
            
            if ([str_LastName isKindOfClass:[NSNull class]]) {

                str_LastName = @"";
            }
            
            self->userType = [[responseObject valueForKeyPath:@"profile.usertype"]objectAtIndex:0];
            
            //NSLog(@"successful %@",self->userType);
            
            [Userdefaults setObject:[[responseObject objectForKey:@"profile"]objectAtIndex:0] forKey:@"ProfInfo"];
            
            [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
            [Userdefaults setObject:self->userType forKey:@"userType"];
            
            [Userdefaults synchronize];

            NSDictionary *dict = [Userdefaults objectForKey:@"ProfInfo"];

            NSString *userID = [NSString stringWithFormat:@"%d",(int)[[dict objectForKey:@"id"] integerValue]];

            NSString *deviceToken = [Userdefaults objectForKey:@"deviceToken"];

            if ([deviceToken length]>0) {

                [self getRegKey:userID];
            }
            
            //******************************
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            self->dashboard = [storyboard instantiateInitialViewController];
            
            [self.navigationController pushViewController:self->dashboard animated:YES];
            
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


-(void)getRegKey:(NSString *)userID{
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Userdefaults objectForKey:@"deviceToken"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                userID,@"userid",
                                deviceToken,@"reg",
                                @"Ios",@"type"
                                , nil];
    
    NSLog(@"Print paramenters ::%@",[params description]);
    
    NSString *hostUrl = [NSString stringWithFormat:@"%@get_regkey.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
        }else{
            NSString *msg = [responseDict objectForKey:@"message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [self performSelector:@selector(getRegKey:) withObject:userID afterDelay:0.0];
        
    }];
    
}


#pragma mark - text field delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//#pragma mark - text field delegates
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if([textField isEqual:_txtfld_userName])
//    {
//        [_scrollView setContentOffset:CGPointMake(0, (20+_txtfld_userName.frame.size.height))];
//
//        // _scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
//    }
//    else if([textField isEqual:_txtFieldPassword])
//    {
//        [_scrollView setContentOffset:CGPointMake(0, (40+_txtFieldPassword.frame.size.height))];
//
//        // _scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, (40+_txtFieldPassword.frame.size.height));
//    }
//
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    _scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//
//    if (textField == _txtFieldUsername) {
//
//        [_txtFieldUsername resignFirstResponder];
//        [_txtFieldPassword becomeFirstResponder];
//
//    } else if (textField == _txtFieldPassword) {
//
//        [_txtFieldPassword resignFirstResponder];
//    }
//
//    return YES;
//}

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
