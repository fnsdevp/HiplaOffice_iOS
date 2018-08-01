//
//  MeetingTimeCollectionViewCell.m
//  SmartOffice
//
//  Created by FNSPL on 20/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "MeetingTimeCollectionViewCell.h"

@implementation MeetingTimeCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.btnTime.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnTime.layer.borderWidth = 2.0;
    
}

- (IBAction)actionBtnTime:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellTap:)]) {
        
        [self.delegate cellTap:self];
    }
    
}

@end
