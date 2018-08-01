//
//  AddMeetingViewController.m
//  @TCS
//
//  Created by FNSPL on 19/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "AddMeetingViewController.h"
#import "ControlPanelViewController.h"
#import "ProfileDetailViewController.h"
@interface AddMeetingViewController ()
{
    WWCalendarTimeSelector *dateSel;
    
    UIView *navView;
    bool firstDate;
    bool secondDate;
    
    NSString *nameStr;
    NSString *department;
    NSString *designation;
    NSString *fromTime;
    NSString *toTime;
    NSString *duration;
    NSString *agenda;
    NSString *fdate;
    NSString *sdate;
    NSString *hr;
    NSString *min;
    NSString *per;
    NSString *daySel;
    NSString *monthSel;
    NSString *yearSel;
    NSString *phone;
    NSString *fDateSel;
    NSString *sDateSel;
    NSArray *venues;
    
    NSMutableArray *arrTimes;
    NSMutableArray *arrIndex;
}

@end


@implementation AddMeetingViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
    
    if (within400Meter)
    {
        // [[ZoneDetection sharedZoneDetection] setDelegate:self];
    }
    
    self->_view_Confirmation.hidden = YES;
    self.VwPicker.hidden = YES;
    self.addMeetingBackView.hidden = YES;
    
    [self.collectionView_Dates registerNib:[UINib nibWithNibName:@"MeetingDateCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"MeetingDateCollectionViewCell"];
    
    [self.collectionView_Times registerNib:[UINib nibWithNibName:@"MeetingTimeCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"MeetingTimeCollectionViewCell"];
    
    
    self.confirmMeetingView.layer.cornerRadius = 5.0;
    
    // [self showViewConfirmation];
    
    //    [self.lbl_DepartmentName setText:@"Test"];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.btn_Confirm setEnabled:YES];

    
    //self.lbl_DepartmentName.text = [NSString stringWithFormat:@"%@",nameStr];
    
    NSString *isMeetingTimeSlot  = [Userdefaults objectForKey:@"isMeetingTimeSlot"];
    
    if ([isMeetingTimeSlot isEqualToString:@"60 min"]) {
        
        hours = @[@"09:00 AM-10:00 AM",@"10:00 AM-11:00 PM",@"11:00 AM-12:00 PM",@"12:00 PM-01:00 PM",@"01:00 PM-02:00 PM",@"02:00 PM-03:00 PM",@"03:00 PM-04:00 PM",@"04:00 PM-05:00 PM",@"05:00 PM-06:00 PM",@"06:00 PM-07:00 PM",@"07:00 PM-08:00 PM",@"08:00 PM-09:00 PM"];
        
    } else {
        
        hours = @[@"09:00 AM-09:30 AM",@"09:30 AM-10:00 AM",@"10:00 AM-10:30 AM",@"10:30 AM-11:00 PM",@"11:00 AM-11:30 AM",@"11:30 AM-12:00 PM",@"12:00 PM-12:30 PM",@"12:30 PM-01:00 PM",@"01:00 PM-01:30 PM",@"01:30 PM-02:00 PM",@"02:00 PM-02:30 PM",@"02:30 PM-03:00 PM",@"03:00 PM-03:30 PM",@"03:30 PM-04:00 PM",@"04:00 PM-04:30 PM",@"04:30 PM-05:00 PM",@"05:00 PM-05:30 PM",@"05:30 PM-06:00 PM",@"06:00 PM-06:30 PM",@"06:30 PM-07:00 PM",@"07:00 PM-07:30 PM",@"07:30 PM-08:00 PM",@"08:00 PM-08:30 PM",@"08:30 PM-09:00 PM"];
        
    }
    
    self->_view_Confirmation.hidden = YES;
    self.VwPicker.hidden = YES;
    self.addMeetingBackView.hidden = YES;
    
    [self.collectionView_Dates registerNib:[UINib nibWithNibName:@"MeetingDateCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"MeetingDateCollectionViewCell"];
    
    [self.collectionView_Times registerNib:[UINib nibWithNibName:@"MeetingTimeCollectionViewCell" bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"MeetingTimeCollectionViewCell"];
    
    
    self.confirmMeetingView.layer.cornerRadius = 5.0;
    
    arrTimes = [[NSMutableArray alloc] init];
    
    arrBooked = [[NSMutableArray alloc] init];
    
    fdate = @"";
    sdate = @"";
    fromTime = @"";
    toTime = @"";
    
    self->_view_Confirmation.hidden = YES;
    self.VwPicker.hidden = YES;
    self.addMeetingBackView.hidden = YES;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    
    fdate = [dateFormatter stringFromDate:[NSDate date]];
    sdate = @"";
    
    selectedDate = fdate;
    
    initialDate = [dateFormatter dateFromString:fdate];
    
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
    [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
    
    fDateSel = [dateFormatterForAPI stringFromDate:[NSDate date]];
    sDateSel = @"";
    
    [self.collectionView_Times reloadData];
    
    //    [self.collectionView_Dates registerNib:[UINib nibWithNibName:@"MeetingDateCollectionViewCell" bundle:[NSBundle mainBundle]]
    //                forCellWithReuseIdentifier:@"MeetingDateCollectionViewCell"];
    //
    //    [self.collectionView_Times registerNib:[UINib nibWithNibName:@"MeetingTimeCollectionViewCell" bundle:[NSBundle mainBundle]]
    //                forCellWithReuseIdentifier:@"MeetingTimeCollectionViewCell"];
    
    //    [self.collectionView_Dates registerNib:[UINib nibWithNibName:@"MeetingDateCollectionViewCell" bundle:[NSBundle mainBundle]]
    //               forCellWithReuseIdentifier:@"MeetingDateCollectionViewCell"];
    
    //    [self.collectionView_Times registerNib:[UINib nibWithNibName:@"MeetingTimeCollectionViewCell" bundle:[NSBundle mainBundle]]
    //               forCellWithReuseIdentifier:@"MeetingTimeCollectionViewCell"];
    
    // [self.collectionView_Times registerClass:[MeetingDateCollectionViewCell class] forCellWithReuseIdentifier:@"MeetingTimeCollectionViewCell"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //  _navigineCore = nil;
    
    //  [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}


//#pragma mark - Button actions
//
//


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView == self.collectionView_Dates){
        
        return 8;
        
    }else{
        
        return [hours count];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.collectionView_Dates){
        
        return CGSizeMake(58, 61);
    }
    else
    {
        CGSize sizes = CGSizeMake(SCREENWIDTH/2, 46);
        
        return sizes;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.collectionView_Dates){
        
        if (!self.isFexible) {
            
            static NSString *identifier = @"MeetingDateCollectionViewCell";
            
            MeetingDateCollectionViewCell *cell1 = (MeetingDateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            
            cell1.tag = indexPath.item;
            cell1.btnDate.tag = indexPath.item;
            cell1.delegate = self;
            
            cell1.isFexible = self.isFexible;
            
            if (isSelectedDate) {
                
                NSLog(@"%d",(int)indexPath.item);
                
                if (indexPath.item==0) {
                    
                    nextday = initialDate;
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                }
                else
                {
                    nextday = initialDate;
                    nextday = [NSDate dateWithTimeInterval:((indexPath.item)*(24*60*60)) sinceDate:nextday];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                }
                
                
                NSLog(@"%@",nextday);
                NSLog(@"%d",(int)cell1.tag);
                
                
                [cell1.btnDate setSelected:NO];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                
                [df setDateFormat:@"EEE"];
                
                day = [df stringFromDate:nextday];
                
                cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                
                [df setDateFormat:@"d"];
                
                date = [df stringFromDate:nextday];
                
                cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                
                [df setDateFormat:@"MMM"];
                
                month = [df stringFromDate:nextday];
                
                cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                
                BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                
                
                if (isWeekEnd) {
                    
                    cell1.lblday.textColor = [UIColor redColor];
                    cell1.lblDate.textColor = [UIColor redColor];
                    cell1.lblMonth.textColor = [UIColor redColor];
                    
                    cell1.contentView.backgroundColor = [UIColor whiteColor];
                    
                    cell1.alpha = 1.0;
                    
                }
                else
                {
                    cell1.lblday.textColor = [UIColor whiteColor];
                    cell1.lblDate.textColor = [UIColor whiteColor];
                    cell1.lblMonth.textColor = [UIColor whiteColor];
                    
                    // cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                    
                    
                    cell1.alpha = 1.0;
                    
                }
                
                [df setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *fDate = [df dateFromString:[NSString stringWithFormat:@"%@",fdate]];
                
                NSComparisonResult compare1 = [nextday compare:fDate];
                
                if (compare1==NSOrderedSame) {
                    
                    [cell1.btnDate  setSelected:YES];
                    
                    cell1.lblday.textColor = [UIColor whiteColor];
                    cell1.lblDate.textColor = [UIColor whiteColor];
                    cell1.lblMonth.textColor = [UIColor whiteColor];
                    cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                    
                    
                    //                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                    
                    cell1.alpha = 1.0;
                }
                
                
                if (indexPath.item==7) {
                    
                    //nextday = initialDate;
                    
                    cell1.lblday.text = [NSString stringWithFormat:@""];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    cell1.lblDate.text = [NSString stringWithFormat:@"More"];
                    
                    cell1.lblMonth.text = [NSString stringWithFormat:@""];
                    
                    cell1.lblDate.textColor = [UIColor whiteColor];
                    
                    //                    cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                    
                    cell1.alpha = 1.0;
                    
                }
                
                
            } else {
                
                if (indexPath.item==0) {
                    
                    nextday = [NSDate date];
                    
                } else {
                    
                    nextday = [NSDate date];
                    nextday = [NSDate dateWithTimeInterval:((indexPath.item)*(24*60*60)) sinceDate:nextday];
                }
                
                if (indexPath.item==0) {
                    
                    if (cell1.userInteractionEnabled) {
                        
                        [cell1.btnDate  setSelected:YES];
                        
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        
                        [df setDateFormat:@"EEE"];
                        
                        day = [df stringFromDate:nextday];
                        
                        cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                        
                        [df setDateFormat:@"d"];
                        
                        date = [df stringFromDate:nextday];
                        
                        cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                        
                        [df setDateFormat:@"MMM"];
                        
                        month = [df stringFromDate:nextday];
                        
                        cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                        
                        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                        
                        BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                        
                        if (isWeekEnd) {
                            
                            cell1.lblday.textColor = [UIColor redColor];
                            cell1.lblDate.textColor = [UIColor redColor];
                            cell1.lblMonth.textColor = [UIColor redColor];
                            
                            //                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                            
                            cell1.alpha = 1.0;
                            
                        } else {
                            
                            cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                            
                            //                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                            
                        }
                        
                    }
                    else
                    {
                        [cell1.btnDate setSelected:NO];
                        
                        cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                        
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        
                        [df setDateFormat:@"EEE"];
                        
                        day = [df stringFromDate:nextday];
                        
                        cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                        
                        [df setDateFormat:@"d"];
                        
                        date = [df stringFromDate:nextday];
                        
                        cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                        
                        [df setDateFormat:@"MMM"];
                        
                        month = [df stringFromDate:nextday];
                        
                        cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                        
                        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                        
                        BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                        
                        if (isWeekEnd) {
                            
                            cell1.lblday.textColor = [UIColor redColor];
                            cell1.lblDate.textColor = [UIColor redColor];
                            cell1.lblMonth.textColor = [UIColor redColor];
                            
                            //                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                            
                            cell1.alpha = 1.0;
                            
                        }
                        else
                        {
                            //                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                            
                            cell1.alpha = 1.0;
                        }
                        
                    }
                    
                }
                else
                {
                    
                    [cell1.btnDate setSelected:NO];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setDateFormat:@"EEE"];
                    
                    day = [df stringFromDate:nextday];
                    
                    cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                    
                    [df setDateFormat:@"d"];
                    
                    date = [df stringFromDate:nextday];
                    
                    cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                    
                    [df setDateFormat:@"MMM"];
                    
                    month = [df stringFromDate:nextday];
                    
                    cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                    
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                    
                    if (isWeekEnd) {
                        
                        cell1.lblday.textColor = [UIColor redColor];
                        cell1.lblDate.textColor = [UIColor redColor];
                        cell1.lblMonth.textColor = [UIColor redColor];
                        
                        cell1.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
                        
                        cell1.alpha = 1.0;
                        
                    }
                    else
                    {
                        //                        cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                        cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                        
                        
                        cell1.alpha = 1.0;
                    }
                    
                    if (indexPath.item==7) {
                        
                        // nextday = [NSDate date];
                        
                        cell1.lblday.text = [NSString stringWithFormat:@""];
                        
                        cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                        cell1.lblDate.text = [NSString stringWithFormat:@"More"];
                        
                        cell1.lblMonth.text = [NSString stringWithFormat:@""];
                        
                        cell1.lblDate.textColor = [UIColor whiteColor];
                        
                        //                        cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
                        cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                        
                        cell1.alpha = 1.0;
                    }
                    
                }
                
            }
            
            return cell1;
            
        } else {
            
            static NSString *identifier = @"MeetingDateCollectionViewCell";
            
            MeetingDateCollectionViewCell *cell1 = (MeetingDateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            
            cell1.tag = indexPath.item;
            cell1.btnDate.tag = indexPath.item;
            cell1.delegate = self;
            
            cell1.isFexible = self.isFexible;
            
            if (isSelectedDate) {
                
                if (indexPath.item==0) {
                    
                    nextday = initialDate;
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                    
                }
                else
                {
                    nextday = initialDate;
                    nextday = [NSDate dateWithTimeInterval:((indexPath.item)*(24*60*60)) sinceDate:nextday];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                }
                
                NSLog(@"%@",nextday);
                NSLog(@"%d",(int)cell1.tag);
                
                [cell1.btnDate setSelected:NO];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                
                [df setDateFormat:@"EEE"];
                
                day = [df stringFromDate:nextday];
                
                cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                
                [df setDateFormat:@"d"];
                
                date = [df stringFromDate:nextday];
                
                cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                
                [df setDateFormat:@"MMM"];
                
                month = [df stringFromDate:nextday];
                
                cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                
                BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                
                if (isWeekEnd) {
                    
                    cell1.lblday.textColor = [UIColor redColor];
                    cell1.lblDate.textColor = [UIColor redColor];
                    cell1.lblMonth.textColor = [UIColor redColor];
                    
                    cell1.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
                    
                    cell1.alpha = 1.0;
                    
                }
                else
                {
                    cell1.lblday.textColor = [UIColor whiteColor];
                    cell1.lblDate.textColor = [UIColor whiteColor];
                    cell1.lblMonth.textColor = [UIColor whiteColor];
                    
                    //                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                    
                    cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
                    
                    
                    cell1.alpha = 1.0;
                }
                
                [df setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *fDate = [df dateFromString:[NSString stringWithFormat:@"%@",fdate]];
                
                
                NSComparisonResult compare1 = [nextday compare:fDate];
                
                NSDate *sDate = [df dateFromString:[NSString stringWithFormat:@"%@",sdate]];
                
                NSComparisonResult compare2 = [nextday compare:sDate];
                
                if (fDate!=nil) {
                    
                    if (compare1==NSOrderedSame) {
                        
                        [cell1.btnDate  setSelected:YES];
                        
                        cell1.lblday.textColor = [UIColor whiteColor];
                        cell1.lblDate.textColor = [UIColor whiteColor];
                        cell1.lblMonth.textColor = [UIColor whiteColor];
                        
                        //                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                        
                        
                        cell1.alpha = 1.0;
                    }
                    
                    if (sDate!=nil) {
                        
                        if (compare2==NSOrderedSame) {
                            
                            [cell1.btnDate  setSelected:YES];
                            
                            cell1.lblday.textColor = [UIColor whiteColor];
                            cell1.lblDate.textColor = [UIColor whiteColor];
                            cell1.lblMonth.textColor = [UIColor whiteColor];
                            
                            //                            cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                            cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                            
                            
                            cell1.alpha = 1.0;
                        }
                        
                    }
                    
                } else if (sDate!=nil) {
                    
                    if (compare2==NSOrderedSame) {
                        
                        [cell1.btnDate  setSelected:YES];
                        
                        cell1.lblday.textColor = [UIColor whiteColor];
                        cell1.lblDate.textColor = [UIColor whiteColor];
                        cell1.lblMonth.textColor = [UIColor whiteColor];
                        
                        //                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                        
                        
                        cell1.alpha = 1.0;
                    }
                    
                    if (fDate!=nil) {
                        
                        if (compare1==NSOrderedSame) {
                            
                            [cell1.btnDate  setSelected:YES];
                            
                            cell1.lblday.textColor = [UIColor whiteColor];
                            cell1.lblDate.textColor = [UIColor whiteColor];
                            cell1.lblMonth.textColor = [UIColor whiteColor];
                            
                            //                            cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                            
                            cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                            
                            cell1.alpha = 1.0;
                        }
                    }
                }
                
                if (indexPath.row==7) {
                    
                    //nextday = [NSDate date];
                    
                    cell1.lblday.text = [NSString stringWithFormat:@""];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    cell1.lblDate.text = [NSString stringWithFormat:@"More"];
                    
                    cell1.lblMonth.text = [NSString stringWithFormat:@""];
                    
                    cell1.lblDate.textColor = [UIColor whiteColor];
                    
                    //                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                    cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                    
                    
                    cell1.alpha = 1.0;
                }
                
            } else {
                
                if ((indexPath.item==0) || (indexPath.item==1)) {
                    
                    [cell1.btnDate  setSelected:YES];
                    
                    if (indexPath.item==0) {
                        
                        nextday = [NSDate date];
                        
                        seletedTag1 = (int)indexPath.row;
                        
                    } else {
                        
                        nextday = [NSDate date];
                        nextday = [NSDate dateWithTimeInterval:((indexPath.item)*(24*60*60)) sinceDate:nextday];
                        
                        seletedTag2 = (int)indexPath.row;
                    }
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setDateFormat:@"EEE"];
                    
                    day = [df stringFromDate:nextday];
                    
                    cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                    
                    [df setDateFormat:@"d"];
                    
                    date = [df stringFromDate:nextday];
                    
                    cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                    
                    [df setDateFormat:@"MMM"];
                    
                    month = [df stringFromDate:nextday];
                    
                    cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                    
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                    
                    if (isWeekEnd) {
                        
                        cell1.lblday.textColor = [UIColor redColor];
                        cell1.lblDate.textColor = [UIColor redColor];
                        cell1.lblMonth.textColor = [UIColor redColor];
                        
                        cell1.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
                        
                        cell1.alpha = 1.0;
                        
                    } else {
                        
                        cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                        
                        //                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                        
                        
                    }
                    
                }
                else
                {
                    
                    [cell1.btnDate setSelected:NO];
                    
                    cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
                    
                    nextday = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextday];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setDateFormat:@"EEE"];
                    
                    day = [df stringFromDate:nextday];
                    
                    cell1.lblday.text = [NSString stringWithFormat:@"%@",day];
                    
                    [df setDateFormat:@"d"];
                    
                    date = [df stringFromDate:nextday];
                    
                    cell1.lblDate.text = [NSString stringWithFormat:@"%@",date];
                    
                    [df setDateFormat:@"MMM"];
                    
                    month = [df stringFromDate:nextday];
                    
                    cell1.lblMonth.text = [NSString stringWithFormat:@"%@",month];
                    
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:nextday];
                    
                    if (isWeekEnd) {
                        
                        cell1.lblday.textColor = [UIColor redColor];
                        cell1.lblDate.textColor = [UIColor redColor];
                        cell1.lblMonth.textColor = [UIColor redColor];
                        
                        cell1.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
                        
                        cell1.alpha = 1.0;
                        
                    }
                    else
                    {
                        //                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                        
                        
                        cell1.alpha = 1.0;
                    }
                    
                    if (indexPath.item==7) {
                        
                        // nextday = [NSDate date];
                        
                        cell1.lblday.text = [NSString stringWithFormat:@""];
                        
                        cell1.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                        cell1.lblDate.text = [NSString stringWithFormat:@"More"];
                        
                        cell1.lblMonth.text = [NSString stringWithFormat:@""];
                        
                        cell1.lblDate.textColor = [UIColor whiteColor];
                        //
                        //                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#0099ff"] colorWithAlphaComponent:1.0];
                        cell1.contentView.backgroundColor = [[UIColor colorWithHexString:@"#959595"] colorWithAlphaComponent:1.0];
                        
                        
                        cell1.alpha = 1.0;
                    }
                    
                }
            }
            
            return cell1;
        }
        
    }
    else
    {
        static NSString *identifier = @"MeetingTimeCollectionViewCell";
        
        MeetingTimeCollectionViewCell *cell2 = (MeetingTimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        if ([userType isEqualToString:@"Guest"]) {
            
            cell2.tag = indexPath.item;
            cell2.btnTime.tag = indexPath.item;
            cell2.delegate = self;
            
            if ([phone length]>0) {
                
                [self timeSlotSettings:cell2 withIndexPath:indexPath];
                
            } else {
                
                [cell2.btnTime setTitle:[NSString stringWithFormat:@"%@",[hours objectAtIndex:indexPath.item]] forState:UIControlStateNormal];
                
                [cell2.btnTime setSelected:NO];
                [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
                [cell2.btnTime setEnabled:NO];
                
                UIColor *color = [UIColor colorWithHexString:@"#0099ff"];
                cell2.btnTime.layer.shadowColor = [color CGColor];
                cell2.btnTime.layer.shadowRadius = 5.0f;
                cell2.btnTime.layer.shadowOpacity = .9;
                cell2.btnTime.layer.shadowOffset = CGSizeZero;
                cell2.btnTime.layer.masksToBounds = NO;
                
                cell2.btnTime.alpha = 0.4;
            }
            
        } else {
            
            cell2.tag = indexPath.item;
            cell2.btnTime.tag = indexPath.item;
            cell2.delegate = self;
            
            [self timeSlotSettings:cell2 withIndexPath:indexPath];
        }
        
        return cell2;
    }
    
}


-(void)timeSlotSettings:(MeetingTimeCollectionViewCell *)cell2 withIndexPath:(NSIndexPath *)indexPath
{
    [cell2.btnTime setTitle:[NSString stringWithFormat:@"%@",[hours objectAtIndex:indexPath.item]] forState:UIControlStateNormal];
    
    cell2.btnTime.layer.borderColor = [UIColor colorWithHexString:@"#0099ff"].CGColor;
    cell2.btnTime.layer.borderWidth = 1.0;
    
    if (isSelectedTime) {
        
        NSArray *arr1 = [[hours objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"];
        
        NSString *firstTime = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:0]];
        
        NSString *strDateTime;
        
        if ([selectedDate isEqualToString:fdate]) {
            
            strDateTime = [NSString stringWithFormat:@"%@ %@",fdate,firstTime];
            
        } else {
            
            strDateTime = [NSString stringWithFormat:@"%@ %@",sdate,firstTime];
            
        }
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        [dt setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSDate *FirstDate = [dt dateFromString:strDateTime];
        
        NSDate *currentDate = [NSDate date];
        
        NSComparisonResult compare = [currentDate compare:FirstDate];
        
        if((compare==NSOrderedAscending)||(compare==NSOrderedSame))
        {
            if (![arrBooked containsObject:[hours objectAtIndex:indexPath.item]]) {
                
                if ([arrTimes containsObject:[hours objectAtIndex:indexPath.item]]) {
                    
                    [cell2.btnTime setSelected:YES];
                    [cell2.btnTime setEnabled:YES];
                    [cell2.btnTime setBackgroundColor:[UIColor colorWithHexString:@"#0099ff"]];
                    [cell2.btnTime setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    
                    UIColor *color = [UIColor colorWithHexString:@"#0099ff"];
                    cell2.btnTime.layer.shadowColor = [color CGColor];
                    cell2.btnTime.layer.shadowRadius = 5.0f;
                    cell2.btnTime.layer.shadowOpacity = .9;
                    cell2.btnTime.layer.shadowOffset = CGSizeZero;
                    cell2.btnTime.layer.masksToBounds = NO;
                    
                    // [arrTimes addObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                    
                }
                else
                {
                    [cell2.btnTime setSelected:NO];
                    [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
                    [cell2.btnTime setEnabled:YES];
                    
                    if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                        
                        [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                    }
                }
                
                cell2.btnTime.alpha = 1.0;
                
            } else {
                
                [cell2.btnTime setSelected:NO];
                [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
                [cell2.btnTime setEnabled:NO];
                
                cell2.btnTime.alpha = 0.4;
                
                if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                    
                    [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                }
            }
            
        }
        else if (compare==NSOrderedDescending)
        {
            [cell2.btnTime setSelected:NO];
            [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
            [cell2.btnTime setEnabled:NO];
            
            cell2.btnTime.alpha = 0.4;
            
            if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                
                [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
            }
        }
        
        
    } else {
        
        NSArray *arr1 = [[hours objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"];
        
        NSString *firstTime = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:0]];
        
        NSString *strDateTime;
        
        if ([selectedDate isEqualToString:fdate]) {
            
            strDateTime = [NSString stringWithFormat:@"%@ %@",fdate,firstTime];
            
        } else {
            
            strDateTime = [NSString stringWithFormat:@"%@ %@",sdate,firstTime];
            
        }
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [dt setLocale:locale];
        
        [dt setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        NSDate *FirstDate = [dt dateFromString:strDateTime];
        
        NSDate *currentDate = [NSDate date];
        
        NSComparisonResult compare = [currentDate compare:FirstDate];
        
        if((compare==NSOrderedAscending)||(compare==NSOrderedSame))
        {
            if (![arrBooked containsObject:[hours objectAtIndex:indexPath.item]]) {
                
                if ([arrTimes count]==0) {
                    
                    [cell2.btnTime setSelected:YES];
                    [cell2.btnTime setEnabled:YES];
                    [cell2.btnTime setBackgroundColor:[UIColor colorWithHexString:@"#0099ff"]];
                    [cell2.btnTime setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    
                    UIColor *color = [UIColor colorWithHexString:@"#0099ff"];
                    cell2.btnTime.layer.shadowColor = [color CGColor];
                    cell2.btnTime.layer.shadowRadius = 5.0f;
                    cell2.btnTime.layer.shadowOpacity = .9;
                    cell2.btnTime.layer.shadowOffset = CGSizeZero;
                    cell2.btnTime.layer.masksToBounds = NO;
                    
                    [arrTimes addObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                    
                }
                else
                {
                    [cell2.btnTime setSelected:NO];
                    [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
                    [cell2.btnTime setTitleColor:[UIColor colorWithRed:0/255 green:173/255 blue:243/255 alpha:1.0] forState:UIControlStateSelected];
                    [cell2.btnTime setEnabled:YES];
                    
                    if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                        
                        [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                    }
                }
                
                cell2.btnTime.alpha = 1.0;
                
            } else {
                
                [cell2.btnTime setSelected:NO];
                [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
                [cell2.btnTime setTitleColor:[UIColor colorWithRed:0/255 green:173/255 blue:243/255 alpha:1.0] forState:UIControlStateSelected];
                [cell2.btnTime setEnabled:NO];
                
                cell2.btnTime.alpha = 0.4;
                
                if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                    
                    [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
                }
            }
            
        }
        else if (compare==NSOrderedDescending)
        {
            [cell2.btnTime setSelected:NO];
            [cell2.btnTime setBackgroundColor:[UIColor whiteColor]];
            [cell2.btnTime setTitleColor:[UIColor colorWithRed:0/255 green:173/255 blue:243/255 alpha:1.0] forState:UIControlStateSelected];
            [cell2.btnTime setEnabled:NO];
            
            cell2.btnTime.alpha = 0.4;
            
            if ([arrTimes containsObject:[hours objectAtIndex:(int)cell2.btnTime.tag]]) {
                
                [arrTimes removeObject:[hours objectAtIndex:(int)cell2.btnTime.tag]];
            }
        }
        
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collectionView_Dates){
        
        MeetingDateCollectionViewCell *cell1 = (MeetingDateCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell1.delegate = self;
        
    }else{
        
        MeetingTimeCollectionViewCell *cell2 = (MeetingTimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell2.delegate = self;
    }
}


#pragma Mark - MeetingTimeCollectionViewCellDelegate

- (void)cellTap:(id)sender {
    
    MeetingTimeCollectionViewCell* cell = (MeetingTimeCollectionViewCell *)sender;
    
    UIButton* btn = cell.btnTime;
    
    isSelectedTime = YES;
    
    if ([btn isSelected]) {
        
        NSLog(@"btn.tag: %d",(int)btn.tag);
        NSLog(@"([hours count]-1): %d",(int)([hours count]-1));
        
        if ([arrTimes count]==0) {
            
            btnTag = (int)btn.tag;
            
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                          message:@"You have to select atleast one date to schedule an meeting."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action)
                                       {
                                           
                                           NSLog(@"btn.tag: %d",(int)btn.tag);
                                           NSLog(@"btnTag: %d",self->btnTag);
                                           
                                           [self.collectionView_Times reloadData];
                                           
                                       }];
            
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            [btn setSelected:NO];
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            [arrTimes removeObject:[hours objectAtIndex:(int)btn.tag]];
            
            [self deselectAutoDates:btn.tag];
        }
        
    } else {
        
        if (![arrTimes containsObject:[hours objectAtIndex:(int)btn.tag]]) {
            
            [btn setSelected:YES];
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            UIColor *color = [UIColor whiteColor];
            btn.layer.shadowColor = [color CGColor];
            btn.layer.shadowRadius = 5.0f;
            btn.layer.shadowOpacity = .7;
            btn.layer.shadowOffset = CGSizeZero;
            btn.layer.masksToBounds = NO;
            
            [arrTimes addObject:[hours objectAtIndex:(int)btn.tag]];
            
            [self selectAutoDates];
        }
        
    }
    
    [self.collectionView_Times reloadData];
}


#pragma Mark - MeetingDateCollectionViewCellDelegate

- (void)dateCellTap1:(id)sender {
    
    MeetingDateCollectionViewCell* cell = (MeetingDateCollectionViewCell *)sender;
    
    UIButton* btn = cell.btnDate;
    
    if (btn.tag<7) {
        
        [btn setSelected:YES];
        
        seletedTag = (int)btn.tag;
        
        isSelectedDate = YES;
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        [dt setDateFormat:@"yyyy"];
        
        NSString *yearString = [dt stringFromDate:[NSDate date]];
        
        arrTimes = [[NSMutableArray alloc] init];
        
        NSString *strDate = [NSString stringWithFormat:@"%@ %@, %@",cell.lblDate.text,cell.lblMonth.text,yearString];
        
        [dt setDateFormat:@"d MMM, yyyy"];
        
        NSDate *currentdate = [dt dateFromString:strDate];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        NSString *currentDateStr = [dt stringFromDate:currentdate];
        
        fdate = currentDateStr;
        
        selectedDate = currentDateStr;
        
        NSDate *CDate = [dt dateFromString:selectedDate];
        
        NSDate *currentDate = [dt dateFromString:[dt stringFromDate:[NSDate date]]];
        
        NSDate *currentWeekDate = [NSDate dateWithTimeInterval:(24*60*60*7) sinceDate:currentDate];
        
        //[arrTimes addObject:[hours objectAtIndex:0]];
        
        [UIView animateWithDuration:0 animations:^{
            
            NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
            
            NSString *userType = [userDict objectForKey:@"usertype"];
            
            NSComparisonResult compare2 = [currentWeekDate compare:CDate];
            
            if ((compare2==NSOrderedDescending)||(compare2==NSOrderedSame)){
                
                self->isCurrentWeek = YES;
                
                if ([userType isEqualToString:@"Guest"]) {
                    
                    if ([self->phone length]>0) {
                        
                        [self getEmployeeavailTimeforDate:self->selectedDate];
                    }
                    
                } else {
                    
                    [self getUseravailTimeforDate:currentDateStr];
                }
            }
            else
            {
                self->isCurrentWeek = NO;
                
                if ([userType isEqualToString:@"Guest"]) {
                    
                    if ([self->phone length]>0) {
                        
                        [self getEmployeeavailTimeforDate:self->selectedDate];
                    }
                    
                } else {
                    
                    [self getUseravailTimeforDate:currentDateStr];
                }
            }
            
        } completion:^(BOOL finished) {
            //Do something after that...
            
            [self.collectionView_Dates reloadData];
            
        }];
        
    }
    else
    {
        self.VwPicker = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 344), SCREENWIDTH, 344)];
        
        self.VwPicker.backgroundColor = [UIColor whiteColor];
        
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        
        [toolBar setBarTintColor:[UIColor grayColor]];
        
        UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onDatePickerCancel:)];
        
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDatePickerValueChanged:)];
        
        [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
        
        [self.VwPicker addSubview:toolBar];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 300)];
        
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.hidden = NO;
        self.datePicker.date = [NSDate date];
        
        [self.VwPicker addSubview:self.datePicker];
        
        [self.view.window addSubview:self.VwPicker];
        
        //        dateSel = [WWCalendarTimeSelector instantiate];
        //        dateSel.delegate = self;
        //        //dateSel.optionStyles.showTime = NO;
        //        // dateSel.optionStyles.sh
        //
        //        [dateSel.optionStyles showTime:NO];
        //        dateSel.optionTopPanelBackgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
        //        dateSel.optionMainPanelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        //        dateSel.optionBottomPanelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        //
        //        dateSel.optionSelectorPanelBackgroundColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0];
        //        dateSel.optionButtonTitleCancel = @"CANCEL";
        //        dateSel.optionButtonTitleDone = @"OK";
        //        dateSel.optionButtonFontColorDone = [UIColor blackColor];
        //        dateSel.optionButtonFontColorCancel = [UIColor blackColor];
        //        dateSel.optionCalendarBackgroundColorTodayHighlight = [UIColor colorWithRed:0/255.0 green:138/255.0 blue:210/255.0 alpha:1.0];
        //        dateSel.optionCalendarBackgroundColorFutureDatesHighlight = [UIColor colorWithRed:0/255.0 green:138/255.0 blue:210/255.0 alpha:1.0];
        //
        //        // dateSel. = [UIColor colorWithRed:0/255.0 green:138/255.0 blue:210/255.0 alpha:1.0];
        //
        //        [self.collectionView_Dates setContentOffset:CGPointZero animated:YES];
        //
        //        [self.tabBarController presentViewController:dateSel animated:YES completion:nil];
        
    }
    
}


- (void)dateCellTap2:(id)sender {
    
    MeetingDateCollectionViewCell *cell = (MeetingDateCollectionViewCell *)sender;
    
    UIButton *btn = cell.btnDate;
    
    [self chooseDatewithTag:(int)btn.tag onCell:cell];
    
    // NSLog(@"seletedTag1: %d",seletedTag1);
    
    // NSLog(@"seletedTag2: %d",seletedTag2);
}

-(void)chooseDatewithTag:(int)Tag onCell:(MeetingDateCollectionViewCell *)cell
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Choose Date"];
    
    [hogan addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(0, 11)];
    
    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 11)];
    
    [actionSheet setValue:hogan forKey:@"attributedMessage"];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"First Date" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (Tag<7) {
            
            NSDateFormatter *dt = [[NSDateFormatter alloc] init];
            
            [dt setDateFormat:@"yyyy"];
            
            NSString *yearString = [dt stringFromDate:[NSDate date]];
            
            NSString *strDate = [NSString stringWithFormat:@"%@ %@, %@",cell.lblDate.text,cell.lblMonth.text,yearString];
            
            [dt setDateFormat:@"d MMM, yyyy"];
            
            NSDate *cdate = [dt dateFromString:strDate];
            
            [dt setDateFormat:@"yyyy-MM-dd"];
            
            NSString *currentDateStr = [dt stringFromDate:cdate];
            
            self->fdate = currentDateStr;
            
            [self selectFlexibleDates:cell];
            
        }
        else
        {
            self->firstDate = YES;
            self->secondDate = NO;
            
            self.VwPicker.hidden = NO;
            
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
    }]];
    
    
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    
    [dt setDateFormat:@"yyyy"];
    
    NSString *yearString = [dt stringFromDate:[NSDate date]];
    
    NSString *strDate = [NSString stringWithFormat:@"%@ %@, %@",cell.lblDate.text,cell.lblMonth.text,yearString];
    
    [dt setDateFormat:@"d MMM, yyyy"];
    
    NSDate *cdate = [dt dateFromString:strDate];
    
    [dt setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dt stringFromDate:cdate];
    
    NSDate *currentDate = [dt dateFromString:fdate];
    
    NSDate *fromDate = [dt dateFromString:currentDateStr];
    
    NSComparisonResult compare = [currentDate compare:fromDate];
    
    if ((compare!=NSOrderedSame)||(cell.tag==7)) {
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Second Date" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if (Tag<7) {
                
                NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                
                [dt setDateFormat:@"yyyy-MM-dd"];
                
                NSString *fulldate1 = [NSString stringWithFormat:@"%@",self->fdate];
                
                NSDate* date1 = [dt dateFromString:fulldate1];
                
                NSString *fulldate2 = [NSString stringWithFormat:@"%@",currentDateStr];
                
                NSDate* date2 = [dt dateFromString:fulldate2];
                
                NSComparisonResult compare = [date1 compare:date2];
                
                if ((compare==NSOrderedDescending)||(compare==NSOrderedSame)) {
                    
                    UIAlertController * alert=[UIAlertController
                                               
                                               alertControllerWithTitle:@"Error" message:@"Second Date shouldn't be less or same with First Date."preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                }];
                    
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    self->sdate = currentDateStr;
                    
                    [self selectFlexibleDates:cell];
                }
                
            }
            else
            {
                self->firstDate = NO;
                self->secondDate = YES;
                
                self.VwPicker.hidden = NO;
                
                [self.datePicker setDatePickerMode:UIDatePickerModeDate];
                [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                
            }
            
        }]];
    }
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


-(void)selectFlexibleDates:(MeetingDateCollectionViewCell *)cell
{
    UIButton* btn = cell.btnDate;
    
    [btn setSelected:YES];
    
    fromTime = @"";
    
    isSelectedDate = YES;
    isSelectedTime = NO;
    
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    
    [dt setDateFormat:@"yyyy"];
    
    NSString *yearString = [dt stringFromDate:[NSDate date]];
    
    arrTimes = [[NSMutableArray alloc] init];
    
    NSString *strDate = [NSString stringWithFormat:@"%@ %@, %@",cell.lblDate.text,cell.lblMonth.text,yearString];
    
    [dt setDateFormat:@"d MMM, yyyy"];
    
    NSDate *cdate = [dt dateFromString:strDate];
    
    [dt setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dt stringFromDate:cdate];
    
    if (cell.tag==seletedTag1) {
        
        fdate = currentDateStr;
        
        selectedDate = currentDateStr;
    }
    else
    {
        sdate = currentDateStr;
        
        selectedDate = currentDateStr;
    }
    
    NSDate *CDate = [dt dateFromString:selectedDate];
    
    NSDate *currentDate = [dt dateFromString:[dt stringFromDate:[NSDate date]]];
    
    NSDate *currentWeekDate = [NSDate dateWithTimeInterval:(24*60*60*7) sinceDate:currentDate];
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        NSComparisonResult compare2 = [currentWeekDate compare:CDate];
        
        if ((compare2==NSOrderedDescending)||(compare2==NSOrderedSame)){
            
            self->isCurrentWeek = YES;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:currentDateStr];
            }
        }
        else
        {
            self->isCurrentWeek = NO;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:currentDateStr];
            }
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
        [self.collectionView_Dates reloadData];
        
        //[self.collectionViewTimes reloadData];
        
    }];
    
}

-(void)deselectAutoDates:(NSInteger)btnTag
{
    if ([arrTimes count]>1) {
        
        arrIndex = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[arrTimes count]; i++) {
            
            [arrIndex addObject:[NSString stringWithFormat:@"%d",(int)[hours indexOfObject:[arrTimes objectAtIndex:i]]]];
            
            // NSLog(@"works");
            
        }
        
        NSArray *copyArr = [arrIndex sortedArrayUsingSelector:@selector(compare:)];
        
        int minInt = (int)btnTag;
        int maxInt = (int)[[copyArr lastObject] integerValue];
        
        arrTimes = [[NSMutableArray alloc] init];
        
        for (int j=maxInt; j>minInt; j--) {
            
            [arrTimes addObject:[hours objectAtIndex:j]];
        }
        
    }
}


-(void)selectAutoDates
{
    if ([arrTimes count]>1) {
        
        arrIndex = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[arrTimes count]; i++) {
            
            [arrIndex addObject:[NSString stringWithFormat:@"%d",(int)[hours indexOfObject:[arrTimes objectAtIndex:i]]]];
            
            // NSLog(@"works");
            
        }
        
        NSArray *copyArr = [arrIndex sortedArrayUsingSelector:@selector(compare:)];
        
        int minInt = (int)[copyArr[0] integerValue];
        int maxInt = (int)[[copyArr lastObject] integerValue];
        
        arrTimes = [[NSMutableArray alloc] init];
        
        for (int j=maxInt; j>(minInt-1); j--) {
            
            [arrTimes addObject:[hours objectAtIndex:j]];
        }
        
    }
    
}


#pragma mark - Button actions

- (IBAction)btnConfirmDidTap:(id)sender{
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    NSString *userType = [userDict objectForKey:@"usertype"];
    
    [self.btn_Confirm setEnabled:NO];
    
    if (![userType isEqualToString:@"Guest"])
    {
        [self selectRoom:userType];
    }
    else
    {
        if (self.isFexible) {
            
            [self bookFlexibleMeeting:userType];
            
        } else {
            
            [self bookFixedMeeting:userType];
        }
    }
    
}


- (IBAction)btnConfirmedOkDidTap:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self->_view_Confirmation.frame = CGRectMake(self->_view_Confirmation.frame.origin.x, self.tabBarController.view.frame.size.height+self->_view_Confirmation.frame.size.height, self->_view_Confirmation.frame.size.width, self->_view_Confirmation.frame.size.height);
                         
                         
                         self->_view_Confirmation.hidden = YES;
                         
                         self.VwPicker.hidden = YES;
                         
                         self.addMeetingBackView.hidden = YES;
                         
                         NSDictionary* userInfo = @{@"indexClickedOnDrawer": @(1)};
                         
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"ClickedDrawerOption"
                          object:self userInfo:userInfo];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}


- (IBAction)onDatePickerValueChanged:(UIBarButtonItem *)sender {
    
    NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
    
    [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateForAPI = [dateFormatterForAPI stringFromDate:self.datePicker.date];
    
    NSDate *CDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:self.datePicker.date]];
    
    NSDate *currentDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:[NSDate date]]];
    
    NSComparisonResult compare = [currentDate compare:CDate];
    
    NSDate *currentWeekDate = [NSDate dateWithTimeInterval:(24*60*60*7) sinceDate:currentDate];
    
    if ((compare==NSOrderedAscending)||(compare==NSOrderedSame)) {
        
        fDateSel = dateForAPI;
        fdate = dateForAPI;
        sdate = @"";
        
        isSelectedDate = YES;
        
        initialDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:self.datePicker.date]];
        
        selectedDate = fdate;
        
    } else {
        
        [self showAlert];
        
        initialDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:[NSDate date]]];
        
        fdate = [dateFormatterForAPI stringFromDate:initialDate];
        sdate = @"";
    }
    
    // nextday = initialDate;
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        NSComparisonResult compare2 = [currentWeekDate compare:CDate];
        
        if ((compare2==NSOrderedDescending)||(compare2==NSOrderedSame)){
            
            self->isCurrentWeek = YES;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:dateForAPI];
            }
        }
        else
        {
            self->isCurrentWeek = NO;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:dateForAPI];
            }
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
        [self.VwPicker removeFromSuperview];
        
        [self.collectionView_Dates reloadData];
        
        [self.collectionView_Dates setContentOffset:CGPointZero animated:YES];
        
    }];
    
}


- (IBAction)onDatePickerCancel:(UIBarButtonItem *)sender {
    
    [self.VwPicker removeFromSuperview];
    
}

#pragma mark - Contact List

- (IBAction)btnAddContactDidTap:(id)sender {
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0")) {
        
        //        contactVC = [[ContactsTableController alloc] init];
        //
        //        contactVC.delegate = self;
        //
        //        CATransition* transition = [CATransition animation];
        //        transition.duration = 0.3;
        //        transition.type = kCATransitionMoveIn;
        //        transition.subtype = kCATransitionFromTop;
        //
        //        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        //
        //        [self presentViewController:contactVC animated:NO completion:nil];
        
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //        _fmVC = [storyboard instantiateViewControllerWithIdentifier:@"FragmentViewController"];
        
        
        if (_fmVC) {
            
            _fmVC.amVC = self;
            [_fmVC didSelectedContact];
            
        }
        
    }
    else
    {
        
        VeeContactPickerViewController *veeContactPickerViewController = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
        
        veeContactPickerViewController.contactPickerDelegate = self;
        
        [self presentViewController:veeContactPickerViewController animated:YES completion:nil];
        
    }
    
}

- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    //Do whatever you want with the selected veeContact!
    
    _lbl_DepartmentName.text = [veeContact displayName];
    
    NSString *phoneStr = [[veeContact phoneNumbers]objectAtIndex:0];
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        if ([userType isEqualToString:@"Guest"]) {
            
            [self getEmployeeavailTimeforDate:self->fDateSel];
            
        } else {
            
            [self getUseravailTimeforDate:self->fDateSel];
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
    }];
    
}


- (void)didFailToAccessAddressBook
{
    //Show an error?
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please allow Phonebook access."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - WWCalendarSelector

- (void)WWCalendarTimeSelectorDone:(WWCalendarTimeSelector * _Nonnull)selector date:(NSDate * _Nonnull)date{
    
    NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
    
    [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateForAPI = [dateFormatterForAPI stringFromDate:date];
    
    NSDate *CDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:date]];
    
    NSDate *currentDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:[NSDate date]]];
    
    NSComparisonResult compare = [currentDate compare:CDate];
    
    NSDate *currentWeekDate = [NSDate dateWithTimeInterval:(24*60*60*7) sinceDate:currentDate];
    
    if ((compare==NSOrderedAscending)||(compare==NSOrderedSame)) {
        
        fDateSel = dateForAPI;
        fdate = dateForAPI;
        sdate = @"";
        
        isSelectedDate = YES;
        
        initialDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:date]];
        
        selectedDate = fdate;
        
    } else {
        
        [self showAlert];
        
        initialDate = [dateFormatterForAPI dateFromString:[dateFormatterForAPI stringFromDate:[NSDate date]]];
        
        fdate = [dateFormatterForAPI stringFromDate:initialDate];
        sdate = @"";
    }
    
    
    // nextday = initialDate;
    
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        NSComparisonResult compare2 = [currentWeekDate compare:CDate];
        
        if ((compare2==NSOrderedDescending)||(compare2==NSOrderedSame)){
            
            self->isCurrentWeek = YES;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:dateForAPI];
            }
        }
        else
        {
            self->isCurrentWeek = NO;
            
            if ([userType isEqualToString:@"Guest"]) {
                
                if ([self->phone length]>0) {
                    
                    [self getEmployeeavailTimeforDate:self->selectedDate];
                }
                
            } else {
                
                [self getUseravailTimeforDate:dateForAPI];
            }
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
        [self.collectionView_Dates reloadData];
        
        [self.collectionView_Dates setContentOffset:CGPointZero animated:YES];
        
    }];
    
}


-(void)showAlert
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"@Hipla"
                                 message:@"You cannot select previous date to schedule a meeting."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                    
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)checkAvailability:(NSArray *)arr
{
    for (NSDictionary *dict in arr) {
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *currentDate = [dt dateFromString:selectedDate];
        
        NSDate *fromDate = [dt dateFromString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]]];
        
        NSComparisonResult compare = [currentDate compare:fromDate];
        
        if (compare==NSOrderedSame) {
            
            NSString *statusStr = [dict objectForKey:@"status"];
            
            if (([statusStr isEqual:[NSNull null]] )|| (statusStr==nil) || ([statusStr isEqualToString:@"<null>"]) || ([statusStr isEqualToString:@"(null)"]) || (statusStr.length==0 )|| ([statusStr isEqualToString:@""])|| (statusStr==NULL)||(statusStr == (NSString *)[NSNull null])||[statusStr isKindOfClass:[NSNull class]]|| (statusStr == (id)[NSNull null])) {
                
                statusStr = @"";
            }
            
            if ([statusStr isEqualToString:@"Y"])
            {
                NSString *givenFromTime = [dict objectForKey:@"from"];
                
                NSString *givenToTime = [dict objectForKey:@"to"];
                
                BOOL dontAddForm = false;
                BOOL dontAddTo = false;
                
                for (int i=0; i<[hours count]; i++) {
                    
                    NSArray *arr1 = [[hours objectAtIndex:i] componentsSeparatedByString:@"-"];
                    
                    NSString *firstTime = [arr1 objectAtIndex:0];
                    
                    if (![firstTime isEqualToString:givenFromTime]) {
                        
                        if (dontAddForm==false) {
                            
                            if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                
                                [arrBooked addObject:[hours objectAtIndex:i]];
                            }
                        }
                    }
                    else if ([firstTime isEqualToString:givenFromTime])
                    {
                        dontAddForm = true;
                    }
                    
                    if (dontAddForm) {
                        
                        if ([firstTime isEqualToString:givenToTime]) {
                            
                            dontAddTo = true;
                            
                            if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                
                                [arrBooked addObject:[hours objectAtIndex:i]];
                            }
                            
                        }
                    }
                    
                    if (dontAddTo) {
                        
                        if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                            
                            [arrBooked addObject:[hours objectAtIndex:i]];
                        }
                    }
                }
                
                
                NSArray *arrMettings = [dict objectForKey:@"meetings"];
                
                NSMutableArray *FromArr = [[NSMutableArray alloc] init];
                NSMutableArray *ToArr = [[NSMutableArray alloc] init];
                
                
                if (([arrMettings isEqual:[NSNull null]] )||(arrMettings==nil)||(arrMettings==NULL)||(arrMettings == (NSArray *)[NSNull null])||[arrMettings isKindOfClass:[NSNull class]]|| (arrMettings == (id)[NSNull null])) {
                    
                    arrMettings = @[];
                    
                }
                
                if ([arrMettings count]>0) {
                    
                    for (NSDictionary *dict1 in arrMettings) {
                        
                        BOOL dontAddFormArr = false;
                        BOOL dontAddToArr = false;
                        
                        if ([[dict1 allKeys] containsObject:@"from"]) {
                            
                            [FromArr addObject:[dict1 objectForKey:@"from"]];
                            
                        }
                        
                        if ([[dict1 allKeys] containsObject:@"to"]){
                            
                            [ToArr addObject:[dict1 objectForKey:@"to"]];
                        }
                        
                        if ([FromArr count]>0) {
                            
                            for (int i=0; i<[hours count]; i++) {
                                
                                NSArray *arr1 = [[hours objectAtIndex:i] componentsSeparatedByString:@"-"];
                                
                                if (dontAddFormArr) {
                                    
                                    if ([ToArr containsObject:[arr1 objectAtIndex:1]]) {
                                        
                                        dontAddToArr = true;
                                        
                                        if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                            
                                            [arrBooked addObject:[hours objectAtIndex:i]];
                                        }
                                    }
                                    else
                                    {
                                        if (dontAddToArr==0) {
                                            
                                            if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                                
                                                [arrBooked addObject:[hours objectAtIndex:i]];
                                            }
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    if ([FromArr containsObject:[arr1 objectAtIndex:0]]) {
                                        
                                        dontAddFormArr = true;
                                        
                                        if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                            
                                            [arrBooked addObject:[hours objectAtIndex:i]];
                                        }
                                        
                                        if ([ToArr containsObject:[arr1 objectAtIndex:1]]) {
                                            
                                            dontAddToArr = true;
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
            else if ([statusStr isEqualToString:@"N"])
            {
                for (int i=0; i<[hours count]; i++) {
                    
                    if (![arrBooked containsObject:[hours objectAtIndex:i]])
                    {
                        [arrBooked addObject:[hours objectAtIndex:i]];
                    }
                }
                
            }
            else
            {
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                
                BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                
                if (isWeekEnd) {
                    
                    for (int i=0; i<[hours count]; i++) {
                        
                        if (![arrBooked containsObject:[hours objectAtIndex:i]])
                        {
                            [arrBooked addObject:[hours objectAtIndex:i]];
                        }
                    }
                }
                else
                {
                    NSArray *arrMettings = [dict objectForKey:@"meetings"];
                    
                    NSMutableArray *FromArr = [[NSMutableArray alloc] init];
                    NSMutableArray *ToArr = [[NSMutableArray alloc] init];
                    
                    if (([arrMettings isEqual:[NSNull null]] )||(arrMettings==nil)||(arrMettings==NULL)||(arrMettings == (NSArray *)[NSNull null])||[arrMettings isKindOfClass:[NSNull class]]|| (arrMettings == (id)[NSNull null])) {
                        
                        arrMettings = @[];
                        
                    }
                    
                    
                    if ([arrMettings count]>0) {
                        
                        for (NSDictionary *dict1 in arrMettings) {
                            
                            BOOL dontAddFormArr = false;
                            BOOL dontAddToArr = false;
                            
                            if ([[dict1 allKeys] containsObject:@"from"]) {
                                
                                [FromArr addObject:[dict1 objectForKey:@"from"]];
                                
                            }
                            
                            if ([[dict1 allKeys] containsObject:@"to"]){
                                
                                [ToArr addObject:[dict1 objectForKey:@"to"]];
                            }
                            
                            if ([FromArr count]>0) {
                                
                                for (int i=0; i<[hours count]; i++) {
                                    
                                    NSArray *arr1 = [[hours objectAtIndex:i] componentsSeparatedByString:@"-"];
                                    
                                    if (dontAddFormArr) {
                                        
                                        if ([ToArr containsObject:[arr1 objectAtIndex:1]]) {
                                            
                                            dontAddToArr = true;
                                            
                                            if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                                
                                                [arrBooked addObject:[hours objectAtIndex:i]];
                                            }
                                        }
                                        else
                                        {
                                            if (dontAddToArr==0) {
                                                
                                                if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                                    
                                                    [arrBooked addObject:[hours objectAtIndex:i]];
                                                }
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        if ([FromArr containsObject:[arr1 objectAtIndex:0]]) {
                                            
                                            dontAddFormArr = true;
                                            
                                            if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                                
                                                [arrBooked addObject:[hours objectAtIndex:i]];
                                            }
                                            
                                            if ([ToArr containsObject:[arr1 objectAtIndex:1]]) {
                                                
                                                dontAddToArr = true;
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
        [self.collectionView_Times reloadData];
    }
    
}


-(void)checkAvailableTime:(NSArray *)arr
{
    for (NSDictionary *dict in arr) {
        
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        
        [dt setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *currentDate = [dt dateFromString:selectedDate];
        
        NSDate *fromDate = [dt dateFromString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]]];
        
        NSComparisonResult compare = [currentDate compare:fromDate];
        
        if (compare==NSOrderedSame) {
            
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateFormatter *dt = [[NSDateFormatter alloc] init];
            
            [dt setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *currentDate = [dt dateFromString:selectedDate];
            
            BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
            
            if (isWeekEnd) {
                
                for (int i=0; i<[hours count]; i++) {
                    
                    if (![arrBooked containsObject:[hours objectAtIndex:i]])
                    {
                        [arrBooked addObject:[hours objectAtIndex:i]];
                    }
                }
            }
            else
            {
                NSArray *arrMettings = [dict objectForKey:@"meetings"];
                
                NSMutableArray *FromArr = [[NSMutableArray alloc] init];
                NSMutableArray *ToArr = [[NSMutableArray alloc] init];
                
                if (([arrMettings isEqual:[NSNull null]] )||(arrMettings==nil)||(arrMettings==NULL)||(arrMettings == (NSArray *)[NSNull null])||[arrMettings isKindOfClass:[NSNull class]]|| (arrMettings == (id)[NSNull null])) {
                    
                    arrMettings = @[];
                    
                }
                
                if ([arrMettings count]>0) {
                    
                    for (NSDictionary *dict1 in arrMettings) {
                        
                        if ([[dict1 allKeys] containsObject:@"from"]) {
                            
                            [FromArr addObject:[dict1 objectForKey:@"from"]];
                            
                        }
                        
                        if ([[dict1 allKeys] containsObject:@"to"]){
                            
                            [ToArr addObject:[dict1 objectForKey:@"to"]];
                        }
                    }
                    
                    if ([FromArr count]>0) {
                        
                        for (int i=0; i<[hours count]; i++) {
                            
                            NSArray *arr1 = [[hours objectAtIndex:i] componentsSeparatedByString:@"-"];
                            
                            if ([FromArr containsObject:[arr1 objectAtIndex:0]]) {
                                
                                if (![arrBooked containsObject:[hours objectAtIndex:i]]) {
                                    
                                    [arrBooked addObject:[hours objectAtIndex:i]];
                                }
                            }
                        }
                        
                        for (int j=(int)[hours count]-1; j>=0; j--) {
                            
                            NSArray *arr1 = [[hours objectAtIndex:j] componentsSeparatedByString:@"-"];
                            
                            if ([ToArr containsObject:[arr1 objectAtIndex:1]]) {
                                
                                if (![arrBooked containsObject:[hours objectAtIndex:j]])
                                {
                                    [arrBooked addObject:[hours objectAtIndex:j]];
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
        [self.collectionView_Times reloadData];
    }
    
}


#pragma mark - Api details

-(void)getUseravailTimeforDate:(NSString *)Date
{
    [SVProgressHUD show];
    
    if ([nameStr length]==0) {
        
        [self.lbl_DepartmentName setText:nameStr];
    }
    
    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
    
    NSDictionary *params = @{@"userid":userId,@"date":Date};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_time_by_dateNuserid.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            if ([[responseDict allKeys] containsObject:@"timing"]) {
                
                self->arrTiming = [responseDict objectForKey:@"timing"];
                
                self->arrBooked = [[NSMutableArray alloc] init];
                
                if (self->isCurrentWeek) {
                    
                    [self checkAvailability:self->arrTiming];
                    
                } else {
                    
                    [self checkAvailableTime:self->arrTiming];
                }
                
            } else {
                
                if (self->isCurrentWeek) {
                    
                    self->arrBooked = [[NSMutableArray alloc] init];
                    self->arrTimes = [[NSMutableArray alloc] init];
                    
                    NSString *msg = [responseDict objectForKey:@"message"];
                    
                    if ([msg isEqualToString:@"Sorry This user doesn't set any availability."])
                    {
                        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                        
                        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                        
                        [dt setDateFormat:@"yyyy-MM-dd"];
                        
                        NSDate *currentDate = [dt dateFromString:Date];
                        
                        BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                        
                        if (isWeekEnd) {
                            
                            for (int i=0; i<[self->hours count]; i++) {
                                
                                if (![self->arrBooked containsObject:[hours objectAtIndex:i]])
                                {
                                    [self->arrBooked addObject:[hours objectAtIndex:i]];
                                }
                            }
                        }
                        
                    } else {
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                    }
                    
                    [self.collectionView_Times reloadData];
                    
                }
                else
                {
                    self->arrBooked = [[NSMutableArray alloc] init];
                    self->arrTimes = [[NSMutableArray alloc] init];
                    
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                    
                    [dt setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *currentDate = [dt dateFromString:Date];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                    
                    if (isWeekEnd) {
                        
                        for (int i=0; i<[self->hours count]; i++) {
                            
                            if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                            {
                                [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                            }
                        }
                    }
                    
                    [self.collectionView_Times reloadData];
                    
                }
                
            }
            
            
        }else{
            
            if (self->isCurrentWeek) {
                
                self->arrBooked = [[NSMutableArray alloc] init];
                self->arrTimes = [[NSMutableArray alloc] init];
                
                NSString *msg = [responseDict objectForKey:@"message"];
                
                if ([msg isEqualToString:@"Sorry This user doesn't set any availability."])
                {
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                    
                    [dt setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *currentDate = [dt dateFromString:Date];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                    
                    if (isWeekEnd) {
                        
                        for (int i=0; i<[self->hours count]; i++) {
                            
                            if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                            {
                                [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                            }
                        }
                    }
                    
                } else {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                }
                
                [self.collectionView_Times reloadData];
                
                [SVProgressHUD dismiss];
                
            }
            else
            {
                self->arrBooked = [[NSMutableArray alloc] init];
                self->arrTimes = [[NSMutableArray alloc] init];
                
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                
                [dt setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *currentDate = [dt dateFromString:Date];
                
                BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                
                if (isWeekEnd) {
                    
                    for (int i=0; i<[self->hours count]; i++) {
                        
                        if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                        {
                            [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                        }
                    }
                }
                
                [self.collectionView_Times reloadData];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [SVProgressHUD dismiss];
        
    }];
    
}


-(void)getEmployeeavailTimeforDate:(NSString *)Date
{
    [SVProgressHUD show];
    
    if ([phone length]==0) {
        
        phone = @"";
    }
    
    if ([nameStr length]==0) {
        
        [self.lbl_DepartmentName setText:nameStr];
    }
    
    NSDictionary *params = @{@"phone":phone,@"date":Date};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    
    manager.responseSerializer = jsonResponseSerializer;
    
    NSString *host_url = [NSString stringWithFormat:@"%@get_time_by_numberNdate.php",BASE_URL];
    
    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            [SVProgressHUD dismiss];
            
            if ([[responseDict allKeys] containsObject:@"timing"]) {
                
                self->arrTiming = [responseDict objectForKey:@"timing"];
                
                self->arrBooked = [[NSMutableArray alloc] init];
                
                if (self->isCurrentWeek) {
                    
                    [self checkAvailability:self->arrTiming];
                    
                } else {
                    
                    [self checkAvailableTime:self->arrTiming];
                }
                
            } else {
                
                if (self->isCurrentWeek) {
                    
                    self->arrBooked = [[NSMutableArray alloc] init];
                    self->arrTimes = [[NSMutableArray alloc] init];
                    
                    NSString *msg = [responseDict objectForKey:@"message"];
                    
                    if ([msg isEqualToString:@"Sorry This user doesn't set any availability."])
                    {
                        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                        
                        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                        
                        [dt setDateFormat:@"yyyy-MM-dd"];
                        
                        NSDate *currentDate = [dt dateFromString:Date];
                        
                        BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                        
                        if (isWeekEnd) {
                            
                            for (int i=0; i<[self->hours count]; i++) {
                                
                                if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                                {
                                    [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                                }
                            }
                        }
                        
                    } else {
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                    }
                    
                    [self.collectionView_Times reloadData];
                    
                }
                else
                {
                    self->arrBooked = [[NSMutableArray alloc] init];
                    self->arrTimes = [[NSMutableArray alloc] init];
                    
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                    
                    [dt setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *currentDate = [dt dateFromString:Date];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                    
                    if (isWeekEnd) {
                        
                        for (int i=0; i<[self->hours count]; i++) {
                            
                            if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                            {
                                [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                            }
                        }
                    }
                    
                    [self.collectionView_Times reloadData];
                }
                
            }
            
            
        }else{
            
            if (self->isCurrentWeek) {
                
                self->arrBooked = [[NSMutableArray alloc] init];
                self->arrTimes = [[NSMutableArray alloc] init];
                
                NSString *msg = [responseDict objectForKey:@"message"];
                
                if ([msg isEqualToString:@"Sorry This user doesn't set any availability."])
                {
                    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    
                    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                    
                    [dt setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *currentDate = [dt dateFromString:Date];
                    
                    BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                    
                    if (isWeekEnd) {
                        
                        for (int i=0; i<[self->hours count]; i++) {
                            
                            if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                            {
                                [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                            }
                        }
                    }
                    
                } else {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                }
                
                [self.collectionView_Times reloadData];
                
                [SVProgressHUD dismiss];
                
            }
            else
            {
                self->arrBooked = [[NSMutableArray alloc] init];
                self->arrTimes = [[NSMutableArray alloc] init];
                
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                
                [dt setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *currentDate = [dt dateFromString:Date];
                
                BOOL isWeekEnd = [calendar isDateInWeekend:currentDate];
                
                if (isWeekEnd) {
                    
                    for (int i=0; i<[self->hours count]; i++) {
                        
                        if (![self->arrBooked containsObject:[self->hours objectAtIndex:i]])
                        {
                            [self->arrBooked addObject:[self->hours objectAtIndex:i]];
                        }
                    }
                }
                
                [self.collectionView_Times reloadData];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [SVProgressHUD dismiss];
        
    }];
    
}


-(void)selectRoom:(NSString *)type
{
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *host_url = [NSString stringWithFormat:@"%@all_place.php",BASE_URL];
    
    [manager POST:host_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = responseObject;
        
        NSString *success = [responseDict objectForKey:@"status"];
        
        if ([success isEqualToString:@"success"]) {
            
            NSMutableArray *arrDevice_List = [responseDict objectForKey:@"device_list"];
            
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"@Hipla" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self.btn_Confirm setEnabled:YES];
                
                // Cancel button tappped.
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }]];
            
            for (NSDictionary *dict in arrDevice_List) {
                
                NSString *strName = [dict objectForKey:@"name"];
                
                [actionSheet addAction:[UIAlertAction actionWithTitle:strName style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                    [self.btn_Confirm setEnabled:YES];
                    
                    if (![type isEqualToString:@"Guest"])
                    {
                        self->roomId = [dict objectForKey:@"place_unique_id"];
                    }
                    
                    if (self.isFexible) {
                        
                        [self bookFlexibleMeeting:type];
                        
                    } else {
                        
                        [self bookFixedMeeting:type];
                    }
                    
                    // Distructive button tapped.
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                }]];
            }
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        [self.btn_Confirm setEnabled:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];
}


-(void)bookFixedMeeting:(NSString *)type{
    
    if([self notEmptyChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    [self makeTimes];
    
    
    if (([self.lbl_DepartmentName.text isEqualToString:@""])||([self.lbl_DepartmentName.text length]==0))
    {
        [self.btn_Confirm setEnabled:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter contact name."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        
    } else {
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
        
        profimage = [userDict objectForKey:@"profile_image"];
        
        if([profimage isEqualToString:@""]){
            
            [SVProgressHUD dismiss];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:@"You dont have profile pic , please upload your profile pic to create meeting !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            
                                            ProfileDetailViewController *profileVC = [[ProfileDetailViewController alloc]initWithNibName:@"ProfileDetailViewController" bundle:nil];
                                            
                                            profileVC.isFromAddMeeting = @"True";
                                            
                                            [self.view.window.rootViewController presentViewController:profileVC animated:YES completion:nil];
//                                            [self.parentViewController presentViewController:profileVC animated:YES completion:nil];

                                            
//                                            [self.navigationController pushViewController:profileVC animated:YES];
                                            
                                        }];
            
            [alert addAction:yesButton];
            
            // [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            
            if ([fromTime length]>0) {
                
                department = [userDict objectForKey:@"department"];
                
                fDateSel = fdate;
                
                NSDictionary *params;
                
                if ([type isEqualToString:@"Guest"]) {
                    
                    if(([phone isEqualToString:@""])||([phone length]==0)){
                        
                        params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fDateSel,@"sdate":sDateSel,@"pushid_g":@"",@"phone":@"",@"location":@"None"};
                        
                    }else{
                        
                        params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":@"",@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fDateSel,@"sdate":sDateSel,@"pushid_g":@"",@"phone":phone,@"location":@"None"};
                        
                    }
                }
                else
                {
                    if(([phone isEqualToString:@""])||([phone length]==0)){
                        
                        params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fDateSel,@"sdate":sDateSel,@"pushid_g":@"",@"phone":@"",@"location":self->roomId};
                        
                    }else{
                        
                        params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fDateSel,@"sdate":sDateSel,@"pushid_g":@"",@"phone":phone,@"location":self->roomId};
                        
                    }
                }
                
                NSLog(@"params :%@",params);
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                
                NSString *host_url = [NSString stringWithFormat:@"%@bookNew.php",BASE_URL];
                
                [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"JSON: %@", responseObject);
                    
                    [self.btn_Confirm setEnabled:YES];
                    
                    NSDictionary *responseDict = responseObject;
                    
                    NSString *success = [responseDict objectForKey:@"status"];
                    
                    if ([success isEqualToString:@"success"]) {
                        
                        [SVProgressHUD dismiss];
                        
                        [self showViewConfirmation];
                        
                    }else{
                        
                        NSString *msg = [responseDict objectForKey:@"message"];
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                        
                        [SVProgressHUD dismiss];
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Error: %@", error);
                    
                    [self.btn_Confirm setEnabled:YES];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                }];
                
            } else {
                
                [self.btn_Confirm setEnabled:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please select a  time."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                [SVProgressHUD dismiss];
                
            }

            
            
        }
        
        
        
    }
    
}


-(void)bookFlexibleMeeting:(NSString *)type{
    
    if([self notEmptyChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    [self makeTimes];
    
    

    
    
    if (([self.lbl_DepartmentName.text isEqualToString:@""])||([self.lbl_DepartmentName.text length]==0))
    {
        
        [self.btn_Confirm setEnabled:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter Department name."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        
    } else {
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
        
        profimage = [userDict objectForKey:@"profile_image"];
        
        if([profimage isEqualToString:@""]){
            
            [SVProgressHUD dismiss];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"@Hipla"
                                         message:@"You dont have profile pic , please upload your profile pic to create meeting !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            
                                            ProfileDetailViewController *profileVC = [[ProfileDetailViewController alloc]initWithNibName:@"ProfileDetailViewController" bundle:nil];
                                            
                                            profileVC.isFromAddMeeting = @"True";
                                            
                                            [self.view.window.rootViewController presentViewController:profileVC animated:YES completion:nil];
                                            //                                            [self.parentViewController presentViewController:profileVC animated:YES completion:nil];
                                            
                                            
                                            //                                            [self.navigationController pushViewController:profileVC animated:YES];
                                            
                                            
                                            
                                            
                                        }];
            
            
            
            
            
            
            [alert addAction:yesButton];
            //                [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            
        }else{
            
            
            
            if ([fromTime length]>0){
                
                NSDateFormatter *dt = [[NSDateFormatter alloc] init];
                
                [dt setDateFormat:@"yyyy-MM-dd"];
                
                NSString *fulldate1 = [NSString stringWithFormat:@"%@",fdate];
                
                NSDate* date1 = [dt dateFromString:fulldate1];
                
                NSString *fulldate2 = [NSString stringWithFormat:@"%@",sdate];
                
                NSDate* date2 = [dt dateFromString:fulldate2];
                
                NSComparisonResult compare = [date1 compare:date2];
                
                if (compare==NSOrderedAscending) {
                    
                    NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
                    
                    userId = [NSString stringWithFormat:@"%d",(int)[[userDict objectForKey:@"id"] integerValue]];
                    
                    department = [userDict objectForKey:@"department"];
                    
                    NSDictionary *params;
                    
                    if ([type isEqualToString:@"Guest"]) {
                        
                        if(([phone isEqualToString:@""])||([phone length]==0)){
                            
                            params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fdate,@"sdate":sdate,@"pushid_g":@"",@"phone":@"",@"location":@"None"};
                            
                        }else{
                            
                            params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":@"",@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fdate,@"sdate":sdate,@"pushid_g":@"",@"phone":phone,@"location":@"None"};
                            
                        }
                    }
                    else
                    {
                        if(([phone isEqualToString:@""])||([phone length]==0)){
                            
                            params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fdate,@"sdate":sdate,@"pushid_g":@"",@"phone":@"",@"location":self->roomId};
                            
                        }else{
                            
                            params = @{@"contact":[[Userdefaults objectForKey:@"ProfInfo"] objectForKey:@"id"],@"department":department,@"designation":@"CEO",@"from_time":fromTime,@"to_time":toTime,@"duration":duration,@"agenda":_txtfld_Agenda.text,@"fdate":fdate,@"sdate":sdate,@"pushid_g":@"",@"phone":phone,@"location":self->roomId};
                            
                        }
                    }
                    
                    
                    NSLog(@"params :%@",params);
                    
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                    
                    NSString *host_url = [NSString stringWithFormat:@"%@bookNew.php",BASE_URL];
                    
                    [manager POST:host_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSLog(@"JSON: %@", responseObject);
                        
                        [self.btn_Confirm setEnabled:YES];
                        
                        NSDictionary *responseDict = responseObject;
                        
                        NSString *success = [responseDict objectForKey:@"status"];
                        
                        if ([success isEqualToString:@"success"]) {
                            
                            [SVProgressHUD dismiss];
                            
                            [self showViewConfirmationFelxi];
                            
                        }else{
                            
                            NSString *msg = [responseDict objectForKey:@"message"];
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Ok"
                                                                      otherButtonTitles:nil];
                            
                            [alertView show];
                            
                            [SVProgressHUD dismiss];
                            
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        NSLog(@"Error: %@", error);
                        
                        [self.btn_Confirm setEnabled:YES];
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check your internet connection."
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        [SVProgressHUD dismiss];
                        
                    }];
                    
                }
                else
                {
                    [self.btn_Confirm setEnabled:YES];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Second date cannot be less or same with First date."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    [SVProgressHUD dismiss];
                }
                
            }
            else
            {
                [self.btn_Confirm setEnabled:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please select a  time."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                [SVProgressHUD dismiss];
            }
            
        }
        
        
        
        
        
    }
    
}


#pragma mark - Notifications and methods

-(void)AddMeetingViewController:(AddMeetingViewController *)adm getName:(NSString *)name andphNo:(CNContact *)contact
{
    if (self->fDateSel==nil) {
        
        NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
        [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
        
        self->fDateSel = [dateFormatterForAPI stringFromDate:[NSDate date]];
        self->sDateSel = @"";
    }
    
    nameStr = name;
    
    self.lbl_DepartmentName.text = [NSString stringWithFormat:@"%@",nameStr];
    
    NSString *phoneStr;
    
    phone = [[[contact.phoneNumbers firstObject] value] stringValue];
    
    if ([phone length] > 0) {
        
        phoneStr = phone;
        
        department = @"";
    }
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        if ([userType isEqualToString:@"Guest"]) {
            
            [self getEmployeeavailTimeforDate:self->fDateSel];
            
        } else {
            
            [self getUseravailTimeforDate:self->fDateSel];
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
    }];
}


-(void)AddMeetingViewController:(AddMeetingViewController *)adm getName:(NSString *)name withphNo:(NSString *)ph
{
    if (fDateSel==nil) {
        
        NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
        [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
        
        fDateSel = [dateFormatterForAPI stringFromDate:[NSDate date]];
        sDateSel = @"";
    }
    
    nameStr = name;
    
    [self.lbl_DepartmentName setText:nameStr];
    
    NSString *phoneStr;
    
    phoneStr = ph;
    
    department = @"";
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
        if ([userType isEqualToString:@"Guest"]) {
            
            [self getEmployeeavailTimeforDate:self->fDateSel];
            
        } else {
            
            [self getUseravailTimeforDate:self->fDateSel];
        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
    }];
}


-(void)makeTimes
{
    if ([arrTimes count]>0) {
        
        arrIndex = [[NSMutableArray alloc] init];
        
        if ([arrTimes count]>0) {
            
            NSString *isMeetingTimeSlot  = [Userdefaults objectForKey:@"isMeetingTimeSlot"];
            
            if ([isMeetingTimeSlot isEqualToString:@"60 min"]) {
                
                duration = [NSString stringWithFormat:@"%.1f",(float)([arrTimes count]*1.0)];
                
            }
            else
            {
                duration = [NSString stringWithFormat:@"%.1f",(float)([arrTimes count]*0.5)];
            }
            
            for (int i=0; i<[arrTimes count]; i++) {
                
                [arrIndex addObject:[NSString stringWithFormat:@"%d",(int)[hours indexOfObject:[arrTimes objectAtIndex:i]]]];
                
            }
            
            NSArray *copyArr = [arrIndex sortedArrayUsingSelector:@selector(compare:)];
            
            int minInt = (int)[copyArr[0] integerValue];
            int maxInt = (int)[[copyArr lastObject] integerValue];
            
            NSArray *arr1 = [[hours objectAtIndex:minInt] componentsSeparatedByString:@"-"];
            
            fromTime = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:0]];
            
            NSArray *arr2 = [[hours objectAtIndex:maxInt] componentsSeparatedByString:@"-"];
            
            toTime = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:1]];
            
            // NSLog(@"works");
            
        }
        
        /*        for (int i=0; i<[arrTimes count]; i++) {
         
         [arrIndex addObject:[NSString stringWithFormat:@"%d",(int)[hours indexOfObject:[arrTimes objectAtIndex:i]]]];
         
         // NSLog(@"works");
         
         }
         
         NSArray *copyArr = [arrIndex sortedArrayUsingSelector:@selector(compare:)];
         
         int minInt = (int)[copyArr[0] integerValue];
         int maxInt = (int)[[copyArr lastObject] integerValue];
         
         NSArray *arr1 = [[hours objectAtIndex:minInt] componentsSeparatedByString:@"-"];
         
         fromTime = [NSString stringWithFormat:@"%@",[arr1 objectAtIndex:0]];
         
         NSArray *arr2 = [[hours objectAtIndex:maxInt] componentsSeparatedByString:@"-"];
         
         toTime = [NSString stringWithFormat:@"%@",[arr2 objectAtIndex:1]];
         
         
         NSDateFormatter *dt = [[NSDateFormatter alloc] init];
         
         [dt setDateFormat:@"yyyy-MM-dd hh:mm a"];
         
         NSString *fulldate1 = [NSString stringWithFormat:@"%@ %@",fdate,fromTime];
         
         NSDate* date1 = [dt dateFromString:fulldate1];
         
         NSString *fulldate2 = [NSString stringWithFormat:@"%@ %@",fdate,toTime];
         
         NSDate* date2 = [dt dateFromString:fulldate2];
         
         
         NSCalendar *c = [NSCalendar currentCalendar];
         
         
         NSDateComponents *components = [c components:NSCalendarUnitHour fromDate:date1 toDate:date2 options:0];
         
         NSInteger diff = components.hour;
         
         duration = [NSString stringWithFormat:@"%d",(int)diff];   */
        
    }
    else
    {
        arrIndex = [[NSMutableArray alloc] init];
        
        fromTime = @"";
        
        duration = @"";
    }
    
}


-(void)showViewConfirmation
{
    self->_view_Confirmation.layer.shadowRadius = 30;
    self->_view_Confirmation.layer.shadowColor = [[UIColor blackColor] CGColor];
    self->_view_Confirmation.layer.shadowOpacity = 1.0;
    
    NSArray *months = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    
    NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
    [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *Fdate = [dateFormatterForAPI dateFromString:self->fDateSel];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:Fdate];
    
    NSInteger day1 = [components day];
    NSInteger month1 = [components month];
    NSInteger year1 = [components year];
    
    [self.view_DateTime1 setHidden:YES];
    
    [self.view_DateTime2 setHidden:YES];
    
    [self.lblTo setHidden:YES];
    
    self->daySel = [NSString stringWithFormat:@"%d",(int)day1];
    
    self->monthSel = [months objectAtIndex:(month1 -1)];
    
    self->yearSel = [NSString stringWithFormat:@"%d",(int)year1];
    
    NSUInteger characterCount = [self->daySel length];
    
    if (characterCount==1) {
        
        self->daySel = [NSString stringWithFormat:@"0%@",self->daySel];
    }
    
    self.lblDay1.text = daySel;
    self.lblMonth1.text = monthSel;
    self.lblYear1.text = yearSel;
    
    
    self.lblMeetingDateTime.text = [NSString stringWithFormat:@"Meeting on"];
    
    self.lblMeetingWith.text = [NSString stringWithFormat:@"Meeting with %@",self.lbl_DepartmentName.text];
    
    // NSLog(@"%f",self.tabBarController.view.frame.size.height);
    // NSLog(@"%f",_confirmationView.frame.size.height);
    
    self->_view_Confirmation.hidden = NO;
    self.addMeetingBackView.hidden = NO;
    self.VwPicker.hidden = YES;
    
    self.lbl_DepartmentName.text = @"";
    
    self.txtfld_Agenda.text = @"";
    
    //  NSLog(@"%f",_confirmationView.frame.origin.y);
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self->_view_Confirmation.frame = CGRectMake(self->_view_Confirmation.frame.origin.x, 0, self->_view_Confirmation.frame.size.width, self->_view_Confirmation.frame.size.height);
                         
                         //                         self->_view_Confirmation.center = CGPointMake(CGRectGetMidX([UIApplication sharedApplication].keyWindow.bounds),CGRectGetMidY([UIApplication sharedApplication].keyWindow.bounds));
                         
                         [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self->_view_Confirmation];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}



-(void)showViewConfirmationFelxi
{
    self->_view_Confirmation.layer.shadowRadius = 30;
    self->_view_Confirmation.layer.shadowColor = [[UIColor blackColor] CGColor];
    self->_view_Confirmation.layer.shadowOpacity = 1.0;
    
    NSArray *months = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    
    NSDateFormatter *dateFormatterForAPI = [[NSDateFormatter alloc]init];
    [dateFormatterForAPI setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *Fdate = [dateFormatterForAPI dateFromString:self->fdate];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:Fdate];
    
    NSInteger day1 = [components day];
    NSInteger month1 = [components month];
    NSInteger year1 = [components year];
    
    self->daySel = [NSString stringWithFormat:@"%d",(int)day1];
    
    self->monthSel = [months objectAtIndex:(month1 -1)];
    
    self->yearSel = [NSString stringWithFormat:@"%d",(int)year1];
    
    NSUInteger characterCount = [self->daySel length];
    
    if (characterCount==1) {
        
        self->daySel = [NSString stringWithFormat:@"0%@",self->daySel];
    }
    
    [self.view_DateTime setHidden:YES];
    
    [self.lblTo setHidden:NO];
    
    self->_lblDay2.text = self->daySel;
    self->_lblMonth2.text = self->monthSel;
    self->_lblYear2.text = self->yearSel;
    
    NSDate *Sdate = [dateFormatterForAPI dateFromString:self->sdate];
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:Sdate];
    
    NSInteger day2 = [components2 day];
    NSInteger month2 = [components2 month];
    NSInteger year2 = [components2 year];
    
    self->daySel = [NSString stringWithFormat:@"%d",(int)day2];
    
    self->monthSel = [months objectAtIndex:(month2 -1)];
    
    self->yearSel = [NSString stringWithFormat:@"%d",(int)year2];
    
    NSUInteger characterCount2 = [self->daySel length];
    
    if (characterCount2==1) {
        
        self->daySel = [NSString stringWithFormat:@"0%@",self->daySel];
    }
    
    self->_lblDay3.text = self->daySel;
    self->_lblMonth3.text = self->monthSel;
    self->_lblYear3.text = self->yearSel;
    
    self->_lblMeetingDateTime.text = [NSString stringWithFormat:@"Meeting between"];
    
    self->_lblMeetingWith.text = [NSString stringWithFormat:@"Meeting with %@",self.lbl_DepartmentName.text];
    
    // NSLog(@"%f",self.tabBarController.view.frame.size.height);
    // NSLog(@"%f",_confirmationView.frame.size.height);
    
    self->_view_Confirmation.hidden = NO;
    self.addMeetingBackView.hidden = NO;
    
    self.lbl_DepartmentName.text = @"";
    
    self.txtfld_Agenda.text = @"";
    
    
    //  NSLog(@"%f",_confirmationView.frame.origin.y);
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self->_view_Confirmation.frame = CGRectMake(self->_view_Confirmation.frame.origin.x, 0, self->_view_Confirmation.frame.size.width, self->_view_Confirmation.frame.size.height);
                         
                         //                         self->_view_Confirmation.center = CGPointMake(CGRectGetMidX([UIApplication sharedApplication].keyWindow.bounds),CGRectGetMidY([UIApplication sharedApplication].keyWindow.bounds));
                         
                         [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self->_view_Confirmation];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}


-(BOOL)notEmptyChecking{
    
    if(_txtfld_Agenda.text.length<1){
        
        [self.btn_Confirm setEnabled:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Agenda cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [_txtfld_Agenda becomeFirstResponder];
        
        return NO;
        
    }else if([_lbl_DepartmentName.text isEqualToString:@"eg:any name"]){
        
        [self.btn_Confirm setEnabled:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Department cannot be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        return NO;
    }
    
    return YES;
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
