//
//  MeetingTimeCollectionViewCell.h
//  SmartOffice
//
//  Created by FNSPL on 20/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetingTimeCollectionViewCellDelegate <NSObject>

@optional
- (void)cellTap:(id)sender;

@end


@interface MeetingTimeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<MeetingTimeCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

- (IBAction)actionBtnTime:(id)sender;

@end
