//
//  ContactsTableController.m
//  SmartOffice
//
//  Created by FNSPL on 19/03/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "ContactsTableController.h"

@interface ContactsTableController ()

@end

@implementation ContactsTableController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    
    contactsArray = [[NSMutableArray alloc] init];
    
    [self addressBook];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
  //  [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
  //  [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

//- (void)keyboardWasShown:(NSNotification *)notification {
//
//    NSDictionary* info = [notification userInfo];
//
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    CGPoint keyboardOrigin = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
//
//    CGRect visibleRect = self.contacts.frame;
//
//    [Userdefaults setFloat:visibleRect.size.height forKey:@"visibleRect"];
//
//    [Userdefaults synchronize];
//
//    visibleRect.size.height = keyboardSize.height;
//
//    CGSize scrollSize = CGSizeMake(SCREENWIDTH, (visibleRect.origin.y+visibleRect.size.height) - (keyboardOrigin.y+keyboardSize.height+50));
//
//    [self.contacts setContentSize:scrollSize];
//
//}
//
//- (void)keyboardWillBeHidden:(NSNotification *)notification {
//
//    CGFloat height = [Userdefaults floatForKey:@"visibleRect"];
//
//    [self.contacts setContentSize:CGSizeMake(SCREENWIDTH, height)];
//
//    [Userdefaults removeObjectForKey:@"visibleRect"];
//
//    [Userdefaults synchronize];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addToolbar:(UISearchBar *)searchfld
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                           nil];
    
    [numberToolbar sizeToFit];
    
    searchfld.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    
    CGFloat height = [Userdefaults floatForKey:@"visibleRect"];
    
    [self.contacts setContentSize:CGSizeMake(SCREENWIDTH, height)];
    
    [Userdefaults removeObjectForKey:@"visibleRect"];
    
    [Userdefaults synchronize];
}

-(IBAction)backBtn:(id)sender
{
   // [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self addToolbar:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]>0) {
        
        isSearch = YES;
        
        filterArray = [[NSMutableArray alloc] init];
        
        for (CNContact *contact in contactsArray) {
            
           NSString *strName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
            
            if ([strName containsString:searchText]) {
                
                [filterArray addObject:contact];
            }
        }
        
        [self.contacts reloadData];
        
    } else {
        
        isSearch = NO;
        
        filterArray = [[NSMutableArray alloc] init];
        
        [self.contacts reloadData];
    }

}


-(void)addressBook
{
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * store = [[CNContactStore alloc] init];
            
            [store requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if(granted){
                    
                   // [self getAllContact:store];
                    
                    [self getAllContact];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            //[self getAllContact:store];
            
            [self getAllContact];
        }
    }

}


-(void)getAllContact
{
    if([CNContactStore class])
    {
        //iOS 9 or later
        NSError* contactError;
        
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        
        NSArray * keysToFetch = @[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
        
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        
        request.sortOrder = CNContactSortOrderGivenName;
        
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
            
            NSString *phoneNumber = @"";
            
            if([contact.phoneNumbers count]>0)
            {
                phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
                
                //NSLog(@"contact: %@", contact);
                
                [contactsArray addObject:contact];
                
            }
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.contacts reloadData];
        
    });
}

//-(void)getAllContact:(CNContactStore *)store
//{
//    
//    //keys with fetching properties
//    NSArray *keys = @[CNContactNamePrefixKey, CNContactNameSuffixKey, CNContactPhoneticGivenNameKey, CNContactNicknameKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey,CNContactTypeKey,CNContactEmailAddressesKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey];
//    
//    NSString *containerId = store.defaultContainerIdentifier;
//    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
//    NSError *error;
//    
//    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//    
//    if (error) {
//        NSLog(@"error fetching contacts %@", error);
//    } else {
//        
//        NSString *phone;
//        NSString *fullName;
//        NSString *firstName;
//        NSString *lastName;
//        NSString *nickname;
//        NSString *emailAddresses;
//        UIImage *profileImage;
//        
//        for (CNContact *contact in cnContacts) {
//            // copy data to my custom Contacts class.
//            firstName = contact.givenName;
//            lastName = contact.familyName;
//            
//            if (lastName == nil) {
//                fullName=[NSString stringWithFormat:@"%@",firstName];
//            }else if (firstName == nil){
//                fullName=[NSString stringWithFormat:@"%@",lastName];
//            }
//            else{
//                fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
//            }
//            
//            if (contact.nickname == nil) {
//                nickname=[NSString stringWithFormat:@"%@",contact.nickname];
//            }
//            
//            if (contact.emailAddresses == nil) {
//                emailAddresses=[NSString stringWithFormat:@"%@",contact.emailAddresses];
//            }
//            
//            UIImage *image = [UIImage imageWithData:contact.imageData];
//            
//            if (image != nil) {
//                profileImage = image;
//            }else{
//                profileImage = [UIImage imageNamed:@"person-icon.png"];
//            }
//            
//            NSString *phoneNumber = @"";
//            
//            if( contact.phoneNumbers)
//            {
//                phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
//                
//                //NSLog(@"contact: %@", contact);
//                
//                [contactsArray addObject:contact];
//                
//            }
//            
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.contacts reloadData];
//            
//        });
//    }
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearch) {
        
        return [filterArray count];
        
    } else {
        
        return [contactsArray count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (isSearch) {
        
        CNContact *contact = [filterArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];

    } else {
        
        CNContact *contact = [contactsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSLog(@"%@",[filterNumberArray objectAtIndex:indexPath.row]);
   // NSLog(@"%@",[[filterNumberArray objectAtIndex:indexPath.row] objectForKey:@"PhoneNumbers"]);
    
    if (isSearch) {
        
       // NSMutableArray *arrPh = [[filterNumberArray objectAtIndex:indexPath.row] objectForKey:@"PhoneNumbers"];
        
        CNContact *contact = [filterArray objectAtIndex:indexPath.row];
        
        if ([contact.phoneNumbers count]>0) {
            
            if ([contact.phoneNumbers count]==1) {
                
                [self.delegate ContactsTableController:self getName:[NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName] andphNo:contact];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                selectionVw = [[selectionContactVw alloc] init];
                
                selectionVw.frame = self.view.bounds;
                selectionVw.delegate = self;
                
                selectionVw.strName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
                
                selectionVw.arrayPh = contact.phoneNumbers;
                
                [selectionVw ResizeandReloadViews];
                
                [self.view addSubview:selectionVw];
                
            }
        }
        
    } else {
        
       // NSMutableArray *arrPh = [[contactNumbersArray objectAtIndex:indexPath.row] objectForKey:@"PhoneNumbers"];
        
        CNContact *contact = [contactsArray objectAtIndex:indexPath.row];
        
        if ([contact.phoneNumbers count]>0) {
            
            if ([contact.phoneNumbers count]==1) {
                
                [self.delegate ContactsTableController:self getName:[NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName] andphNo:contact];
                
                 [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                selectionVw = [[selectionContactVw alloc] init];
                
                selectionVw.frame = self.view.bounds;
                selectionVw.delegate = self;
                
                selectionVw.strName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
                
                selectionVw.arrayPh = contact.phoneNumbers;
                
                [selectionVw ResizeandReloadViews];
                
                [self.view addSubview:selectionVw];
                
           }
            
        }
        
    }
    
}


-(void)selectionContactVw:(selectionContactVw *)obj didTapOnCell:(BOOL)isTap withName:(NSString *)textName withPh:(NSString *)textPh
{
    [selectionVw removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.delegate ContactsTableController:self getName:textName withphNo:textPh];
    
}

-(void)selectionContactVw:(selectionContactVw *)obj didTapOnBackground:(BOOL)isClose
{
    [selectionVw removeFromSuperview];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
