//
//  NetPopViewController.m
//  @TCS
//
//  Created by FNSPL5 on 25/06/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "NetPopViewController.h"

@interface NetPopViewController ()

@end

@implementation NetPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.txtView_pop.userInteractionEnabled = false;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (IBAction)btnAction_Reconnect:(UIButton *)sender {
    
    
    
    if (!([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable))
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
   
    
  
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
