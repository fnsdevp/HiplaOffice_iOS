//
//  RegistrationViewController.m
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "RegistrationViewController.h"
#import "LoginViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _txtfld_UserName.enableMaterialPlaceHolder = YES;
    _txtfld_UserName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_UserName.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_UserName.tintColor=[UIColor blackColor];
    _txtfld_UserName.placeholder=@"Username";
    
    _txtfld_Email.enableMaterialPlaceHolder = YES;
    _txtfld_Email.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Email.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Email.tintColor=[UIColor blackColor];
    _txtfld_Email.placeholder=@"Email";
    
    _txtfld_Phone.enableMaterialPlaceHolder = YES;
    _txtfld_Phone.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Phone.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Phone.tintColor=[UIColor blackColor];
    _txtfld_Phone.placeholder=@"Phone";
    
    _txtfld_Company.enableMaterialPlaceHolder = YES;
    _txtfld_Company.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Company.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Company.tintColor=[UIColor blackColor];
    _txtfld_Company.placeholder=@"Company";
    
    _txtfld_LastName.enableMaterialPlaceHolder = YES;
    _txtfld_LastName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_LastName.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_LastName.tintColor=[UIColor blackColor];
    _txtfld_LastName.placeholder=@"Last Name";
    
    _txtfld_FirstName.enableMaterialPlaceHolder = YES;
    _txtfld_FirstName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_FirstName.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_FirstName.tintColor=[UIColor blackColor];
    _txtfld_FirstName.placeholder=@"First Name";
    
    _txtfld_Department.enableMaterialPlaceHolder = YES;
    _txtfld_Department.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Department.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Department.tintColor=[UIColor blackColor];
    _txtfld_Department.placeholder=@"Department";
    
    _txtfld_Designation.enableMaterialPlaceHolder = YES;
    _txtfld_Designation.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Designation.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Designation.tintColor=[UIColor blackColor];
    _txtfld_Designation.placeholder=@"Designation";
    
    _txtfld_Password.enableMaterialPlaceHolder = YES;
    _txtfld_Password.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtfld_Password.lineColor=[UIColor whiteColor]; //[UIColor colorWithHexString:@"#9E9EA2"];
    _txtfld_Password.tintColor=[UIColor blackColor];
    _txtfld_Password.placeholder=@"Password";
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _txtfld_Department.hidden = YES;
    
    [self.scrollView setContentSize:CGSizeMake(SCREENWIDTH, self.btnSignUpOutlet.frame.origin.y+self.btnSignUpOutlet.frame.size.height+30)];
}

- (IBAction)userTypeChanged:(id)sender
{
    switch (_userSelectionSegControl.selectedSegmentIndex) {
            
        case 0:
            
            isEmployee = NO;
            _txtfld_Department.hidden = YES;
            _txtfld_Company.hidden = NO;
            
            break;
            
        case 1:
            
            isEmployee = YES;
            _txtfld_Department.hidden = NO;
            _txtfld_Company.hidden = YES;
            
            break;
            
        default:
            break;
    }
}


-(IBAction)btnLoginOutlet:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDepartMents:(id)sender {
    
    [self showDepartments];
}

-(IBAction)SignUpOutlet:(id)sender
{
    [self RegistrationwithDetails];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrDepartMents count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"dropCell";
    
    departmentTableCell *cell = (departmentTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"departmentTableCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [arrDepartMents objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@""];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _txtfld_Department.text = [arrDepartMents objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion: nil];
}


#pragma mark - Api details

-(void)RegistrationwithDetails
{
    if([self notEmptyChecking] == NO){return;}
    if([self validityChecking] == NO){return;}
    
    [SVProgressHUD showWithStatus:@"Signing Up..."];
    
    if(isEmployee){
        userType = @"Employee";
    }else{
        userType = @"Guest";
    }
    
    NSString *username = _txtfld_UserName.text;
    NSString *password = _txtfld_Password.text;
    NSString *fname = _txtfld_FirstName.text;
    NSString *lname = _txtfld_LastName.text;
    NSString *email = _txtfld_Email.text;
    NSString *phone = _txtfld_Phone.text;
    NSString *desig = _txtfld_Designation.text;
    NSString *dept = _txtfld_Department.text;
    NSString *comp = _txtfld_Company.text;
    
    if(!isEmployee){
        
        dept = @"";
    }
    else
    {
        comp = @"";
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",password,@"password",@"Ios",@"type",userType,@"usertype",fname,@"fname",lname,@"lname",email,@"email",phone,@"phone",desig,@"designation",dept,@"department",comp,@"company", nil];
    
    NSLog(@"params : %@",params);
    
    NSString *host_url = [NSString stringWithFormat:@"%@register.php",BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            if([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
            {
                NSString *str_LastName = [[responseObject valueForKeyPath:@"profile.lname"]objectAtIndex:0];
                
                if ([str_LastName isKindOfClass:[NSNull class]]) {
                    
                    str_LastName = @"";
                }
                
                self->userType = [[responseObject valueForKeyPath:@"profile.userType"]objectAtIndex:0];
                
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
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"@Hipla"
                                             message:@"Signed up successfully try logging in with your new credential!"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                
                                               LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                                                
                                                [self.navigationController pushViewController:login animated:YES];
                                                
                                            }];
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [SVProgressHUD dismiss];
                
                //******************************
                
                
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//
//                self->dashboard = [storyboard instantiateInitialViewController];
//
//                [self.navigationController pushViewController:self->dashboard animated:YES];
                
            }
            else if([[responseObject objectForKey:@"status"] isEqualToString:@"failure"])
            {
                
                NSDictionary *error = [responseDict objectForKey:@"errors"];
                NSString *msg = [error objectForKey:@"email"];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"@Hipla"
                                                                    message:msg
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                
                self.txtfld_Email.text = @"";
                self.txtfld_Email.becomeFirstResponder;
                
                [alertView show];
                
                [SVProgressHUD dismiss];
                
            }
            
        }else{
            
            NSDictionary *error = [responseDict objectForKey:@"errors"];
            NSString *msg = [error objectForKey:@"email"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"@Hipla"
                                                            message:@"Check your internet connection !"
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


-(void)checkCreds{
    
    if(_txtfld_UserName.text.length>1 || _txtfld_Email.text.length>1 || _txtfld_Phone.text.length>1 || _txtfld_Designation.text.length >1||_txtfld_Company.text.length>1){
        
        [SVProgressHUD show];
        
//        password": "Required",
//        "usertype": "Required",
//        "lname": "Required",
//        "designation": "Required",
//        "department": "Required"
        
        
        
        NSString *username = _txtfld_UserName.text;
        NSString *email = _txtfld_Email.text;
        NSString *phone = _txtfld_Phone.text;
        NSString *password = _txtfld_Password.text;
        NSString *usertype = userType;
        NSString *lname = _txtfld_LastName.text;
        NSString *fname = _txtfld_FirstName.text;
        NSString *designation =  _txtfld_Designation.text;
        NSString *department = _txtfld_Department.text;
        
        
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: username,@"username",email,@"email",phone,@"phone",password,@"password",usertype,@"usertype",lname,@"lname",fname,@"fname",designation,@"designation",department,@"department"
                                , nil];
        
        NSLog(@"Print paramenters ::%@",[params description]);
        
        NSString *host_url = [NSString stringWithFormat:@"%@register.php",BASE_URL];
        
        NSLog(@"params : %@",params);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            NSDictionary *responseDict = responseObject;
            
            NSString *successStr = [responseDict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"@Hipla"
                                             message:@"Signed up successfully try logging in with your new credential!"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                          
                                                
                                                
                                            }];
                
                
                
                
                [alert addAction:yesButton];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
                
                [SVProgressHUD dismiss];
                
            }
            else{
                
                
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"@Hipla"
                                             message:@"All fields are required !"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                
                                                self->_txtfld_Email.text = @"";
                                                self->_txtfld_Phone.text = @"";
                                                self->_txtfld_UserName.text =@"";
                                                self->_txtfld_Password.text = @"";
                                                [self->_txtfld_UserName becomeFirstResponder];
                                                
                                                
                                            }];
                
                
                
                
                [alert addAction:yesButton];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
                  [SVProgressHUD dismiss];

               
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
          
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check your network connection!"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
            
        }];
        
    }
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self autoScrolTextField:textField onScrollView:self.scrollView];
    
    //    if (textField==_txtfld_Email) {
    //
    //        [self displayToastWithMessage:@"Please use future netwings official email id for sign up..."];
    //    }
    
    if (textField == _txtfld_Designation){
        
        //  self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,1.4* (self.btnSignUpOutlet.frame.origin.y+self.btnSignUpOutlet.frame.size.height));
        
    }
    if(textField == _txtfld_Company){
        
        //  self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,1.4* (self.btnSignUpOutlet.frame.origin.y+self.btnSignUpOutlet.frame.size.height));
    }
    if(textField == _txtfld_Email){
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,1.4* (self.btnSignUpOutlet.frame.origin.y+self.btnSignUpOutlet.frame.size.height));
        
    }
    
    
    
    //  _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.btnSignUpOutlet.frame.origin.y+self.btnSignUpOutlet.frame.size.height+30);
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField == _txtfld_Phone && _txtfld_Phone.text.length > 0){
        
        NSString *stringToBeTested = _txtfld_Phone.text;
        
        NSString *mobileNumberPattern = @"[1-9][0-9]{9}";
        NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
        
        BOOL matched = [mobileNumberPred evaluateWithObject:stringToBeTested];
        
        if (matched){
            [self checking];
        }
        else{
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:@"Enter a valid phone number !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            
                                            self->_txtfld_Phone.text = @"";
                                            
                                            [self->_txtfld_Phone becomeFirstResponder];
                                            
                                            
                                        }];
            
            
            
            
            [alert addAction:yesButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
    }
    
    if (textField == _txtfld_UserName &&_txtfld_UserName.text.length>0){
        
        [self checking];
        
        
    }
    if (textField == _txtfld_Email & _txtfld_Email.text.length>0){
        
        
        
        
        if(![self NSStringIsValidEmail:_txtfld_Email.text]){
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:@"Enter a valid Email id !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            
                                            self->_txtfld_Phone.text = @"";
                                            
                                            [self->_txtfld_Phone becomeFirstResponder];
                                            
                                            
                                        }];
            
            
            
            
            [alert addAction:yesButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
            
        }else{
            
            [self checking];
            
            
        }
    }
    
    
}


-(void)checking{
    
    NSString *username = _txtfld_UserName.text;
    NSString *email = _txtfld_Email.text;
    NSString *phone = _txtfld_Phone.text;
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: username,@"username",email,@"email",phone,@"phone"
                            , nil];
    
    NSLog(@"Print paramenters ::%@",[params description]);
    
    NSString *host_url = [NSString stringWithFormat:@"%@checking.php",BASE_URL];
    
    NSLog(@"params : %@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
//        NSDictionary *responseDict = responseObject;
//
//        NSString *successStr = [responseDict objectForKey:@"error"];
        
        if (![[Utils sharedInstance] isNullString:[responseObject objectForKey:@"error" ]]) {
            
            NSLog(@"Success");
            
            if ([[responseObject objectForKey:@"error" ]intValue] == 1) {
                
                
                NSLog(@"Success");
                
            }
            else{
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"@Hipla"
                                             message:@"You are already registered try logging in with your credential !"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                
                                                
                                                self->_txtfld_UserName.text =  @"";
                                                self->_txtfld_Password.text = @"";
                                                self->_txtfld_FirstName.text = @"";
                                                self->_txtfld_LastName.text = @"";
                                                self->_txtfld_Email.text = @"";
                                                self->_txtfld_Phone.text = @"";
                                                self->_txtfld_Designation.text = @"";
                                                self->_txtfld_Department.text = @"";
                                                self->_txtfld_Company.text = @"";
                                                
                                                
                                                
                                                self.txtfld_UserName.becomeFirstResponder;
                                                
                                                
                                            }];
                
                
                
                
                [alert addAction:yesButton];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
                
                
                
                [SVProgressHUD dismiss];
                
                
                
            }
            
        }
        else{
            
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"@Hipla"
                                             message:@"You are already registered try logging  !"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                
                                                self->_txtfld_Email.text = @"";
                                                self->_txtfld_Phone.text = @"";
                                                self->_txtfld_UserName.text =@"";
                                                self->_txtfld_Password.text = @"";
                                                [self->_txtfld_UserName becomeFirstResponder];
                                                
                                                
                                            }];
                
                
                
                
                [alert addAction:yesButton];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
           
            
            
            
            [SVProgressHUD dismiss];
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check your network connection!"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];
    
    
    
    
    
    
}


#pragma mark - Notifications and methods

-(void)showDepartments
{
    arrDepartMents = [[NSMutableArray alloc] initWithObjects:@"Management",@"Marketing",@"HR & Admin",@"Finance",@"Support",@"IT", nil];
    
    UIViewController *controller = [[UIViewController alloc]init];
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, 272, 250);
    
    [controller setPreferredContentSize:rect.size];
    
    _tblDepartments  = [[UITableView alloc]initWithFrame:rect];
    _tblDepartments.delegate = self;
    _tblDepartments.dataSource = self;
    _tblDepartments.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"management_bg.png"]];
    
    _tblDepartments.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tblDepartments setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tblDepartments setTag:10];
    _tblDepartments.allowsMultipleSelection = YES;
    
    [controller.view addSubview:_tblDepartments];
    
    [controller.view bringSubviewToFront:_tblDepartments];
    
    [controller.view setBackgroundColor:[UIColor whiteColor]];
    
    [controller.view setUserInteractionEnabled:YES];
    
    [_tblDepartments setUserInteractionEnabled:YES];
    [_tblDepartments setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:@"Departments" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController setValue:controller forKey:@"contentViewController"];
    
    //  [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"management_bg.png"]]];
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    
    tapPress.delaysTouchesBegan = NO;
    tapPress.cancelsTouchesInView = NO;
    
    [alertController.view.superview addGestureRecognizer:tapPress];
    
    [self presentViewController: alertController
                       animated: YES
                     completion:^{
                         self->alertController.view.superview.userInteractionEnabled = YES;
                         [self->alertController.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapPress:)]];
                     }];
}


- (void)tapPress:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion: nil];
}

-(BOOL)notEmptyChecking{
    
    if(_txtfld_UserName.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Username cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_UserName becomeFirstResponder];
        
        return NO;
        
    }else if(_txtfld_Password.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_Password becomeFirstResponder];
        
        return NO;
        
    }
    
    if(_txtfld_FirstName.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"First name cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_FirstName becomeFirstResponder];
        
        return NO;
        
    }else if(_txtfld_LastName.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Last name cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_LastName becomeFirstResponder];
        
        return NO;
        
    }
    if(_txtfld_Email.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_Email becomeFirstResponder];
        
        return NO;
        
    }else if(_txtfld_Phone.text.length<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Phone cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        // [SVProgressHUD dismiss];
        
        [_txtfld_Phone becomeFirstResponder];
        
        return NO;
        
    }
    
    if(isEmployee){
        
        if(_txtfld_Department.text.length<1){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Department cannot be empty."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            // [SVProgressHUD dismiss];
            
            [_txtfld_Department becomeFirstResponder];
            
            return NO;
            
        }else if(_txtfld_Designation.text.length<1){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Designation cannot be empty."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            // [SVProgressHUD dismiss];
            
            [_txtfld_Designation becomeFirstResponder];
            
            return NO;
            
        }
        
    }
    
    return YES;
}




-(BOOL) validityChecking{
    
    BOOL validEmail = [self NSStringIsValidEmail:_txtfld_Email.text];
    
    if(validEmail == NO){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide a valid email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [_txtfld_Email becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}


-(BOOL) NSStringIsValidEmail:(NSString *)emailString{
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

-(void)displayToastWithMessage:(NSString *)toastMessage
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = toastMessage;
        toastView.font = [UIFont systemFontOfSize:14];
        toastView.textColor = [UIColor blackColor];
        toastView.backgroundColor = [UIColor whiteColor];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width/2.0, 150.0);
        toastView.layer.cornerRadius = 10;
        toastView.lineBreakMode = NSLineBreakByWordWrapping;
        toastView.numberOfLines = 5;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 5.0f
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             
                             toastView.alpha = 0.0;
                             
                         }
                         completion: ^(BOOL finished) {
                             
                             [toastView removeFromSuperview];
                         }
         ];
    }];
}


- (void) autoScrolTextField: (UITextField *) textField onScrollView: (UIScrollView *) scrollView {
    
    previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PreviousButton"]
                                                      style:UIBarButtonItemStyleDone target:self
                                                     action:@selector(previousClicked:)];
    
    nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NextButton"]
                                                  style:UIBarButtonItemStyleDone target:self
                                                 action:@selector(nextClicked:)];
    
    
    
    flexBarButton = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                     target:nil action:nil];
    
//   // doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                  style:UIBarButtonItemStyleDone target:self
//                                                 action:@selector(doneClicked:)];
    
    keyboardDoneButtonView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    
    
    UIImage *backImage = [[UIImage imageNamed:@"backImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *forwardImage = [[UIImage imageNamed:@"forward"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:backImage, forwardImage,nil]];
    
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedState:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.tintColor = [UIColor clearColor];
    
    UIBarButtonItem *aSegmentedControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:aSegmentedControlBarButtonItem,flexBarButton,doneButton, nil]];
    
    [keyboardDoneButtonView sizeToFit];

    textField.inputAccessoryView = keyboardDoneButtonView;
    
    doneKeyboardHeight = keyboardDoneButtonView.frame.size.height;
    
    
    float slidePoint = 0.0f;
    float keyBoard_Y_Origin = self.view.bounds.size.height - 216.0f;
    
    float textFieldButtomPoint = textField.superview.frame.origin.y + (textField.frame.origin.y + textField.frame.size.height);
    
    if (keyBoard_Y_Origin < textFieldButtomPoint - scrollView.contentOffset.y) {
        
        slidePoint = textFieldButtomPoint - keyBoard_Y_Origin + 10.0f;
        
        CGPoint point = CGPointMake(0.0f, slidePoint);
        
        scrollView.contentOffset = point;
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
