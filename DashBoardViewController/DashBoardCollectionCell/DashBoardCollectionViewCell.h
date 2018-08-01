//
//  DashBoardCollectionViewCell.h
//  @TCS
//
//  Created by FNSPL on 23/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardViewController.h"

@class DashBoardViewController;

@interface DashBoardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Icon;
@property (weak, nonatomic) IBOutlet UIView *vwBack;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) DashBoardViewController* dbVC;
@property (nonatomic, strong) NSLayoutConstraint *cellWidthConstraint;

- (void)setCellWidth:(CGFloat) width;

@end
