//
//  ManageMeetingTableViewCell.m
//  @TCS
//
//  Created by FNSPL on 20/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "ManageMeetingTableViewCell.h"

@implementation ManageMeetingTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
   
}

- (IBAction)actionBtnCall:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [_mmVC setFmViewController:self.fmViewController];
    
    _mmVC.isAll = self.isAll;
    _mmVC.isPending = self.isPending;
    _mmVC.isConfirmed = self.isConfirmed;
    _mmVC.isGroupAppointment = self.isGroupAppointment;
    
    _mmVC.groupAppointmentListing = self.groupAppointmentListing;
    _mmVC.finalAppointmentListing = self.finalAppointmentListing;
    _mmVC.pendingAppointmentListing = self.pendingAppointmentListing;
    _mmVC.confirmedAppointmentListing = self.confirmedAppointmentListing;
    
    [_mmVC callTap:self];
}

- (IBAction)actionBtnNavigate:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [_mmVC setFmViewController:self.fmViewController];
    
    _mmVC.isAll = self.isAll;
    _mmVC.isPending = self.isPending;
    _mmVC.isConfirmed = self.isConfirmed;
    _mmVC.isGroupAppointment = self.isGroupAppointment;
    
    _mmVC.groupAppointmentListing = self.groupAppointmentListing;
    _mmVC.finalAppointmentListing = self.finalAppointmentListing;
    _mmVC.pendingAppointmentListing = self.pendingAppointmentListing;
    _mmVC.confirmedAppointmentListing = self.confirmedAppointmentListing;
    
    [_mmVC navigateTap:self];
}

- (IBAction)actionBtnCancel:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [_mmVC setFmViewController:self.fmViewController];
    
    _mmVC.isAll = self.isAll;
    _mmVC.isPending = self.isPending;
    _mmVC.isConfirmed = self.isConfirmed;
    _mmVC.isGroupAppointment = self.isGroupAppointment;
    
    _mmVC.groupAppointmentListing = self.groupAppointmentListing;
    _mmVC.finalAppointmentListing = self.finalAppointmentListing;
    _mmVC.pendingAppointmentListing = self.pendingAppointmentListing;
    _mmVC.confirmedAppointmentListing = self.confirmedAppointmentListing;
    
    [_mmVC cancelTap:self];
}


- (IBAction)actionBtnConfirm:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [_mmVC setFmViewController:self.fmViewController];
    
    _mmVC.isAll = self.isAll;
    _mmVC.isPending = self.isPending;
    _mmVC.isConfirmed = self.isConfirmed;
    _mmVC.isGroupAppointment = self.isGroupAppointment;
    
    _mmVC.groupAppointmentListing = self.groupAppointmentListing;
    _mmVC.finalAppointmentListing = self.finalAppointmentListing;
    _mmVC.pendingAppointmentListing = self.pendingAppointmentListing;
    _mmVC.confirmedAppointmentListing = self.confirmedAppointmentListing;
    
    [_mmVC confirmTap:self];
}


@end
