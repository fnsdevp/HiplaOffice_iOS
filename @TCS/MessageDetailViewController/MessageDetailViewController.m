//
//  MessageDetailViewController.m
//  @TCS
//
//  Created by FNSPL on 09/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _lbl_Name.text = [self.getDictFromMessage valueForKeyPath:@"from.Name"];
    _lbl_EmailId.text = [self.getDictFromMessage valueForKeyPath:@"from.Email"];
    _lbl_PhoneNo.text = [self.getDictFromMessage valueForKeyPath:@"from.Phone"];
    _lbl_MessageTitle.text = [self.getDictFromMessage valueForKeyPath:@"title"];
    _lbl_MessageDescription.text = [self.getDictFromMessage valueForKey:@"msg"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAction_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
