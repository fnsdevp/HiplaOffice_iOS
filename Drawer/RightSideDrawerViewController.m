//
//  RightSideDrawerViewController.m
//  SmartOffice
//
//  Created by FNSPL on 09/01/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "RightSideDrawerViewController.h"

@interface RightSideDrawerViewController (){
    
    NSArray *options;

}

@end


@implementation RightSideDrawerViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([Userdefaults objectForKey:@"ProfInfo"] !=nil) {
        
        userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        _lbl_Username.text = [NSString stringWithFormat:@"You are logged in as %@ %@",[userDict objectForKey:@"fname"],[userDict objectForKey:@"lname"]];
        
        [_lbl_Username sizeToFit];
        
    }
    
    [self.imgBG setFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    objcommon = [Common sharedCommonManager];
    
    objcommon.delegate = self;
    
    if ([objcommon.meetingsArr count]>0) {
        
        self.arrMeetings = (NSMutableArray *)[objcommon.meetingsArr mutableCopy];
    }
    
    [self setMenuDetails];
    
    [self.tblVw_Menu reloadData];
    
   // [objcommon getUpcomingMeetings];
    
   // db = [Database sharedDB];
    
  //  userArr = [db getUser];
    
}


#pragma mark - sharedCommonDelegate

- (void)getArrayOfUpcommingMeeting:(NSArray *)UpcommingMeetingsArr
{
    self.arrMeetings = (NSMutableArray *)[UpcommingMeetingsArr mutableCopy];
    
    [self setMenuDetails];
    
    [self.tblVw_Menu reloadData];
}


-(void)setMenuDetails
{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Home",@"title",@"home_Drawer",@"image", nil];
    
    NSDictionary *dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Manage Meetings",@"title",@"manageMeeting",@"image", nil];
    
    NSDictionary *dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Notification",@"title",@"notification_icon",@"image", nil];
    
    NSDictionary *dict3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Messages",@"title",@"message",@"image", nil];
    
    NSDictionary *dict4 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Control Panel",@"title",@"controlPanel",@"image", nil];
    
    NSDictionary *dict5 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Profile Management",@"title",@"profile",@"image", nil];
    
    NSDictionary *dict6 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Set Availability",@"title",@"setAvailability",@"image", nil];
    
//    NSDictionary *dict7 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Hot Desk",@"title",@"seat",@"image", nil];
    
    NSDictionary *dict8 = [[NSDictionary alloc]initWithObjectsAndKeys:@"About Us",@"title",@"about",@"image", nil];
    
    NSDictionary *dict9 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Logout",@"title",@"logout",@"image", nil];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    if ([userType isEqualToString:@"Guest"]) {
        
        if ([[Common sharedCommonManager] hasAnyMeetingBetweenTwoHours]) {
            
            options = @[dict,dict1,dict2,dict3,dict4,dict5,dict8,dict9];
            
        }else{
            
            options = @[dict,dict1,dict2,dict3,dict5,dict8,dict9];
            
        }
        
    }
    else
    {
        options = @[dict,dict1,dict2,dict3,dict4,dict5,dict6,dict8,dict9];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    DrawerTableViewCell *cell = (DrawerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DrawerTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict =[options objectAtIndex:indexPath.row];
    
    cell.lbl_title.text = [dict objectForKey:@"title"];
    
    cell.imgVw_icon.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict =[options objectAtIndex:indexPath.row];
    
    Index = (int)indexPath.row;
    
    NSString *strTitle = [dict objectForKey:@"title"];
    
    if ([strTitle isEqualToString:@"Notification"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Messages"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Control Panel"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Profile Management"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Set Availability"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Hot Desk"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"About Us"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    else if ([strTitle isEqualToString:@"Logout"]) {
        
        Index = (int)(indexPath.row+1);
        
    }
    
    NSDictionary* userInfo = @{@"indexClickedOnDrawer": @(Index)};
    
    switch (Index) {
        
        case 0:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
            
        case 5:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
        case 6:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;

        case 7:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
        
        case 8:
           [[NSNotificationCenter defaultCenter]
            postNotificationName:@"ClickedDrawerOption"
            object:self userInfo:userInfo];
           break;
            
        case 9:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;
            
        case 10:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ClickedDrawerOption"
             object:self userInfo:userInfo];
            break;

        default:
            break;
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _tblVw_Menu.frame = CGRectMake(_tblVw_Menu.frame.origin.x, _tblVw_Menu.frame.origin.y, _tblVw_Menu.frame.size.width, _tblVw_Menu.contentSize.height);
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnExitDrawerDidTap:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ExitDrawer"
     object:self];

}


@end
