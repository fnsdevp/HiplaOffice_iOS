//
//  PantryOrderReceivedViewController.h
//  @TCS
//
//  Created by fnspl3 on 04/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DashBoardViewController.h"

@interface PantryOrderReceivedViewController : BaseViewController
{
    NSString *status;
}
@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderReceived;
@property (strong, nonatomic) IBOutlet UILabel *lblMin;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSDictionary *order_Dict;

@end
