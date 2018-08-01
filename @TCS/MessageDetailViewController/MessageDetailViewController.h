//
//  MessageDetailViewController.h
//  @TCS
//
//  Created by FNSPL on 09/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;

@property (weak, nonatomic) IBOutlet UILabel *lbl_EmailId;

@property (weak, nonatomic) IBOutlet UILabel *lbl_PhoneNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MessageTitle;
@property (weak, nonatomic) IBOutlet UITextView *lbl_MessageDescription;

@property (assign, nonatomic) NSString *str_FragmentControl;

- (IBAction)btnAction_Back:(id)sender;
@property(weak,nonatomic)NSMutableDictionary *getDictFromMessage;



@end
