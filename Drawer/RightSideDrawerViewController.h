//
//  RightSideDrawerViewController.h
//  SmartOffice
//
//  Created by FNSPL on 09/01/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
//#import "Database.h"
#import "Common.h"
#import "DrawerTableViewCell.h"
//#import "AboutUsViewController.h"

@interface RightSideDrawerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,sharedCommonDelegate>
{
   // Database *db;
    
    NSMutableArray *userArr;
    
    int Index;
    
    NSDictionary *userDict;
    Common *objcommon;
}

- (IBAction)btnExitDrawerDidTap:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewBlur;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Username;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_Menu;
@property (weak, nonatomic) NSMutableArray *arrMeetings;

@end
