//
//  AddBelongingsViewController.m
//  @TCS
//
//  Created by FNSPL5 on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "AddBelongingsViewController.h"

@interface AddBelongingsViewController ()

@end


@implementation AddBelongingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tblVw_AddBelongings.tableFooterView = [[UIView alloc]
                                              initWithFrame:CGRectZero];
    
    self.arrAddBelongings = [[NSMutableArray alloc] init];
    
    meeting_id = [NSString stringWithFormat:@"%@",[self.dictMeetingDetails objectForKey:@"id"]];
    
    [self getBelongings];
    
}

#pragma mark - TableView Delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.arrAddBelongings count]>0)
    {
        return [self.arrAddBelongings count];
    }
    else
    {
        return 0;
    }
     
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameFirst = @"AddBelongingsViewCell";
    
    AddBelongingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameFirst];
    
    if (cell == NULL)
    {
        cell = [[AddBelongingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameFirst];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tag = indexPath.row;
    
    if([self.arrAddBelongings count]>0)
    {
        NSDictionary *dictBelongings = [self.arrAddBelongings objectAtIndex:indexPath.row];
        
        cell.lbl_ItemName.text = [dictBelongings objectForKey:@"property_type"];
        cell.lbl_Value.text = [dictBelongings objectForKey:@"property_value"];
        
    }
    
    cell.btn_Delete.tag = indexPath.row;
    
    [cell.btn_Delete addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Button actions

-(IBAction)btnCancel:(id)sender
{
    [self.view removeFromSuperview];
}

-(IBAction)btnAdd:(id)sender
{
    [self addBelongings];
}

-(IBAction)btnDelete:(UIButton *)sender
{
    NSDictionary *dictBelongings = [self.arrAddBelongings objectAtIndex:sender.tag];
    
    NSString *row_id = [dictBelongings objectForKey:@"id"];
    
    [self deleteBelongings:row_id];
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Api details

-(void)getBelongings{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_belongings.php",BASE_URL];
    
    NSDictionary *params = @{@"meeting_id":meeting_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self.arrAddBelongings = [responseDict objectForKey:@"belongings"];
            
            [self.tblVw_AddBelongings reloadData];
            
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

-(void)addBelongings{
    
    [SVProgressHUD show];
    
    property_type = self.txtfld_ItemName.text;
    property_value = self.txtfld_Value.text;
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSString *host_url = [NSString stringWithFormat:@"%@add_belongings.php",BASE_URL];
    
    NSDictionary *params = @{@"meeting_id":meeting_id,@"guest_id":userId,@"property_type":property_type,@"property_value":property_value,@"device_id":[Userdefaults objectForKey:@"device_id"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            self.txtfld_ItemName.text = @"";
            self.txtfld_Value.text = @"";
            
            [self getBelongings];
            
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


-(void)deleteBelongings:(NSString *)rowId{
    
    [SVProgressHUD show];
    
    NSString *host_url = [NSString stringWithFormat:@"%@delete_belongings.php",BASE_URL];
    
    NSDictionary *params = @{@"row_id":rowId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [self getBelongings];
            
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
