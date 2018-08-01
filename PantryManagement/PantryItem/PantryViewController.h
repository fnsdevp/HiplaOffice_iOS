//
//  PantryViewController.h
//  SmartOffice
//
//  Created by FNSPL on 07/08/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "Constants.h"
#import "PantryTableCell.h"
#import "ProductCell.h"
#import "PantryOrderConfirmViewController.h"

@class PantryOrderConfirmViewController;

@interface PantryViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *navView;
    NSString *strFood;
    NSMutableArray *arrFood;
    
    NSArray *orderFoodArr;
    NSArray *categoryArr;
    
    NSString *host_url;
    
    BOOL isTypeClicked;
    
    int TypeTag;
    
    PantryOrderConfirmViewController *PantryOrderConfirmVC;
}

@property (weak, nonatomic) NSDictionary *currentMeeting;

@property (weak, nonatomic) IBOutlet UITableView *tblPantry;

@property (weak, nonatomic) IBOutlet UIView *headingVw;
    
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

@property (nonatomic, strong) NSMutableArray* items;

- (IBAction)btnOrderDidTap:(id)sender;

- (void)modifyItem1:(id)item;

@end
