//
//  CreateMessageViewController.m
//  @TCS
//
//  Created by FNSPL on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "CreateMessageViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateMessageViewController (){
    
    
     NSString *str_phone;
     NSString *str_title;
     NSString *str_message;
     NSString *str_userId;
    
}

@end

@implementation CreateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self.txtView_Message layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.txtView_Message layer] setBorderWidth:1];
    
     str_phone = @"";
    
    self.button_Send.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    
    [self.view endEditing:YES];
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


- (IBAction)btnAction_ContactList:(id)sender {
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0")) {
        
        contactVC = [[ContactsTableController alloc] init];
        
        contactVC.delegate = self;
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        [self presentViewController:contactVC animated:NO completion:nil];
    }
    else
    {
        
        VeeContactPickerViewController* veeContactPickerViewController = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
        veeContactPickerViewController.contactPickerDelegate = self;
        [self presentViewController:veeContactPickerViewController animated:YES completion:nil];
        
    }
    
    
}

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name andphNo:(CNContact *)contact
{
    NSString *phoneStr;
    
    str_phone = [[[contact.phoneNumbers firstObject] value] stringValue];
    
    if ([str_phone length] > 0) {
        
        phoneStr = str_phone;
    }
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    str_phone = [components componentsJoinedByString:@""];
    
    _txtFld_To.text = [NSString stringWithFormat:@"%@",name];
    
    if ([str_phone length]>0) {
        
       // [_btnPhone setTitle:@"Change" forState:UIControlStateNormal];
        
    } else {
        
       // [_btnPhone setTitle:@"Choose" forState:UIControlStateNormal];
    }
    
}

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph
{
    NSString *phoneStr;
    
    phoneStr = ph;
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    str_phone = [components componentsJoinedByString:@""];
    
    _txtFld_To.text = [NSString stringWithFormat:@"%@",str_phone];
    
    if ([str_phone length]>0) {
        
      //  [_btnPhone setTitle:@"Change" forState:UIControlStateNormal];
        
    } else {
        
       // [_btnPhone setTitle:@"Choose" forState:UIControlStateNormal];
    }
}
- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    //Do whatever you want with the selected veeContact!
    //_txtDepartmentName.text = [veeContact displayName];
    
    NSString *phoneStr = [[veeContact phoneNumbers]objectAtIndex:0];
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    str_phone = [components componentsJoinedByString:@""];
    
    _txtFld_To.text = [NSString stringWithFormat:@"%@",str_phone];
    
    
    if ([str_phone length]>0) {
        
       // [_btnPhone setTitle:@"Change Phone Number" forState:UIControlStateNormal];
        
    } else {
        
      //  [_btnPhone setTitle:@"Choose Phone Number" forState:UIControlStateNormal];
    }
    
}


- (IBAction)btnAction_Back:(id)sender {
    
    if (self.fmVC) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.fmVC BackToFragment];
        
    }
}


- (IBAction)btnSubmitDidTap:(id)sender {
    
     if (str_phone.length<1) {
        
        [[[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"Please insert Contact No" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        // [_txtFld_ContactNo becomeFirstResponder];
        
    }
    
    else if (_txtFld_Title.text.length<1) {
        
        [[[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"Please insert your title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        [_txtFld_Title becomeFirstResponder];
        
        
    }else if (_txtView_Message.text.length<1) {
        
        [[[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"Please insert your message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        [_txtView_Message becomeFirstResponder];
        
        
    }
    else
    {
        [self createMessage];
        
    }
}

-(void)createMessage
{
    [SVProgressHUD show];
    
    str_title = _txtFld_Title.text;
    
    str_message = _txtView_Message.text;
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    str_userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":str_userId,@"phone":str_phone,@"title":str_title,@"message":str_message};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@createMsg.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSString *success = [dict objectForKey:@"status"];
        
        NSString *msgStr = [dict objectForKey:@"message"];
        
        if ([success isEqualToString:@"success"]) {
            
            if ([msgStr isEqualToString:@"Message Sent"]) {
                
                [SVProgressHUD dismiss];
                
                if (self.fmVC) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"@Hipla"
                                                                        message:[dict objectForKey:@"message"]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [self.fmVC BackToFragment];
                    
                }
               
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:[dict objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
                [SVProgressHUD dismiss];
                
            }
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Problem to send message, please check your internet connection & restart the app."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
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

@end
