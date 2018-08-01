//
//  ProductCell.h
//  SmartOffice
//
//  Created by FNSPL on 07/08/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menudetails.h"
#import "PantryViewController.h"

@class PantryViewController;

@protocol PantryViewDelegate
@optional
// list of optional methods
- (void)modifyItem1:(id)item;
@end

@interface ProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemlbl;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;

@property (weak, nonatomic) NSDictionary* item;
@property (weak, nonatomic) Menudetails* menudetails;

@property (weak, nonatomic) PantryViewController* delegate;


@property (strong, nonatomic) id <PantryViewDelegate> pantryDelegate;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingImg;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadinglbl;

-(IBAction)btnAddDidTap:(UIButton *)sender;
-(IBAction)btnDelDidTap:(UIButton *)sender;
    
@end
