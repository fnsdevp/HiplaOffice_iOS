//
//  DashBoardTableViewCell.m
//  @TCS
//
//  Created by FNSPL on 04/06/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "DashBoardTableViewCell.h"

@implementation DashBoardTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (IBAction)actionBtnCall:(UIButton *)sender {
    
    _dbVC.upcomingMeetingsArr = self.upcomingMeetingsArr;
    
    [_dbVC callTap:self];
}

- (IBAction)actionBtnNavigate:(id)sender {
   
   [_dbVC navigateTap:self];
    
}

- (IBAction)actionBtnCancel:(id)sender {
    
    _dbVC.upcomingMeetingsArr = self.upcomingMeetingsArr;
        
    [_dbVC cancelTap:self];
}

- (IBAction)actionBtnReshedule:(UIButton *)sender {
    
        NSString *fDateSel = [self.dictMeetingDetails objectForKey:@"fdate"];
    
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        NSString *strDateTime = [NSString stringWithFormat:@"%@",fDateSel];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [dt setLocale:locale];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *FirstDate = [dt dateFromString:strDateTime];
        
        NSDate *currentDate = [NSDate date];
        
        unsigned int unitFlags = NSCalendarUnitDay;
        
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:FirstDate  toDate:currentDate  options:0];
        
        int days = (int)[comps day];
        
        NSLog(@"%d",days);
        
        if (days > 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You cannot reschedule a past meeting."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
        } else {
            
            [_dbVC rescheduleTap:self];
            
        }
        
    
    
}

- (IBAction)actionBtnConfirm:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _dbVC = [storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
    
    
}


@end
