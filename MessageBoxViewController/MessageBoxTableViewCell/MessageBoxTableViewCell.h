//
//  MessageBoxTableViewCell.h
//  @TCS
//
//  Created by FNSPL on 08/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBoxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Logo;

@property (weak, nonatomic) IBOutlet UILabel *lbl_MessageTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_phoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Description;

@property (weak, nonatomic) IBOutlet UIView *view_Calendar;


@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;


@property (weak, nonatomic) IBOutlet UILabel *lbl_MonthYear;




@end
