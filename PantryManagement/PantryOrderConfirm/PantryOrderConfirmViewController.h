//
//  PantryOrderConfirmViewController.h
//  @TCS
//
//  Created by fnspl3 on 03/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "PantryTableCell.h"
#import "Menudetails.h"
#import "Common.h"
#import "OderConfirmTableViewCell.h"
#import "DashBoardViewController.h"
#import "PantryOrderReceivedViewController.h"

@class PantryOrderReceivedViewController;
@class DashBoardViewController;

@interface PantryOrderConfirmViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate,sharedCommonDelegate>{
    
    Common *objcommon;
    
    NSString *userID;
    NSString *location;
    int TypeTag;
    PantryOrderReceivedViewController *PantryOrderReceivedVC;
    
}
@property (strong, nonatomic) NSString *jsonString;
@property (strong, nonatomic) NSMutableDictionary *all_Categories;
@property (strong, nonatomic) NSMutableDictionary *meeting_Detail;
@property (strong, nonatomic) NSMutableArray *orderFoodArr;
@property (strong, nonatomic) NSMutableArray *quantity;

@property (strong, nonatomic) IBOutlet UILabel *lbl_TotalCount;
@property (strong, nonatomic) IBOutlet UITextView *txtView_Notes;
@property (strong, nonatomic) IBOutlet UITableView *tblConfirm;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVw_ConfirmOrder;
@property (strong, nonatomic) IBOutlet UIView *view_Comments;
@property (weak, nonatomic) IBOutlet UIView *view_CompanyNavBar;

@property (weak, nonatomic) NSDictionary *currentMeeting;
@property (weak, nonatomic) DashBoardViewController *dashboard;

- (IBAction)btnOrderConfirm:(id)sender;

@end
