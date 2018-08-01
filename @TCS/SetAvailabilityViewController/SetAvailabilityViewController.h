//
//  SetAvailabilityViewController.h
//  @TCS
//
//  Created by FNSPL on 14/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "Constants.h"

@interface SetAvailabilityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    UIView *navView;
    UIDatePicker *timePicker;
    UIToolbar *toolbar;
    
    Database *db;
    
    NSDate *nextday;
    
    BOOL isFormDate;
    
    BOOL isON;
    
    NSString *userId;
    NSString *fromdate;
    NSString *todate;
    
    NSString *userID;
    NSString *date;
    NSString *day;
    NSString *from;
    NSString *to;
    NSString *status;
    
    NSMutableArray *userAvailArr;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tblAvailability;

- (IBAction)btnAction_Back:(id)sender;



@end
