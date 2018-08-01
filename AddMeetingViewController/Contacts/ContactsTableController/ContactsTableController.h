//
//  ContactsTableController.h
//  SmartOffice
//
//  Created by FNSPL on 19/03/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "Constants.h"
#import "selectionContactVw.h"

@protocol ContactsTableControllerDelegate;
@class ContactsTableController;

@protocol ContactsTableControllerDelegate <NSObject>

@optional

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name andphNo:(CNContact *)contact;

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph;

@end

@interface ContactsTableController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,selectionContactDelegate>
{
   NSMutableArray *contactsArray;
   NSMutableArray *filterArray;
    
   BOOL isSearch;
   selectionContactVw *selectionVw;
}

@property (nonatomic)id<ContactsTableControllerDelegate> delegate;

@property (strong,nonatomic) IBOutlet UITableView *contacts;
@property (strong,nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *phNo;

@end
