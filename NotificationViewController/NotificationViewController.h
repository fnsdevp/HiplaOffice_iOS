//
//  NotificationViewController.h
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BaseViewController.h"
#import "Database.h"
#import "Popup.h"

@interface NotificationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupDelegate,UITextViewDelegate>
{
    Database *db;
    NSMutableArray *arrayNotif;
    
    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomingType;
    PopupOutgoingTransitionType outgoingType;
    
    Popup *popper;
    UIView *view;
    BOOL hasRoundedCorners;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVIew_Notification;

- (IBAction)btnDrawerMenuDidTap:(id)sender;

@end
