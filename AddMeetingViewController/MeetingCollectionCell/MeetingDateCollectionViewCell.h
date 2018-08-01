//
//  MeetingFormCollectionViewCell.h
//  SmartOffice
//
//  Created by FNSPL on 20/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetingDateCollectionViewCellDelegate <NSObject>

@optional
- (void)dateCellTap1:(id)sender;
- (void)dateCellTap2:(id)sender;

@end

@interface MeetingDateCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblday;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UIView *backVW;
@property (assign, nonatomic) BOOL isFexible;
@property (weak, nonatomic) id<MeetingDateCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

- (IBAction)actionBtnDate:(id)sender;

@end
