//
//  PantryTableCell.m
//  SmartOffice
//
//  Created by FNSPL on 07/08/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "PantryTableCell.h"

@implementation PantryTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _backView.layer.cornerRadius = 5.0;
    _backView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    _backView.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
