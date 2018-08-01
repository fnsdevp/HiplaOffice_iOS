//
//  SetAvailabilityTableViewCell.m
//  SmartOffice
//
//  Created by FNSPL on 10/07/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "SetAvailabilityTableViewCell.h"

@implementation SetAvailabilityTableViewCell



- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    
    self.vwDate.layer.cornerRadius = 5.0;
    self.vwDate.layer.borderColor = [UIColor blackColor].CGColor;
    self.vwDate.layer.borderWidth = 2.0;
    self.backgroundColor = [UIColor clearColor];
    
    //self.fromDatelbl.backgroundColor = [UIColor blueColor];
    
    NSLog(@"%f",self.fromDatelbl.frame.size.width);
    
    
    CALayer *lowerBorder1 = [CALayer layer];
    
    lowerBorder1.backgroundColor = [[UIColor whiteColor] CGColor];
    lowerBorder1.frame = CGRectMake(18, (self.fromDateBtn.frame.size.height-1), self.fromDateBtn.frame.size.width, 1);
    
    [self.fromDateBtn.layer addSublayer:lowerBorder1];
    
    
    CALayer *lowerBorder2 = [CALayer layer];
    
    lowerBorder2.backgroundColor = [[UIColor whiteColor] CGColor];
    lowerBorder2.frame = CGRectMake(18, (self.toDateBtn.frame.size.height-1), self.toDateBtn.frame.size.width, 1);
    
    [self.toDateBtn.layer addSublayer:lowerBorder2];
    
}

- (void)addLowerBorder:(UITextField *)txt
{
    CALayer *lowerBorder = [CALayer layer];
    
    lowerBorder.backgroundColor = [[UIColor whiteColor] CGColor];
    lowerBorder.frame = CGRectMake(10, (txt.frame.size.height-1), txt.frame.size.width, 1);
    
    [txt.layer addSublayer:lowerBorder];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
