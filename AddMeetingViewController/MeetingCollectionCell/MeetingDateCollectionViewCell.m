//
//  MeetingFormCollectionViewCell.m
//  SmartOffice
//
//  Created by FNSPL on 20/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "MeetingDateCollectionViewCell.h"

@implementation MeetingDateCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self prepareForReuse];
}

- (void)prepareForReuse {
    
    self.lblday.text = nil;
    self.lblDate.text = nil;
    self.lblMonth.text = nil;
    
    [super prepareForReuse];
}

- (IBAction)actionBtnDate:(id)sender {
    
    if (!self.isFexible) {
        
        if ([self.delegate respondsToSelector:@selector(dateCellTap1:)]) {
            
            [self.delegate dateCellTap1:self];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(dateCellTap2:)]) {
            
            [self.delegate dateCellTap2:self];
        }
    }
    
}

@end
