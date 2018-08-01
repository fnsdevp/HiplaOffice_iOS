//
//  SetAvailabilityTableViewCell.h
//  SmartOffice
//
//  Created by FNSPL on 10/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAvailabilityTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *vwDate;
@property (nonatomic, strong) IBOutlet UILabel *weeklbl;
@property (nonatomic, strong) IBOutlet UILabel *datelbl;
@property (nonatomic, strong) IBOutlet UIButton *fromDateBtn;
@property (nonatomic, strong) IBOutlet UILabel *fromDatelbl;
@property (nonatomic, strong) IBOutlet UIButton *toDateBtn;
@property (nonatomic, strong) IBOutlet UILabel *toDatelbl;
@property (nonatomic, strong) IBOutlet UISwitch *availon;

@end
