//
//  AddRecepientViewController.m
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "AddRecepientViewController.h"

@interface AddRecepientViewController ()

@end


@implementation AddRecepientViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tblVw_AddRecepients.tableFooterView = [[UIView alloc]
                                              initWithFrame:CGRectZero];
    
    self.arrAddRecepients = [NSMutableArray arrayWithArray:[self.dictMeetingDetails objectForKey:@"recipient"]];
    
    meeting_id = [NSString stringWithFormat:@"%@",[self.dictMeetingDetails objectForKey:@"id"]];
    
}

#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.arrAddRecepients count]>0)
    {
        return [self.arrAddRecepients count];
    }
    else
    {
        return 0;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"AddRecepientViewCell";
    
    AddRecepientViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[AddRecepientViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([self.arrAddRecepients count]>0)
    {
        NSDictionary *dictRecepients = [self.arrAddRecepients objectAtIndex:indexPath.row];
    
        if (![[Utils sharedInstance] isNullString:[dictRecepients objectForKey:@"client_name"]]) {
            
            cell.lbl_NameTxt.text = [dictRecepients objectForKey:@"client_name"];
        }
        else
        {
            cell.lbl_NameTxt.text = @"";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Contact List

- (IBAction)btnAddContactDidTap:(id)sender {
    
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
    _txtfld_Name.text = name;
    
    NSString *phoneStr;
    
    phone = [[[contact.phoneNumbers firstObject] value] stringValue];
    
    if ([phone length] > 0) {
        
        phoneStr = phone;
        
    }
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
}


-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph
{
    _txtfld_Name.text = name;
    
    NSString *phoneStr;
    
    phoneStr = ph;
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
}


- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    //Do whatever you want with the selected veeContact!
    _txtfld_Name.text = [veeContact displayName];
    
    NSString *phoneStr = [[veeContact phoneNumbers]objectAtIndex:0];
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
}


- (void)didFailToAccessAddressBook
{
    //Show an error?
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please allow Phonebook access."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
}



#pragma mark - Button actions

-(IBAction)btnCancel:(id)sender
{
    [self.view removeFromSuperview];
}

-(IBAction)btnAdd:(id)sender
{
    if ([_txtfld_Name hasText]) {
        
        [self addReceipants];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please put a name first."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Api details

-(void)addReceipants{
    
    [SVProgressHUD show];
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSArray *arrName = [_txtfld_Name.text componentsSeparatedByString:@" "];
    
    if ([arrName count]>1 && [[arrName lastObject] length]>0) {
        
        fname = [arrName firstObject];
        
        lname = [arrName lastObject];
        
    } else {
        
        fname = [arrName firstObject];
        
        lname = @" ";
        
    }
    
    
    NSString *host_url = [NSString stringWithFormat:@"%@add_recp.php",BASE_URL];
    
    NSDictionary *params = @{@"username":phone,@"meeting_id":meeting_id,@"fname":fname,@"lname":lname,@"creator_id":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self.txtfld_Name.text = @"";
            
            [self getMeetingWithMeetingId:self->meeting_id];
            
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


-(void)getMeetingWithMeetingId:(NSString *)appointmentId{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@appointments_details_by_id.php",BASE_URL];
    
    NSDictionary *params = @{@"meeting_id":appointmentId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self.dictMeetingDetails = [[responseDict objectForKey:@"apointments"] objectAtIndex:0];
            
            self.arrAddRecepients = [NSMutableArray arrayWithArray:[self.dictMeetingDetails objectForKey:@"recipient"]];
            
            [self.tblVw_AddRecepients reloadData];
            
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
