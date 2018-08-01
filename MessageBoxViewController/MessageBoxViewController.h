//
//  MessageBoxViewController.h
//  @TCS
//
//  Created by FNSPL on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "BaseViewController.h"
#import "MessageBoxTableViewCell.h"
#import "MessageDetailViewController.h"
#import "FragmentMessageViewController.h"
#import "CreateMessageViewController.h"
#import "Reachability.h"



@class FragmentMessageViewController;
@class CreateMessageViewController;

@interface MessageBoxViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    CreateMessageViewController *createMessageView;
    
}
@property (weak, nonatomic) IBOutlet UIView *view_Show;

- (IBAction)btnAction_ShowMessage:(id)sender;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (assign, nonatomic) BOOL isInbox;
@property (weak, nonatomic) IBOutlet UITableView *tblView_MessageBox;
@property (weak, nonatomic) IBOutlet UIView *view_DropDown;
@property (weak, nonatomic) IBOutlet UIButton *button_Category;
@property (strong, nonatomic) NSMutableArray *arrayAllMessages;
@property (strong, nonatomic) NSString *str_ChangeURL;

@property (weak, nonatomic) FragmentMessageViewController *fmVC;
@property (weak, nonatomic) IBOutlet UIView *viewNetView;

-(void)getAllMessageswithType:(NSString*)categoryType;

@end
