//
//  CreateMessageViewController.h
//  @TCS
//
//  Created by FNSPL on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTableController.h"
#import "VeeContactPickerViewController.h"
#import "FragmentMessageViewController.h"

@class FragmentMessageViewController;

@interface CreateMessageViewController : UIViewController<ContactsTableControllerDelegate,VeeContactPickerDelegate>{
    
     ContactsTableController *contactVC;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFld_To;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_Title;
@property (weak, nonatomic) IBOutlet UITextView *txtView_Message;

@property (weak, nonatomic) IBOutlet UIButton *button_ContactList;
@property (weak, nonatomic) IBOutlet UIButton *button_Send;

@property (weak, nonatomic) FragmentMessageViewController *fmVC;

- (IBAction)btnAction_ContactList:(id)sender;
- (IBAction)btnAction_SendMesage:(id)sender;

- (IBAction)btnAction_Back:(id)sender;


@end
