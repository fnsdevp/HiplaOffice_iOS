//
//  OrderViewController.h
//  @TCS
//
//  Created by FNSPL on 25/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView_Navigine;

@property (weak, nonatomic) IBOutlet UIButton *button_OrderReceived;

- (IBAction)btnAction_OrderReceived:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Etd;


@end
