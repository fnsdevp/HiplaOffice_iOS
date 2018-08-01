//
//  ProductCell.m
//  SmartOffice
//
//  Created by FNSPL on 07/08/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnAddDidTap:(UIButton *)sender {
    
    NSInteger quantity = [[self.itemCount text] integerValue];
    quantity++;
    [_itemCount setText:[NSString stringWithFormat:@"%ld", quantity]];
    [_menudetails setQuantity:quantity];
  
        
        [self.pantryDelegate modifyItem1:_menudetails];
        
  
    
}

-(IBAction)btnDelDidTap:(UIButton *)sender {
    
    NSInteger quantity = [[self.itemCount text] integerValue];
    if (quantity>0) {
        
        quantity--;
        [_itemCount setText:[NSString stringWithFormat:@"%ld", quantity]];
        [_menudetails setQuantity:quantity];
        
            
            [self.pantryDelegate modifyItem1:_menudetails];
            
      
        
    } else {
        
    }
    
}


@end
