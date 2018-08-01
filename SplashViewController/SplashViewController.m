//
//  SplashViewController.m
//  @TCS
//
//  Created by FNSPL on 20/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    LNBRippleEffect *rippleEffect = [[LNBRippleEffect alloc]initWithImage:[UIImage imageNamed:@""] Frame:CGRectMake(_imgview_logo.frame.origin.x, _imgview_logo.frame.origin.y, _imgview_logo.frame.size.width, _imgview_logo.frame.size.height) Color:[UIColor colorWithRed:(28.0/255.0) green:(212.0/255.0) blue:(255.0/255.0) alpha:1] Target:@selector(buttonTapped:) ID:self];
    
    rippleEffect.layer.borderColor = [[UIColor clearColor] CGColor];
    [rippleEffect setRippleColor:[UIColor colorWithRed:(28.0/255.0) green:(212.0/255.0) blue:(255.0/255.0) alpha:1]];
    [rippleEffect setRippleTrailColor:[UIColor clearColor]];
    
    [self.view addSubview:rippleEffect];
    
    [self performSelector:@selector(loadMainScreen) withObject:self afterDelay:5.0f];
}

-(void)buttonTapped:(UIButton *)sender{
    
    NSLog(@"Button Clicked");
}

-(void)loadMainScreen{
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    if([isLoggedIn isEqualToString:@"YES"]){
        
        //NSString *userType = [Userdefaults objectForKey:@"userType"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        dashboard = [storyboard instantiateInitialViewController];
        
        [self.navigationController pushViewController:dashboard animated:YES];
        
        
        //        if ([userType isEqualToString:@"Guest"]) {
        //
        //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //            home = [storyboard instantiateInitialViewController];
        //            [self.navigationController pushViewController:home animated:YES];
        //
        //        }else{
        //
        //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EmployeeStoryboard" bundle:[NSBundle mainBundle]];
        //            empHome = [storyboard instantiateInitialViewController];
        //            [self.navigationController pushViewController:empHome animated:YES];
        //        }
        
    }else{
        
        login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:login animated:YES];
        
    }
    
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

@end
